# terraform/variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-laravel-app"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "app_name" {
  description = "App Service name (must be globally unique)"
  type        = string
}

variable "app_key" {
  description = "Laravel APP_KEY"
  type        = string
  sensitive   = true
}