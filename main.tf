module "resource_group" {
  source   = "./modules/resourcegroup"
  location = var.location
}

module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = module.resource_group.name
  location            = var.location
  vnet_address_space  = var.vnet_address_space
}

resource "random_password" "password" {
  length  = 16
  special = false
  numeric = true
}

module "linux_vm_instance" {
  count                = var.app_vm_count
  source               = "./modules/instance"
  vm_name              = "${var.vm_name}-${count.index}"
  resource_group_name  = module.resource_group.name
  location             = var.location
  machine_size         = var.machine_size
  admin_user           = var.admin_user
  admin_password      = random_password.password.result
  availability_set_id  = azurerm_availability_set.main.id
  nic_ids              = [element(azurerm_network_interface.tf-nic.*.id, count.index)]
  os_disk_name         = "${var.os_disk_name}-${count.index}"
  caching              = var.caching
  storage_account_type = var.storage_account_type
  disk_size_gb         = var.disk_size_gb
  si_publisher         = var.si_publisher
  si_offer             = var.si_offer
  si_sku               = var.si_sku
  si_version           = var.si_version
}
