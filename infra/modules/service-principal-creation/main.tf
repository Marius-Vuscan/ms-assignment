terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.85.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
  }
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azuread" {
}

resource "azuread_application" "app" {
  display_name = "ms-assignment"
}

resource "azuread_service_principal" "app" {
  client_id = azuread_application.app.client_id
}

resource "azuread_service_principal_password" "app" {
  service_principal_id = azuread_service_principal.app.object_id
  end_date_relative    = "800h"
}

/*
resource "azurerm_role_definition" "aks_role" {
  name        = "Custom_AKS_Operator"
  description = "Custom role for AKS operator"
  scope       = "/subscriptions/${var.subscription_id}"
  permissions {
    actions = [
      "Microsoft.ContainerService/managedClusters/read",
      "Microsoft.ContainerService/managedClusters/write",
      "Microsoft.ContainerService/managedClusters/delete",
    ]
    not_actions = []
  }
}

resource "azurerm_role_definition" "acr_role" {
  name        = "Custom_ACR_Operator"
  description = "Custom role for ACR operator"
  scope       = "/subscriptions/${var.subscription_id}"
  permissions {
    actions = [
      "Microsoft.ContainerRegistry/registries/read",
      "Microsoft.ContainerRegistry/registries/write",
      "Microsoft.ContainerRegistry/registries/delete",
      "Microsoft.ContainerRegistry/registries/push/write",
      "Microsoft.ContainerRegistry/registries/listCredentials/action",
    ]
    not_actions = []
  }
}

resource "azurerm_role_definition" "rg_role" {
  name        = "Custom_RG_Operator"
  description = "Custom role for RG operator"
  scope       = "/subscriptions/${var.subscription_id}"
  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/resourcegroups/*"
    ]
    not_actions = []
  }
}

resource "azurerm_role_assignment" "aks_role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = azurerm_role_definition.aks_role.name
  principal_id         = azuread_service_principal.app.id
  depends_on           = [azurerm_role_definition.aks_role]
}

resource "azurerm_role_assignment" "acr_role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = azurerm_role_definition.acr_role.name
  principal_id         = azuread_service_principal.app.id
  depends_on           = [azurerm_role_definition.acr_role]
}

resource "azurerm_role_assignment" "rg_role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = azurerm_role_definition.rg_role.name
  principal_id         = azuread_service_principal.app.id
  depends_on           = [azurerm_role_definition.rg_role]
}
*/

resource "azurerm_role_assignment" "assign_contributor_role" {
  principal_id         = azuread_service_principal.app.id
  role_definition_name = "Contributor"
  scope                = "/subscriptions/${var.subscription_id}"
}

resource "azurerm_resource_group" "config-rg" {
  name     = "ms-assignment-config"
  location = "West Europe"
}

resource "azurerm_storage_account" "sa" {
  name                     = "msassignmentconfigsa"
  resource_group_name      = azurerm_resource_group.config-rg.name
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "ct" {
  name                 = "terraform-state"
  storage_account_name = azurerm_storage_account.sa.name
}

data "azurerm_storage_account_sas" "state" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = timestamp()
  expiry = timeadd(timestamp(), "800h")

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
    filter  = true
    tag     = true
  }
}

output "client_id" {
  value = azuread_service_principal.app.client_id
}

output "client_secret" {
  value     = nonsensitive(azuread_service_principal_password.app.value)
  sensitive = false
}

output "tenant_id" {
  value = azuread_service_principal.app.application_tenant_id
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "resource_group_name" {
  value = azurerm_resource_group.config-rg.name
}

output "sas_token" {
  value = nonsensitive(data.azurerm_storage_account_sas.state.sas)
}
