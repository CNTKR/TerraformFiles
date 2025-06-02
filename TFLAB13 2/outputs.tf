
/*
output "bastion_public_ip" {
  description = "The public IP address of the bastion host."
  value       = google_compute_instance.bastionvm.network_interface[0].access_config[0].nat_ip
}

output "bastion_private_ip_dev_wp" {
  description = "The private IP address of the bastion host in the griffin-dev-wp network."
  value       = google_compute_instance.bastionvm.network_interface[0].network_ip
}

output "bastion_private_ip_dev_mgmt" {
  description = "The private IP address of the bastion host in the griffin-dev-mgmt network."
  value       = google_compute_instance.bastionvm.network_interface[1].network_ip
}

output "bastion_private_ip_prod_mgmt" {
  description = "The private IP address of the bastion host in the griffin-prod-mgmt network."
  value       = google_compute_instance.bastionvm.network_interface[2].network_ip
}
*/