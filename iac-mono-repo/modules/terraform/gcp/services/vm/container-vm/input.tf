variable "service_name" {
  description = "The identifying name for the barrels. Examples:[ak, kd]"
}

variable "environment_type" {
  description = "The type of environment in which to deploy. Affects region zone. Choices:[prod,stage,dev]"
}

variable "subnetwork_name" {
  description = "The subnetwork to place the barrel instances in"
}

variable "tags" {
  description = "Additional tags dependent on external variables"
  type        = "list"
  default     = []
}

variable "labels" {
  description = "Additional labels dependent on external variables"
  type        = "map"
}

# Default barrel configuration variables
variable "zone_map" {
  type = "map"

  default = {
    "prod"  = "us-central1-c"
    "stage" = "us-central1-f"
    "dev"   = "us-central1-b"
  }
}

variable "default_labels" {
  description = "Default labels applied to all barrel instances"
  type        = "map"

  default = {
    "application"           = "pipeline"
    "application_subsystem" = "barrel"
    "ops_status"            = "prestage"
  }
}

variable "default_tags" {
  description = "Default tags applied to all barrel instances"
  type        = "list"

  default = [
    "ansible-barrel",
    "barrel",
    "public-routing-for-updates",
  ]
}

variable "machine_type" {
  description = "Machine type for barrel instances. Choices:[n1-standard-1,n1-standard-2,n1-standard-4,n1-standard-8]"
  default     = "n1-standard-8"
}

variable "boot_disk_image" {
  description = "Boot disk base image for barrel instances"
  default     = "ubuntu-os-cloud/ubuntu-1604-lts"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB for barrel instances"
  default     = "20"
}

variable "boot_disk_type" {
  description = "Boot disk type for barrel instances. Choices:[pd-standard,pd-ssd]"
  default     = "pd-standard"
}

variable "service_account_scopes" {
  description = "Enabled scopes within the default service account for barrel instances"
  type        = "list"
  default     = ["cloud-platform"]
}
