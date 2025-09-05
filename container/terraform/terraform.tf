terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

    backend "s3" {
    bucket = "state-yace"
    key    = "azure/laravel-app-chad/terraform.tfstate"
    region = "eu-west-3"
  }
}