# Bastion Compute Engine Instance
resource "google_compute_instance" "bastionvm" {
  project      = var.project_id
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network    = google_compute_network.griffin-dev-vpc.self_link
    subnetwork = google_compute_subnetwork.griffin-dev-wp.self_link 
  }

  network_interface {
    network    = google_compute_network.griffin-prod-vpc.self_link
    subnetwork = google_compute_subnetwork.griffin-prod-mgmt.self_link # Internal prod management subnet
  }
     access_config {
      // Ephemeral public IP - This assigns an external IP to the VM
    }
  }