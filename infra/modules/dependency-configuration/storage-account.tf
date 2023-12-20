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
    update  = false
    process = false
    filter  = false
    tag     = false
  }
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
