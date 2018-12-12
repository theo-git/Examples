variable "cluster_name" {}
variable "zone" {}

variable "additional_zones" {
  type = "list"
}

variable "http_load_balancing_disabled" {}
variable "horizontal_pod_autoscaling_disabled" {}
variable "kubernetes_dashboard_disabled" {}

variable "description" {}
variable "enable_kubernetes_alpha" {}
variable "enable_legacy_abac" {}
variable "initial_node_count" {}

variable "logging_service" {}

variable "master_auth_username" {}
variable "master_auth_password" {}

variable "min_master_version" {}
variable "monitoring_service" {}
variable "network" {}

variable "node_config_disk_size_gb" {}
variable "node_config_image_type" {}

variable "node_config_labels" {
  type = "map"
}

variable "node_config_machine_type" {}

variable "node_config_metadata" {
  type = "map"
}

variable "node_config_min_cpu_platform" {}

variable "node_config_oauth_scopes" {
  type = "list"
}

variable "node_config_preemptible_enabled" {}
variable "node_config_service_account" {}

variable "node_config_tags" {
  type = "list"
}

variable "node_version" {}
variable "subnetwork" {}

#The lines below are usually not needed.  Leave them commented out unless the values are set in variables.tf
#variable "ip_allocation_policy" {}
#variable "maintenance_policy_daily_maintenance_window_start_time" {}
#variable "master_authorized_networks_config_cidr_blocks" {}
#variable "network_policy_provider" {}
#variable "network_policy_enabled" {}
#variable "node_config" {}
#variable "node_config_local_ssd_count" {}
#variable "node_pool_autoscaling_min_node_count" {}
#variable "node_pool_autoscaling_max_node_count" {}
#variable "node_pool_management_auto_repair_disabled" {}
#variable "node_pool_management_auto_upgrade_disabled" {}
#variable "node_pool_name" {}
#variable "node_pool_name_prefix" {}
##The line below should be commented out if you don't wish to specify a cluster ipv4 cidr block.  Default behavior is for GCP to auto-assign a block.  Setting this variable shouldn't be needed in most cases.
##variable "ipv4_cidr" {}

