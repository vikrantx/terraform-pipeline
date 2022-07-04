resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "pg-flex-server-${terraform.workspace}"
  resource_group_name    = module.resource_group.name
  location               = var.location
  version                = var.postgres_version
  delegated_subnet_id    = azurerm_subnet.tf-private-subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.tf-postgres.id
  administrator_login    = var.db_username
  administrator_password = random_password.password.result
  zone                   = "1"
  storage_mb             = var.postgres_storage_mb
  sku_name               = var.postgres_server_sku
  depends_on             = [azurerm_private_dns_zone_virtual_network_link.tf-postgres]
  tags = {
    "env" = terraform.workspace
  }
}
