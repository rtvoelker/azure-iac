resource "azurerm_resource_group" "vnet" {
  name     = "rg-vnet"
  location = var.location

  tags = local.tags

  lifecycle { ignore_changes = [tags["creator"], tags["created"]] }
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-apps"
  location            = var.location
  resource_group_name = azurerm_resource_group.kubernetes.name

  address_space = ["10.0.0.0/8"]

  tags = local.tags
  lifecycle { ignore_changes = [tags["creator"], tags["created"]] }
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-apps"
  resource_group_name  = azurerm_resource_group.kubernetes.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.1.0.0/16"]

  private_link_service_network_policies_enabled = true
  service_endpoints = [
    "Microsoft.Sql", "Microsoft.Storage", "Microsoft.EventHub", "Microsoft.AzureCosmosDB",
    "Microsoft.KeyVault"
  ]
}
