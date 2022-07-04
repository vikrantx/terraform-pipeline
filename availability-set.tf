resource "azurerm_availability_set" "main" {
  name                         = "avset"
  location                     = var.location
  resource_group_name          = module.resource_group.name
  platform_fault_domain_count  = var.app_vm_count
  platform_update_domain_count = var.app_vm_count
  managed                      = true
}