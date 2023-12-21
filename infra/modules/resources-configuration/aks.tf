resource "azurerm_kubernetes_cluster" "aks" {
  name                              = var.aks_cluster_name
  kubernetes_version                = "1.28.3"
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  dns_prefix                        = var.aks_dns_prefix
  role_based_access_control_enabled = true
  sku_tier                          = "Free"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = var.aks_node_pool_vm_size
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_role_assignment" "aks_acrpull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "ACRPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  depends_on           = [azurerm_kubernetes_cluster.aks, azurerm_container_registry.acr]
}

resource "github_actions_secret" "aks_kube_config" {
  repository      = "ms-assignment"
  secret_name     = "AKS_KUBE_CONFIG"
  plaintext_value = azurerm_kubernetes_cluster.aks.kube_config_raw
}

