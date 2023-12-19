provider "azurerm" {
  features {}
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
  name                = "myacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"

  admin_enabled = false
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

