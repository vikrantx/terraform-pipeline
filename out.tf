output "admin_password" {
  value     = random_password.password[*].result
  sensitive = true
}

output "postgres_username" {
  value = azurerm_postgresql_flexible_server.main.administrator_login
  sensitive = true
}

output "postgres_password" {
  value = azurerm_postgresql_flexible_server.main.administrator_password
  sensitive = true
}