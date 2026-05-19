variable "resource_group_name" {}
variable "location" {}
variable "admin_password" {}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                          = "elias-postgres-prod"
  resource_group_name           = var.resource_group_name
  location                      = "northeurope"
  version                       = "14"
  administrator_login           = "psqladmin"
  administrator_password        = var.admin_password
  sku_name                      = "B_Standard_B1ms"
  storage_mb                    = 32768
  zone                          = "1"
  public_network_access_enabled = false
}

output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}