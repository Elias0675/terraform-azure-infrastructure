variable "resource_group_name" {}
variable "location" {}
variable "nsg_id" {}
variable "lb_id" {}
variable "kv_id" {}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "terraform-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "nsg" {
  name                       = "nsg-diagnostics"
  target_resource_id         = var.nsg_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }
  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}

resource "azurerm_monitor_diagnostic_setting" "lb" {
  name                       = "lb-diagnostics"
  target_resource_id         = var.lb_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "kv" {
  name                       = "kv-diagnostics"
  target_resource_id         = var.kv_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "AuditEvent"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

output "law_id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "law_workspace_id" {
  value = azurerm_log_analytics_workspace.law.workspace_id
}