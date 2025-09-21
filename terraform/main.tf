terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Define a random suffix for the storage account name to ensure uniqueness
resource "random_string" "sa_suffix" {
  length  = 4
  upper   = false
  special = false
}

# Create a storage account
resource "azurerm_storage_account" "sa" {
  name                = "${var.name}${random_string.sa_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier             = var.sku_tier
  account_replication_type = var.accountReplication
  access_tier              = var.access_tier
  account_kind             = "StorageV2"

  public_network_access_enabled   = var.publicNetworkAccess
  allow_nested_items_to_be_public = var.allowBlobPublicAccess

  blob_properties {
    delete_retention_policy {
      days = var.blobSoftDeleteRetentionDays
    }
  }
}
