resource "azurerm_virtual_machine" "default" {
  name                  = "${var.instance_name}"
  resource_group_name   = "${var.resource_group_name}"
  location              = "${var.location}"
  vm_size               = "${var.vm_size}"
  network_interface_ids = ["${var.network_interface_ids}"]

  storage_image_reference {
    storage_image_reference_publisher = "${var.storage_image_reference_publisher}"
    storage_image_reference_offer     = "${var.storage_image_reference_offer}"
    storage_image_reference_sku       = "${var.storage_image_reference_sku}"
    storage_image_reference_version   = "${var.storage_image_reference_version}"
  }

  storage_os_disk {
    storage_os_disk_name          = "${var.storage_os_disk_name}"
    storage_os_disk_create_option = "${var.storage_os_disk_create_option}"
    storage_os_disk_caching       = "${var.storage_os_disk_caching}"
  }

  # Optional data disk
  storage_data_disk {
    storage_data_disk_name            = "${var.storage_data_disk_name}"
    storage_data_disk_managed_disk_id = "${var.storage_data_disk_managed_disk_id}"
    storage_data_disk_size_gb         = "${var.storage_data_disk_size_gb}"
    storage_data_disk_create_option   = "${var.storage_data_disk_create_option}"
    storage_data_disk_lun             = "${var.storage_data_disk_size_lun}"
  }

  os_profile_linux_config {
    disable_password_authentication = "${var.disable_password_authentication}"
  }

  tags = ["${var.tags}"]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true
}
