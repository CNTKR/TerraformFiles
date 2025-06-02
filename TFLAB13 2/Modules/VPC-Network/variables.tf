

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

variable "vpc_name" {
  description = "The GCP vpvname "
  type = string
}

/*
variable "num_of_subnets" {
  type = string
}
*/

variable "subnets" {
  type = list(object({
    name = string  # Custom name for the subnet
    cidr = string  # CIDR range for the subnet
  }))
}