variable "project_id" {
  description = "Holds the working project ID."
  type        = string
  default     = "qwiklabs-gcp-03-28086aa8ae6c"
}

variable "region" {
  description = "The default region for resource deployment."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The default zone for resource deployment."
  type        = string
  default     = "us-central1-b"
}