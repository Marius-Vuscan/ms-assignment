variable "location" {
  description = "The Azure region for resources"
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group"
  default     = "ms-assignment"
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  default     = "aks-cluster"
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  default     = "aks-cluster-dns-prefix"
}

variable "aks_node_pool_vm_size" {
  description = "VM size for the default node pool"
  default     = "Standard_B2s"
}