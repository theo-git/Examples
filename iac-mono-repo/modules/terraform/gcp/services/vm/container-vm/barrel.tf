resource "google_compute_instance" "default" {
  name         = "pipeline-barrel-${var.service_name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone_map[var.environment_type]}"
  tags         = "${concat(var.tags,var.default_tags)}"
  labels       = "${merge(var.default_labels, var.labels)}"

  network_interface {
    subnetwork = "${var.subnetwork_name}"
  }

  service_account {
    scopes = "${var.service_account_scopes}"
  }

  boot_disk {
    initialize_params {
      image = "${var.boot_disk_image}"
      size  = "${var.boot_disk_size}"
      type  = "${var.boot_disk_type}"
    }
  }
}
