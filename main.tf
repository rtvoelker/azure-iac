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
  #    storage_account_name = "stcommonstorage"
  #    container_name       = "stor-terraformstate"
  #    key                  = "terraformstate"
  #    use_azuread_auth     = true
  #    subscription_id      = "be09d81e-9344-4e45-a3ca-d40f6448cdc2"
  #    tenant_id            = "71660f62-ed66-46b1-a9a6-59e052075879"
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