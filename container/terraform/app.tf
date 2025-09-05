# Container Apps Environment (équivalent ECS Cluster / Fargate)
resource "azurerm_container_app_environment" "env" {
  name                       = "cae-${var.app_name}"
  location                   = data.azurerm_resource_group.main.location
  resource_group_name        = data.azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
}

# Container App (équivalent ECS Service/Task)
resource "azurerm_container_app" "app" {
  name                         = "ca-${var.app_name}"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = data.azurerm_resource_group.main.name
  revision_mode                = "Single"  # ou "Multiple" pour blue/green

  # Pas besoin de registry config pour une image publique !

  template {
    # Nombre d'instances (équivalent ECS desired count)
    min_replicas = 1
    max_replicas = 1  # On reste à 1 pour SQLite

    container {
      name   = "laravel-app"
      image  = "glutenfree69/azure_epitech:latest"  # 🎯 TON IMAGE PUBLIQUE
      cpu    = 0.5   # 0.5 vCPU
      memory = "1Gi" # 1 GB RAM

      # Variables d'environnement minimales pour Laravel
      env {
        name  = "APP_ENV"
        value = "production"
      }

      env {
        name  = "APP_DEBUG"
        value = "true"  # Pour debug au début, mets false après
      }

      env {
        name  = "APP_KEY"
        value = "base64:${base64encode(random_string.app_key.result)}"
      }

      env {
        name  = "DB_CONNECTION"
        value = "sqlite"
      }

      env {
        name  = "DB_DATABASE"
        value = "/var/www/html/database/database.sqlite"
      }
    }
  }

  # Ingress = ALB/API Gateway en AWS
  ingress {
    external_enabled = true  # Accessible depuis Internet
    target_port      = 80    # Port de ton conteneur
    transport        = "http"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# Random string pour APP_KEY Laravel
resource "random_string" "app_key" {
  length  = 32
  special = true
}