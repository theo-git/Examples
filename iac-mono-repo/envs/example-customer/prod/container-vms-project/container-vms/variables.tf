variable "subnetwork_name" {
  description = "Subnetwork to be used"
}

variable "project_labels" {
  description = "Project level labels for this app"
  type        = "map"
}

variable "ops_owner" {
  description = "Owner of the systems on the ops team"
  default     = "john_doe"
}

variable "dev_owner" {
  description = "Owner of the systems on the dev team"
  default     = "jane_smith"
}
