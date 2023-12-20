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
