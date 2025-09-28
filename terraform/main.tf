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
  name     = "rg-${var.org_prefix}-${var.workload.slug}-${var.environment}-${var.location.short_code}-01" # Example: rg-qc-rdf-foundations-terraform-dev-uks-01
  location = var.location.name
}

# Define a random suffix for the storage account name to ensure uniqueness
resource "random_string" "sa_suffix" {
  length  = 4
  upper   = false
  special = false
}

# Create a storage account
resource "azurerm_storage_account" "sa" {
  name                = "st${var.org_prefix}${var.workload.slug}${var.environment}${var.location.short_code}${random_string.sa_suffix.result}" # Storage account names must be globally unique and between 3-24 characters. E.g., "stqcrdftfdevuks1234"
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
