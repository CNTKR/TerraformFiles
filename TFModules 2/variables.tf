variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "qwiklabs-gcp-03-a2ef041c26b1"
}

variable "name" {
  description = "Name of the buckets to create."
  type        = string
  default     = "hashashes"
}