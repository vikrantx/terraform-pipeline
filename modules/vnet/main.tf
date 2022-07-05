###################### Virtual Network Module #########################
resource "azurerm_virtual_network" "main" {
  name                = "${var.vnet_name}-stage"
  location            = var.location
  address_space       = var.vnet_address_space
  resource_group_name = var.resource_group_name
  tags                = {
    "env" = "stage"
  }
}