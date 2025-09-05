# terraform/variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-par_10"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "France Central"
}

variable "app_name" {
  description = "App Service name (must be globally unique)"
  type        = string
  default     = "Laravel"
}

variable "app_key" {
  description = "Laravel APP_KEY"
  type        = string
  sensitive   = true
  default     = "base64:DJYTvaRkEZ/YcQsX3TMpB0iCjgme2rhlIOus9A1hnj4="
}