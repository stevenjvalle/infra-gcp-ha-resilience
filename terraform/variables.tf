variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  default     = "us-central1"
  description = "Region to deploy resources"
}

variable "zone" {
  default     = "us-central1-a"
  description = "Zone for VM"
}
