module "tableauserver" {
  source = "../../../../../../modules/terraform/gcp/services/vm/tableau"

  instance_name   = "${var.instance_name}"
  tags            = "${var.tags}"
  machine_type    = "${var.machine_type}"
  instance_zone   = "${var.instance_zone}"
  boot_disk_image = "${var.boot_disk_image}"
  boot_disk_size  = "${var.boot_disk_size}"

  subnetwork_name = "${var.subnetwork_name}"

  internal_ip_address = "${var.internal_ip_address}"
  external_ip_address = "${var.external_ip_address}"

  tableau_domain_name = "${var.tableau_domain_name}"
}

#(Optional)
# name - (Optional) The name of the instance template. If you leave this blank, Terraform will auto-generate a unique name.
# project - (Optional) The project in which the resource belongs. If it is not provided, the provider project is used.
# tags - (Optional) Tags to attach to the instance.
# description - (Optional) A brief description of this resource.
# machine_type - (Required) The machine type to create.
#instance_description = "${var.instance_description}"
# Scheduling block
# preemptible - (Optional) Allows instance to be preempted. This defaults to false.
#preemptible = "${var.preemptible}"
# New boot disk block
# source_image - (Required if source not set) The image from which to initialize this disk. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}.
# auto_delete - (Optional) Whether or not the disk should be auto-deleted. This defaults to true.
#auto_delete = "${var.auto_delete}"
# Metadata block (Optional)
#metadata_key  = "${var.metadata_key}"
#metadata_pair = "${var.metadata_pair}"
# Service account block (Optional)
# email - (Optional) The service account e-mail address. If not given, the default Google Compute Engine service account is used.
#service_account_email = "${var.service_account_email}"
#The lines below are usually not needed.  Leave them commented out unless the values are set in variables.tf
#"can_ip_forward = "${var.can_ip_forward}"
# For existing boot disk block
#"existing_disk_name = "${var.existing_disk_name}"
#network_name    = "${var.network_name}"

