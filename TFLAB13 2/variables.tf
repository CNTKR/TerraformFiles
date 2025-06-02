

variable "project_id" {
  description = "Your Google Cloud Project ID"
  type        = string
  default     = "qwiklabs-gcp-00-128379155b29"
}

variable "region" {
  description = "The GCP region for your resources (e.g., asia-south1)"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone for the bastion host (e.g., asia-south1-a)"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Name for the bastion host instance"
  type        = string
  default     = "bastionvm"
}

variable "instance_type" {
  description = "The machine type for the bastion host (e.g., e2-micro)"
  type        = string
  default     = "e2-micro"
}

/* 
variable "ssh_source_ranges" {
  description = "List of CIDR blocks from which SSH access is allowed to the bastion host. Use your public IP or a VPN IP."
  type        = list(string)
  default     = ["0.0.0.0/0"] # <<<--- !!! DANGER: REPLACE WITH YOUR ACTUAL PUBLIC IP CIDR (e.g., "YOUR_PUBLIC_IP/32") !!!
}


variable "ssh_user" {
  description = "The username for SSH access on the bastion host."
  type        = string
  default     = "gcp-user" # Or 'debian' for Debian images, etc.
}

variable "ssh_public_key_path" {
  description = "The file path to your SSH public key (e.g., ~/.ssh/id_rsa.pub)."
  type        = string
}

*/

# VPC1 Dev
variable "VPC-DEV" {
  description = "Name for the griffin-dev-vpc network"
  type        = string
  default     = "griffin-dev-vpc" # Or your desired name
}

variable "VPC-DEV-Sub1-Name" {
  description = "Name for the griffin-dev-wp subnetwork"
  type        = string
  default     = "griffin-dev-wp" # Or your desired name
}

variable "VPC-DEV-Sub1-Range" {
  description = "IP CIDR range for griffin-dev-wp"
  type        = string
  default     = "192.168.16.0/20"
}

variable "VPC-DEV-Sub2-Name" {
  description = "Name for the griffin-dev-mgmt subnetwork"
  type        = string
  default     = "griffin-dev-mgmt" # Or your desired name
}

variable "VPC-DEV-Sub2-Range" {
  description = "IP CIDR range for griffin-dev-mgmt"
  type        = string
  default     = "192.168.32.0/20"
}


# VPC2 Prod
variable "VPC-PROD" {
  description = "Name for the griffin-prod-vpc network"
  type        = string
  default     = "griffin-prod-vpc" # Or your desired name
}

variable "VPC-PROD-Sub1-Name" {
  description = "Name for the griffin-prod-wp subnetwork"
  type        = string
  default     = "griffin-prod-wp" # Or your desired name
}

variable "VPC-PROD-Sub1-Range" {
  description = "IP CIDR range for griffin-prod-wp"
  type        = string
  default     = "192.168.48.0/20"
}

variable "VPC-PROD-Sub2-Name" {
  description = "Name for the griffin-prod-mgmt subnetwork"
  type        = string
  default     = "griffin-prod-mgmt" # Or your desired name
}

variable "VPC-PROD-Sub2-Range" {
  description = "IP CIDR range for griffin-prod-mgmt"
  type        = string
  default     = "192.168.64.0/20"
}
