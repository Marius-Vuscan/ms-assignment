resource "azurerm_role_assignment" "aks_acrpull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AksAcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity.0.object_id
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
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
