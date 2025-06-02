terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.36.1"
    }
  }
}

provider "google" {
  # Configuration options
  project = "qwiklabs-gcp-03-72df496697e5" # The default GCP project to manage resources in
  region  = "us-west3"                     # The default region for regional resources
  zone    = "us-west3-c"
}


resource "google_compute_instance" "default" {
  name         = "nucleus-jumphost-947"
  machine_type = "e2-micro"
  zone         = "us-west3-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }
  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

# 1. Google Compute Instance Template
# This defines the blueprint for your NGINX VM instances
resource "google_compute_instance_template" "nginx_template" {
  name         = "mig-template-nginx-webserver"
  description  = "Template for NGINX web server instances in a MIG."
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11" # Using Debian 11 for the boot disk
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default" # Attaches instances to the default VPC network
  }

  
  # Startup script to install NGINX and modify its default page
  metadata = {
  startup-script = <<EOF
#! /bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Update package lists
apt-get update -y

# Install NGINX
apt-get install -y nginx

# Ensure NGINX service is started and enabled to run on boot
systemctl enable nginx
systemctl start nginx

# Modify the default NGINX index page to include hostname
# Use single quotes for sed to avoid shell interpolation of $HOSTNAME during Terraform plan
# Ensure the path is correct
sed -i "s/nginx/Google Cloud Platform - $(hostname)/" /var/www/html/index.nginx-debian.html

# Restart NGINX to apply the changes
systemctl restart nginx
EOF
}

  tags = ["nginx-webserver"] # IMPORTANT: Add tags for firewall rules and LB health checks
}

# 2. Google Compute Health Check
# This defines how the instance group manager and Load Balancer check the health of instances
resource "google_compute_health_check" "nginx_health_check" {
  name                = "nginx-http-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # An instance is marked unhealthy after 50 seconds (10 * 5s)

  # HTTP health check targeting the NGINX default page
  http_health_check {
    request_path = "/" # Checks the default root path, where NGINX serves content
    port         = 80
  }
}

# 3. Google Compute Regional Managed Instance Group (MIG)
# This manages a group of instances based on the template and uses the health check
resource "google_compute_region_instance_group_manager" "nginx_mig" {
  name             = "nginx-webserver-mig"
  base_instance_name = "nginx-instance"
  region           = "us-west3" # Region where the MIG will operate
  distribution_policy_zones = ["us-west3-a", "us-west3-b"] # Distribute instances across these zones

  version {
    # Reference the instance template using its self_link_unique
    instance_template = google_compute_instance_template.nginx_template.self_link_unique
  }

  target_size = 2 # Desired number of instances in the group

  # Named port for Load Balancers to discover the service port
  named_port {
    name = "http" # This name matches what the backend service expects
    port = 80
  }

  # Autohealing policy using the defined health check
  auto_healing_policies {
    health_check      = google_compute_health_check.nginx_health_check.id
    initial_delay_sec = 60 # Wait 5 minutes before applying autohealing to new instances
  }
}

# 4. Google Compute Firewall Rule
# This allows incoming HTTP traffic to your NGINX instances
resource "google_compute_firewall" "allow_http_ingress" {
  name        = "allow-tcp-rule-993"
  network     = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["nginx-webserver"]

  # IMPORTANT: Include Google's health check IP ranges
  source_ranges = ["0.0.0.0/0", "35.191.0.0/16", "130.211.0.0/22"] # Allow traffic from any IP, including health checks
  direction     = "INGRESS"
  description   = "Allow incoming HTTP (port 80) traffic to NGINX web servers and LB probes, including Google Health Checks."
}

# 10. Google Compute Firewall Rule for Egress (outbound) traffic
# This allows your instances to reach the internet for updates and package installation
resource "google_compute_firewall" "allow_egress_internet" {
  name        = "allow-egress-http-https"
  network     = "default" # Applies to the 'default' VPC network

  allow {
    protocol = "tcp"
    ports    = ["80", "443"] # Allow HTTP and HTTPS outbound traffic
  }

  # Apply this rule to all instances in your MIG (or more broadly if needed)
  target_tags = ["nginx-webserver"] # Apply to instances with the 'nginx-webserver' tag

  destination_ranges = ["0.0.0.0/0"] # Allow traffic to any IP address on the internet
  direction          = "EGRESS"      # Apply to outgoing connections
  description        = "Allow instances to make outbound HTTP/HTTPS connections for package management and other internet access."
}

# --- Load Balancer Components ---

# 5. Backend Service
# Manages the backend instance group and uses the health check
resource "google_compute_backend_service" "nginx_backend_service" {
  name          = "nginx-backend-service"
  protocol      = "HTTP"
  port_name     = "http" # Must match the 'named_port' defined in the instance group
  timeout_sec   = 30
  enable_cdn    = false # Enable CDN if you need content caching

  health_checks = [google_compute_health_check.nginx_health_check.id]

  backend {
    group         = google_compute_region_instance_group_manager.nginx_mig.instance_group # Reference the MIG
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }

  # Explicit dependency to ensure health check is fully ready
  depends_on = [google_compute_health_check.nginx_health_check]
}

# 6. URL Map
# Defines how requests are routed to backend services.
# For simple cases, it routes all traffic to the default backend service.
resource "google_compute_url_map" "nginx_url_map" {
  name            = "nginx-url-map"
  default_service = google_compute_backend_service.nginx_backend_service.id
}

# 7. Target HTTP Proxy
# Receives requests from the forwarding rule and routes them to the URL map
resource "google_compute_target_http_proxy" "nginx_http_proxy" {
  name    = "nginx-http-proxy"
  url_map = google_compute_url_map.nginx_url_map.id
}

# 8. Global IP Address (Reserved)
# It's highly recommended to use a reserved IP for production load balancers
resource "google_compute_global_address" "nginx_lb_ip" {
  name = "nginx-lb-ip"
}

# 9. Global Forwarding Rule
# The entry point for external traffic, routing it to the target HTTP proxy
resource "google_compute_global_forwarding_rule" "nginx_forwarding_rule" {
  name                  = "nginx-forwarding-rule"
  ip_protocol           = "TCP"
  port_range            = "80" # Listens on HTTP port 80
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_http_proxy.nginx_http_proxy.id
  ip_address            = google_compute_global_address.nginx_lb_ip.id
}

# Output the Load Balancer IP address so you can easily access it
output "lb_ip_address" {
  description = "The IP address of the Global HTTP Load Balancer."
  value       = google_compute_global_address.nginx_lb_ip.address
}