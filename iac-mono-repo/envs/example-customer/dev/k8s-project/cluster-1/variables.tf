variable "cluster_name" {
  default = "dev-cluster-1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "additional_zones" {
  default = []
}

variable "http_load_balancing_disabled" {
  default = false
}

variable "horizontal_pod_autoscaling_disabled" {
  default = true
}

variable "kubernetes_dashboard_disabled" {
  default = false
}

variable "description" {
  default = ""
}

variable "enable_kubernetes_alpha" {
  default = false
}

variable "enable_legacy_abac" {
  default = true
}

variable "initial_node_count" {
  default = "4"
}

variable "logging_service" {
  default = "logging.googleapis.com"
}

variable "master_auth_username" {
  default = ""
}

variable "master_auth_password" {
  default = ""
}

variable "min_master_version" {
  default = "1.10.6-gke.11"
}

variable "monitoring_service" {
  default = "monitoring.googleapis.com"
}

variable "network" {
  default = ""
}

variable "node_config_disk_size_gb" {
  default = "100"
}

variable "node_config_image_type" {
  default = "COS"
}

variable "node_config_machine_type" {
  default = "n1-standard-2"
}

variable "node_config_metadata" {
  type    = "map"
  default = {}
}

variable "node_config_min_cpu_platform" {
  default = ""
}

variable "node_config_oauth_scopes" {
  type = "list"

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
}

variable "node_config_preemptible_enabled" {
  default = false
}

variable "node_config_service_account" {
  default = ""
}

variable "node_config_tags" {
  type    = "list"
  default = ["gke", "kubernetes"]
}

variable "node_version" {
  default = "1.10.6-gke.11"
}

variable "subnetwork" {
  default = ""
}

#The lines below are usually not needed.  Leave them commented out unless the values are set in variables.tf
#variable "ip_allocation_policy" {
#   default = ""
#}
#variable "maintenance_policy_daily_maintenance_window_start_time" {
#   default = ""
#}
#variable "master_authorized_networks_config_cidr_blocks" {
#  default = ""
#}
#variable "network_policy_provider" {
#  default = ""
#}
#variable "network_policy_enabled" {
#  default = false
#}
#variable "node_config_local_ssd_count" {
#  default =
#}
#variable "node_pool_autoscaling_min_node_count" {
#  default = "3"
#}
#variable "node_pool_autoscaling_max_node_count" {
#  default = "10"
#}
#variable "node_pool_management_auto_repair_disabled" {
#  default = false
#}
#variable "node_pool_management_auto_upgrade_disabled" {
#  default = false
#}
#variable "node_pool_name" {
#  default = "cluster-edq-node-pool"
#}
#variable "node_pool_name_prefix" {
#  default = ""
#}
#The lines below should be commented out if you don't wish to specify a cluster ipv4 cidr block.  Default behavior is for GCP to auto-assign a block.  Setting this variable shouldn't be needed in most cases.
#variable "ipv4_cidr" {
#  default = ""
#}

