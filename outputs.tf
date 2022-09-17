output "k8s_cluster_name" {
  value = azurerm_kubernetes_cluster.default.name
}

output "k8s_resource_group_name" {
  value = azurerm_resource_group.kubernetes.name
}

output "subscription_id" {
  value = data.azurerm_subscription.subscription.subscription_id
}