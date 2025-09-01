# terraform/main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

    backend "s3" {
    bucket = "state-yace"
    key    = "azure/laravel-app/terraform.tfstate"
    region = "eu-west-3"
  }
}

provider "azurerm" {
  features {}
}

# Utiliser le resource group existant
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# App Service Plan
resource "azurerm_service_plan" "app_plan" {
  name                = "${var.app_name}-plan"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# Azure Linux Web App (App Service)
resource "azurerm_linux_web_app" "app" {
  name                = var.app_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    always_on = true
    
    application_stack {
      php_version = "8.2"
    }
  }

  app_settings = {
    "APP_NAME"         = "Laravel"
    "APP_ENV"          = "production"
    "APP_KEY"          = var.app_key
    "APP_DEBUG"        = "false"
    "APP_URL"          = "https://${var.app_name}.azurewebsites.net"
    
    # Utiliser SQLite au lieu de MySQL
    "DB_CONNECTION"    = "sqlite"
    "DB_DATABASE"      = "/home/site/wwwroot/database/database.sqlite"
    
    "LOG_CHANNEL"      = "stack"
    "LOG_LEVEL"        = "error"
    
    # Optimisations Laravel pour production
    "CACHE_DRIVER"     = "file"
    "SESSION_DRIVER"   = "file"
    "QUEUE_CONNECTION" = "sync"

    "WEBSITES_DOCUMENT_ROOT" = "/home/site/wwwroot/public"
  }
}
