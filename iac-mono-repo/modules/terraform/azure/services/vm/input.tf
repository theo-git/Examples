variable "instance_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "vm_size" {}

variable "network_interface_ids" {
  type = "list"
}

variable "storage_image_reference_publisher" {}
variable "storage_image_reference_offer" {}
variable "storage_image_reference_sku" {}
variable "storage_image_reference_version" {}
variable "storage_os_disk_name" {}
variable "storage_os_disk_create_option" {}
variable "storage_os_disk_caching" {}
variable "storage_data_disk_name" {}
variable "storage_data_disk_managed_disk_id" {}
variable "storage_data_disk_size_gb" {}
variable "storage_data_disk_create_option" {}
variable "storage_data_disk_size_lun" {}
variable "disable_password_authentication" {}

variable "tags" {
  type = "list"
}
