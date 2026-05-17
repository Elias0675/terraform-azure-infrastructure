variable "resource_group_name" {}
variable "location" {}
variable "subnet_id" {}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = "terraform-kv-${substr(uuid(), 0, 6)}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    secret_permissions = ["Get", "Set", "List", "Delete"]
  }
}

resource "random_password" "admin_password" {
  length  = 16
  special = true
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "admin-password"
  value        = random_password.admin_password.result
  key_vault_id = azurerm_key_vault.kv.id
}

output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "admin_password" {
  value     = random_password.admin_password.result
  sensitive = true
}
