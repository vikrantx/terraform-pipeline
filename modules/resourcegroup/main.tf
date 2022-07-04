###################### Resource Group Module #########################
resource "azurerm_resource_group" "main" {
  name     = var.rg_names[terraform.workspace]
  location = var.location
  tags = var.tags
}