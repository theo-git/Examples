labels {
  app_labels = {
    "ops_owner" = "${var.ops_owner}"
    "dev_owner" = "${var.dev_owner}"
  }
}

module "kubernetes" {
  source = "../../../../../../modules/terraform/gcp/services/kubernetes"

  cluster_name                        = "${var.cluster_name}"
  zone                                = "${var.zone}"
  additional_zones                    = "${var.additional_zones}"
  http_load_balancing_disabled        = "${var.http_load_balancing_disabled}"
  horizontal_pod_autoscaling_disabled = "${var.horizontal_pod_autoscaling_disabled}"
  kubernetes_dashboard_disabled       = "${var.kubernetes_dashboard_disabled}"

  description = "${var.description}"

  enable_kubernetes_alpha = "${var.enable_kubernetes_alpha}"
  enable_legacy_abac      = "${var.enable_legacy_abac}"
  initial_node_count      = "${var.initial_node_count}"

  logging_service = "${var.logging_service}"

  master_auth_username = "${var.master_auth_username}"
  master_auth_password = "${var.master_auth_password}"

  min_master_version = "${var.min_master_version}"
  monitoring_service = "${var.monitoring_service}"
  network            = "${var.network}"

  node_config_disk_size_gb = "${var.node_config_disk_size_gb}"
  node_config_image_type   = "${var.node_config_image_type}"
  node_config_labels       = "${merge(
    var.project_labels,
    local.app_labels,
    map(
      "example", "123"
    )
  )}"

  node_config_machine_type        = "${var.node_config_machine_type}"
  node_config_metadata            = "${var.node_config_metadata}"
  node_config_min_cpu_platform    = "${var.node_config_min_cpu_platform}"
  node_config_oauth_scopes        = "${var.node_config_oauth_scopes}"
  node_config_preemptible_enabled = "${var.node_config_preemptible_enabled}"
  node_config_service_account     = "${var.node_config_service_account}"
  node_config_tags                = "${var.node_config_tags}"

  node_version = "${var.node_version}"
  subnetwork   = "${var.subnetwork}"
}

#The lines below are usually not needed.  Leave them commented out unless the values are set in variables.tf
#  ip_allocation_policy = "${var.ip_allocation_policy}"
#  maintenance_policy_daily_maintenance_window_start_time = "${var.maintenance_policy_daily_maintenance_window_start_time}"
#  master_authorized_networks_config_cidr_blocks = "${var.master_authorized_networks_config_cidr_blocks}"
#  network_policy_provider = "${var.network_policy_provider}"
#  network_policy_enabled = "${var.network_policy_enabled}"
#  node_config_local_ssd_count = "${var.node_config_local_ssd_count}"
#  node_pool_autoscaling_min_node_count = "${var.node_pool_autoscaling_min_node_count}"
#  node_pool_autoscaling_max_node_count = "${var.node_pool_autoscaling_max_node_count}"
#  node_pool_management_auto_repair_disabled = "${var.node_pool_management_auto_repair_disabled}"
#  node_pool_management_auto_upgrade_disabled = "${var.node_pool_management_auto_upgrade_disabled}"
#  node_pool_name = "${var.node_pool_name}"
#  node_pool_name_prefix = "${var.node_pool_name_prefix}"
#The line below should be commented out if you don't wish to specify a cluster ipv4 cidr block.  Default behavior is for GCP to auto-assign a block.  Setting this variable shouldn't be needed in most cases.
#  ipv4_cidr = "${var.ipv4_cidr}"

