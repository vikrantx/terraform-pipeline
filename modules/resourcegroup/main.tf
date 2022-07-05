###################### Resource Group Module #########################
resource "azurerm_resource_group" "main" {
  name     = var.rg_names["stage"]
  location = var.location
  tags = var.tags
}