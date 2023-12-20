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
