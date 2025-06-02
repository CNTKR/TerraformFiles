terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.37.0"
    }
  }
}

terraform {
  backend "gcs" {
    bucket  = "tf-bucket-299721"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "instances" {
  source = "./modules/instances"
}

module "storage" {
  source = "./modules/storage"
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "10.0.0" 

  project_id   = var.project_id # You MUST pass your project_id here
  network_name = "tf-vpc-842203" # This is the name of the VPC network itself

  subnets = [
    {
      subnet_name           = "subnet-01"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-west1" # Ensure this region is consistent with your VM zones
      subnet_private_access = true       # Common for private connectivity
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1" # Ensure this region is consistent
      subnet_private_access = true
      subnet_flow_logs      = false
    }
  ]
  routing_mode = "GLOBAL" # Based on your "route = global"
}


resource "google_compute_firewall" "tf-firewall" {
  name    = "tf-firewall"
  network = "tf-vpc-842203"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"] # Allow from any IP address
}


