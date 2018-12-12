variable "instance_name" {}

variable "tags" {
  type = "list"
}

variable "machine_type" {}
variable "instance_zone" {}
variable "boot_disk_image" {}
variable "boot_disk_size" {}

variable "service_account_email" {
  default = ""
}

variable "service_account_scopes" {
  type    = "list"
  default = ["userinfo-email", "compute-ro", "storage-ro"]
}

variable "subnetwork_name" {}
variable "internal_ip_address" {}
variable "external_ip_address" {}

variable "tableau_domain_name" {}

# Compute Instance info
# name - (Optional) The name of the instance template. If you leave this blank, Terraform will auto-generate a unique name.
# project - (Optional) The project in which the resource belongs. If it is not provided, the provider project is used.
# tags - (Optional) Tags to attach to the instance.
# description - (Optional) A brief description of this resource.
# machine_type - (Required) The machine type to create.
#variable "instance_description" {}
# Scheduling block (Optional)
# preemptible - (Optional) Allows instance to be preempted. This defaults to false.
#variable "preemptible" {}
# New boot disk block
# source_image - (Required if source not set) The image from which to initialize this disk. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}.
# auto_delete - (Optional) Whether or not the disk should be auto-deleted. This defaults to true.
#variable "auto_delete" {}
# Network interface block (Optional)
# network - (Optional) The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks.
#variable "network_name" {}
# subnetwork - (Optional) the name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided.
# Metadata block (Optional)
#variable "metadata_key" {}
#variable "metadata_pair" {}
#The lines below are usually not needed.  Leave them commented out unless the values are set in variables.tf
#variable "can_ip_forward" {}
# For existing boot disk block
#variable "existing_disk_name" {}

