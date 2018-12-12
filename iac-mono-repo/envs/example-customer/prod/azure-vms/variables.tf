// Azure VM variables

variable "instance_name" {
  default = ""
}

variable "resource_group_name" {}
variable "location" {
  default = "West US 2"
}

variable "vm_size" {
  default = "Standard_DS1_v2"
}

variable "network_interface_ids" {
  type = "list"
}

variable "storage_image_reference_publisher" {
  default = "Canonical"
}

variable "storage_image_reference_offer" {
  default = "UbuntuServer"
}

variable "storage_image_reference_sku" {
  default = "16.04-LTS"
}

variable "storage_image_reference_version" {
  default = "latest"
}

variable "storage_os_disk_name" {
  default = "example"
}

variable "storage_os_disk_create_option" {
  default = "FromImage"
}

variable "storage_os_disk_caching" {
  default = "ReadWrite"
}

variable "storage_data_disk_name" {
  default = "example_datadisk_new"
}

variable "storage_data_disk_managed_disk_id" {
  default = ""
}

variable "storage_data_disk_size_gb" {
  default = "80"
}

variable "storage_data_disk_create_option" {
  default = "Empty"
}

variable "storage_data_disk_size_lun" {
  default = 0
}

variable "disable_password_authentication" {
  default = true
}

variable "tags" {
  type = list
  default = []
}
