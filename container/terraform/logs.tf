# Log Analytics (requis pour Container Apps, équivalent CloudWatch)
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "law-${var.app_name}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}