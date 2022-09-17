resource "azurerm_resource_group" "container-registry" {
  name     = "rg-acr"
  location = var.location

  tags = local.tags

  lifecycle { ignore_changes = [tags["creator"], tags["created"]] }
}

resource "azurerm_container_registry" "acr" {
  name                = "k8sapps"
  resource_group_name = azurerm_resource_group.container-registry.name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false

  retention_policy {
    enabled = true
    days = 5
  }
}