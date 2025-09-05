output "app_url" {
  value = "https://${azurerm_container_app.app.latest_revision_fqdn}"
  description = "🚀 URL DE TON APP"
}

output "resource_group" {
  value = data.azurerm_resource_group.main.name
  description = "Resource Group (pour les commandes az)"
}

output "container_app_name" {
  value = azurerm_container_app.app.name
  description = "Nom du Container App"
}