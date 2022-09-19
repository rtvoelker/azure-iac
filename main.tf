locals {

  tags = {
    "managed"     = "terraformed"
    "creator"     = var.creator
    "environment" = terraform.workspace
    "app"         = "apps"
    "created"     = timestamp()
  }
}


terraform {
  #  backend "azurerm" {
  #    storage_account_name = "storage-account-name"
  #    container_name       = "container-name"
  #    key                  = "terraformstate"
  #    use_azuread_auth     = true
  #    subscription_id      = ""
  #    tenant_id            = ""
  #  }
  required_providers {
    azurerm = "3.23.0"
    azuread = "2.28.1"
  }

  required_version = "~> 1.0"
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  features {}
}


provider "azuread" {
  tenant_id = var.tenant_id
}

data "azurerm_subscription" "subscription" {
  subscription_id = var.subscription_id
}