# main.tf

module "griffin-dev-vpc" {
  source     = "./Modules/VPC-Network"
  project_id = var.project_id
  vpc_name   = var.VPC-DEV
  region     = var.region
  zone       = var.zone
  subnets = [
    { name = var.VPC-DEV-Sub1-Name, cidr = var.VPC-DEV-Sub1-Range },
    { name = var.VPC-DEV-Sub2-Name, cidr = var.VPC-DEV-Sub2-Range }
  ]
}

module "griffin-prod-vpc" {
  source     = "./Modules/VPC-Network"
  project_id = var.project_id
  vpc_name   = var.VPC-PROD
  region     = var.region
  zone       = var.zone
  subnets = [
    { name = var.VPC-PROD-Sub1-Name, cidr = var.VPC-PROD-Sub1-Range },
    { name = var.VPC-PROD-Sub2-Name, cidr = var.VPC-PROD-Sub2-Range }
  ]
}


module "bastionvm" {
  source       = "./Modules/Bastion-Vm"
  instance_name         = var.instance_name
  project_id   = var.project_id
  instance_type = var.instance_type
  region       = var.region
  zone         = var.zone

  # ... (variables for the module)
}


/*
# Firewall Rule for Bastion Host SSH Access
resource "google_compute_firewall" "bastion_ssh_access" {
  project     = var.project_id
  name        = "${var.instance_name}-ssh-access"
  network     = google_compute_network.griffin-dev-vpc.self_link # Assuming public interface is on dev-vpc

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  #source_ranges = var.ssh_source_ranges
  target_tags   = ["${var.instance_name}-ssh"] # Apply this tag to your bastion VM
  description   = "Allow SSH to bastion host from specified IPs"
}

*/

/*
  # SSH Key for access
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }
  # Assign the target tag for the SSH firewall rule
  tags = ["${var.instance_name}-ssh"]
*/
