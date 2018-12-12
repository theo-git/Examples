labels {
  app_labels = {
    "ops_owner" = "${var.ops_owner}"
    "dev_owner" = "${var.dev_owner}"
  }
}

module "${var.environment_type}_container_vm_1" {
  source = "../../../../../modules/terraform/gcp/services/vm/container-vm"

  service_name     = "1"
  subnetwork_name  = "${var.subnetwork_name}"
  environment_type = "dev"
  tags             = ["ansible-container-vm-1"]

  labels = "${merge(
    var.project_labels, 
    local.app_labels,
    map(
      "db_instance", "1"
    )
  )}"
}

module "${var.environment_type}_container_vm_2" {
  source = "../../../../../modules/terraform/gcp/services/vm/container-vm"

  service_name     = "2"
  subnetwork_name  = "${var.subnetwork_name}"
  environment_type = "dev"
  tags             = ["ansible-container-vm-2"]

  labels = "${merge(
    var.project_labels, 
    local.app_labels,
    map(
      "db_instance", "2"
    )
  )}"
}
