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
    }
  }

  network_interface {
    #'subnetwork' is preferred over 'network'.  Either 'network' or 'subnetwork' must be provided.  Both cannot be provided at once.
    subnetwork = "${var.subnetwork_name}"

    #Internal IP: Allows the option to set a static IP address or not.
    address = "${var.internal_ip_address}"

    #External IP: Allows the option to create a VM with a public IP or not and make it static or ephemeral. 
    access_config {
      # External IP
      nat_ip = "${var.external_ip_address}"
    }
  }

  #This writes the VM's private IP to a file that the next provisioner requires to run the Ansible command.
  provisioner "local-exec" {
    #command = "echo ${self.network_interface.0.address} > private_ip"
    command = "echo ${self.network_interface.0.access_config.0.assigned_nat_ip} > target_ip"
  }

  #This is needed to generate & run the Ansible command needed to configure the VM internally.
  provisioner "local-exec" {
    command = "chmod +x generate_ansible_command.sh && ./generate_ansible_command.sh"

    #This is needed to ensure that if the Ansible script fails to run, that the resource is marked as tainted so that Terraform will rebuild it and run Ansible again after the issue is resolved.
    on_failure  = "continue"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "google_dns_record_set" "tableau_dns_a_record" {
  name = "${var.tableau_domain_name}."
  type = "A"
  ttl  = 60

  managed_zone = "example"

  rrdatas = ["${google_compute_instance.default.network_interface.0.access_config.0.assigned_nat_ip}"]

  project = "example-project"
}

#(Optional) - Because many projects have several subnetworks, it is preferrable to use 'subnetwork' above instead of 'network'.
#network = "${var.network_name}"
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

