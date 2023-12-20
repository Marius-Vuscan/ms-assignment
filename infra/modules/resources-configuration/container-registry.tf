terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "msassignmentconfigsa"
    container_name = "terraform-state"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "github" {
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group"
  default     = "ms-assignment"
}

variable "location" {
  description = "The Azure region for resources"
  default     = "West Europe"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "msassignmentmvacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"

  admin_enabled = true
}

resource "github_actions_secret" "acr_login_server" {
  repository      = "ms-assignment"
  secret_name     = "ACR_LOGIN_SERVER"
  plaintext_value = azurerm_container_registry.acr.login_server
}

resource "github_actions_secret" "acr_username" {
  repository      = "ms-assignment"
  secret_name     = "ACR_USERNAME"
  plaintext_value = azurerm_container_registry.acr.admin_username
}

resource "github_actions_secret" "acr_password" {
  repository      = "ms-assignment"
  secret_name     = "ACR_PASSWORD"
  plaintext_value = azurerm_container_registry.acr.admin_password
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}
