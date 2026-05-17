variable "resource_group_name" {}
variable "location" {}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "terraform-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

output "law_id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "law_workspace_id" {
  value = azurerm_log_analytics_workspace.law.workspace_id
}
