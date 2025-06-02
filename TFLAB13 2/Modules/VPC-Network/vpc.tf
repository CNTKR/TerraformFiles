resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  for_each      = { for subnet in var.subnets : subnet.name => subnet }
  project       = var.project_id
  name          = each.value.name  
  ip_cidr_range = each.value.cidr
  region        = var.region
  network       = google_compute_network.vpc.self_link
}