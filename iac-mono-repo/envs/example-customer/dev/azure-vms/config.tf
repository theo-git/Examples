provider "azurerm" {}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "container_vms"
  location = "West US"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "container_vms"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
}

resource "azurerm_subnet" "example" {
  name                 = "container_vms"
  resource_group_name  = "${azurerm_resource_group.example.name}"
  virtual_network_name = "${azurerm_virtual_network.example.name}"
}

resource "azurerm_network_interface" "example" {
  name                = "acctni"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"

  ip_configuration {
    name                          = "exampleconfig1"
    subnet_id                     = "${azurerm_subnet.example.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_managed_disk" "example" {
  name                 = "datadisk_existing"
  location             = "${azurerm_resource_group.example.location}"
  resource_group_name  = "${azurerm_resource_group.example.name}"
  storage_account_type = "Standard_LRS"
  os_type              = "Linux"
  disk_size_gb         = "80"
}

module "container-vm-1" {
  source = "../../../../modules/terraform/azure/services/vm"

  instance_name                     = "container-vm-1"
  location                          = "${azurerm_resource_group.example.location}"
  resource_group_name               = "${azurerm_resource_group.example.name}"
  network_interface_ids             = ["${azurerm_network_interface.example.id}"]
  vm_size                           = "${var.vm_size}"
  storage_image_reference_publisher = "${var.storage_image_reference_publisher}"
  storage_image_reference_offer     = "${var.storage_image_reference_offer}"
  storage_image_reference_sku       = "${var.storage_image_reference_sku}"
  storage_image_reference_version   = "${var.storage_image_reference_version}"
  storage_os_disk_name              = "${var.storage_os_disk_name}"
  storage_os_disk_create_option     = "${var.storage_os_disk_create_option}"
  storage_os_disk_caching           = "${var.storage_os_disk_caching}"
  storage_data_disk_name            = "${azurerm_managed_disk.example.name}"
  storage_data_disk_managed_disk_id = "${azurerm_managed_disk.example.id}"
  storage_data_disk_size_gb         = "${var.storage_data_disk_size_gb}"
  storage_data_disk_create_option   = "${var.storage_data_disk_create_option}"
  storage_data_disk_size_lun        = "${var.storage_data_disk_size_lun}"
  disable_password_authentication   = "${var.disable_password_authentication}"
  tags                              = "${var.tags}"
}

module "container-vm-2" {
  source = "../../../../modules/terraform/azure/services/vm"

  instance_name                     = "container-vm-2"
  location                          = "${azurerm_resource_group.example.location}"
  resource_group_name               = "${azurerm_resource_group.example.name}"
  network_interface_ids             = ["${azurerm_network_interface.example.id}"]
  vm_size                           = "${var.vm_size}"
  storage_image_reference_publisher = "${var.storage_image_reference_publisher}"
  storage_image_reference_offer     = "${var.storage_image_reference_offer}"
  storage_image_reference_sku       = "${var.storage_image_reference_sku}"
  storage_image_reference_version   = "${var.storage_image_reference_version}"
  storage_os_disk_name              = "${var.storage_os_disk_name}"
  storage_os_disk_create_option     = "${var.storage_os_disk_create_option}"
  storage_os_disk_caching           = "${var.storage_os_disk_caching}"
  storage_data_disk_name            = "${azurerm_managed_disk.example.name}"
  storage_data_disk_managed_disk_id = "${azurerm_managed_disk.example.id}"
  storage_data_disk_size_gb         = "${var.storage_data_disk_size_gb}"
  storage_data_disk_create_option   = "${var.storage_data_disk_create_option}"
  storage_data_disk_size_lun        = "${var.storage_data_disk_size_lun}"
  disable_password_authentication   = "${var.disable_password_authentication}"
  tags                              = "${var.tags}"
}
