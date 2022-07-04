#create virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.machine_size
  admin_username      = var.admin_user
  admin_password      = var.admin_password
  availability_set_id = var.availability_set_id

  network_interface_ids           = var.nic_ids
  disable_password_authentication = false

  os_disk {
    name                 = var.os_disk_name
    caching              = var.caching
    storage_account_type = var.storage_account_type
    disk_size_gb         = var.disk_size_gb
  }

  source_image_reference {
    publisher = var.si_publisher
    offer     = var.si_offer
    sku       = var.si_sku
    version   = var.si_version
  }
}