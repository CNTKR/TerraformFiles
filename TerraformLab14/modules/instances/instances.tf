

resource "google_compute_instance" "tf_instance_1" { # Renamed to be unique
  name         = "tf-instance-1"
  machine_type = var.machine_type
  zone         = var.zone # Assumes var.zone is defined elsewhere

  boot_disk {
    initialize_params {
      image = var.boot_disk_image # Using the corrected variable name
    }
  }

  network_interface {
    network    = "tf-vpc-842203" 
    subnetwork = "subnet-01" 

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = <<-EOT
#!/bin/bash
echo "Hello from tf-instance-1 startup script!" > /tmp/startup_output.txt
sudo apt update && sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
  EOT

  allow_stopping_for_update = true
}

resource "google_compute_instance" "tf_instance_2" { # Renamed to be unique
  name         = "tf-instance-2"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
    }
  }

network_interface {
  network    = "tf-vpc-842203" 
  subnetwork = "subnet-02" 
  access_config {
    // Ephemeral public IP (if needed)

    }
  }


  metadata_startup_script = <<-EOT
#!/bin/bash
echo "Hello from tf-instance-2 startup script!" > /tmp/startup_output.txt
sudo apt update && sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
  EOT

  allow_stopping_for_update = true
}

