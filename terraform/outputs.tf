# terraform/outputs.tf
output "app_url" {
  description = "Application URL"
  value       = "https://${azurerm_linux_web_app.app.name}.azurewebsites.net"
}

output "app_service_name" {
  description = "App Service name"
  value       = azurerm_linux_web_app.app.name
}