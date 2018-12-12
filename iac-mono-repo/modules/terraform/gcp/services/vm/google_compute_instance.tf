resource "google_compute_instance" "default" {
  name         = "${var.instance_name}"
  tags         = ["${var.tags}"]
  machine_type = "${var.machine_type}"
  zone         = "${var.instance_zone}"

  service_account {
    email  = "${var.service_account_email}"
    scopes = "${var.service_account_scopes}"
  }

  boot_disk {
    initialize_params {
      image = "${var.boot_disk_image}"

      #(Optional) The size of the image in gigabytes. If not specified, it will inherit the size of its base image.
      size = "${var.boot_disk_size}"

      #Type: pd-standard or pd-ssd.
      type = "${var.boot_disk_type}"
    }
  }

  network_interface {
    network = "${var.network_name}"

    #(Optional)
    #subnetwork = "${var.subnetwork_name}"
    #  // Change this if it's for something like gitlab that needs a static IP
    #// The private IP address to assign to the instance. If empty, the address will be automatically assigned.
    #  address    = ""
  }

  #(Optional)
  #instance_description = "${var.instance_description}"
  # source_image = "${var.source_image}"
  #(Optional)
  #can_ip_forward       = false
  #(Optional)
  #scheduling {
  #  preemptible = "${var.preemptible_boolean}"
  #}
  #(Optional)
  #auto_delete  = "${var.auto_delete}"
  #(Optional)
  #metadata {
  #  "${var.metadata_key}" = "${var.metadata_pair}"
  #}
}
