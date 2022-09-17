resource "azurerm_key_vault" "k8s_secret_store" {
  name                      = "kv-k8s-apps"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.kubernetes.name
  sku_name                  = "standard"
  tenant_id                 = var.tenant_id
  enable_rbac_authorization = true

  tags = local.tags
  lifecycle {
    ignore_changes = [
      tags["creator"],
      tags["created"],
      network_acls["ip_rules"]
    ]
  }
}