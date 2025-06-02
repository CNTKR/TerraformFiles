variable "project_id" {
  description = "Your Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for your resources (e.g., asia-south1)"
  type        = string
}

variable "zone" {
  description = "The GCP zone for the bastion host (e.g., asia-south1-a)"
  type        = string
}

variable "instance_name" {
  description = "Name for the bastion host instance"
  type        = string
}

variable "instance_type" {
  description = "The machine type for the bastion host (e.g., e2-micro)"
  type        = string
}