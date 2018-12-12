// GCP Project Variables
variable "project_name" {
  description = "Chosen project name for the project. Will affect naming of buckets, networks and the like."
  default     = "container-vms-project"
}

variable "region" {
  description = "Region for the project"
  default     = "us-central1"
}

variable "subnetwork_name" {
  description = "Subnetwork to be used for the container-vms"
  default     = "example-us-central1"
}

variable "cidr" {
  description = "Default CIDR to be used for the project"
  default     = "10.2.0.0/21"
}

variable "cidr_gw" {
  description = "Default CIDR GW"
  default     = "10.2.0.1"
}

variable "billing_account" {
  description = "Billing account for the project"
  default     = "000000-000000-000000"
}

variable "org_id" {
  description = "Google Org ID for the project"
  default     = "555555555555"
}

variable "environment_type" {
  description = "The type of environment. Options:[prod, stage, dev]"
  default     = "prod"
}

variable "customer" {
  description = "The customer this infrastructure supports"
  default     = "example-customer"
}

variable "system" {
  description = "The system this infrastructure supports"
  default     = "example"
}
