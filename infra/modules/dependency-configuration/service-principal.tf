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

resource "azurerm_role_assignment" "assign_contributor_role" {
  principal_id         = azuread_service_principal.app.id
  role_definition_name = "Contributor"
  scope                = "/subscriptions/${var.subscription_id}"
}
