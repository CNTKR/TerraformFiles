variable "project_id" {
  description = "Holds the working project ID."
  type        = string
  default     = "qwiklabs-gcp-03-28086aa8ae6c"
}

variable "region" {
  description = "The default region for resource deployment."
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "The default zone for resource deployment."
  type        = string
  default     = "us-west1-a"
}

variable "machine_type" {
  description = "The default machine type value"
  default     = "e2-standard-2" # Corrected format, remove (2 vCPUs, 1 GB Memory) as it's not part of the literal machine type string
}

variable "boot_disk_image" { # <--- RENAMED FROM "boot_disk"
  description = "The default boot disk image value"
  type        = string # Added type for clarity
  default     = "debian-cloud/debian-11" # Corrected image format, year is 2024 now for debian-11, and remove leading space
}

variable "network_name" { # <--- RENAMED FROM "network_interface"
  description = "The default network name value"
  type        = string # Added type for clarity
  default     = "default"
}