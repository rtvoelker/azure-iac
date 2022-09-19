locals {
  node_resource_group = format("%s-infrastructure", "${azurerm_resource_group.kubernetes.name}")
  cluster_name        = "k8s-apps"
}

resource "azurerm_resource_group" "kubernetes" {
  name     = "rg-plat-kubernetes"
  location = var.location

  tags = local.tags

  lifecycle { ignore_changes = [tags["creator"], tags["created"]] }
}

resource "azuread_group" "kubernetes-admins" {
  display_name            = "K8sAdministrators"
  description             = "K8s Administrators"
  prevent_duplicate_names = true
  security_enabled        = true
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = local.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.kubernetes.name
  node_resource_group = local.node_resource_group

  dns_prefix = "k8s-apps"

  kubernetes_version = var.k8s_version
  sku_tier           = "Free"

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed = true
    admin_group_object_ids = [
      azuread_group.kubernetes-admins.object_id
    ]
  }

  automatic_channel_upgrade = "stable"

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"

    load_balancer_sku = "standard"
  }

  private_cluster_enabled = false

  api_server_authorized_ip_ranges = [
    // allow only the outbound public IP of the Standard SKU load balancer 0.0.0.0/32 by default
    "0.0.0.0/32"
  ]

  default_node_pool {
    name                 = "nodepool"
    vm_size              = "standard_b4ms"
    node_count           = "2"
    zones                = ["1"]
    orchestrator_version = var.k8s_version
    type                 = "VirtualMachineScaleSets"
    vnet_subnet_id       = azurerm_subnet.subnet.id

  }
  azure_policy_enabled = false

  key_vault_secrets_provider {
    ## rotation disabled until the add-on is out of preview (currently the rotation does not work, presumably because our k8s secrets are generated without hashSuffixes, although we did not configure kustomize to omit the suffix)
    secret_rotation_enabled  = true
    secret_rotation_interval = "1m"
  }

  http_application_routing_enabled = false

  tags = local.tags

  lifecycle { ignore_changes = [tags["creator"], tags["created"]] }
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                            = azurerm_container_registry.acr.id
  description = "Grant the K8s cluster pull access to the container registry"
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "k8s_read_access_secrets" {
  scope                = azurerm_key_vault.k8s_secret_store.id
  description          = "Grant the K8s cluster read access to secrets only of the key vault"
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.default.key_vault_secrets_provider[0].secret_identity[0].object_id
}