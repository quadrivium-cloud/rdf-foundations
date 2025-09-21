// Module to deploy a storage account into a resource group
param name string
param location string
param access_tier string
param sku_tier string
param accountReplication string
param publicNetworkAccess string
param allowBlobPublicAccess bool
param blobSoftDeleteRetentionDays int

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: '${name}${substring(uniqueString(resourceGroup().id), 0, 4)}'
  location: location
  sku: {
    name: '${sku_tier}_${accountReplication}' // E.g., Standard_LRS
  }
  kind: 'StorageV2'
  properties: {
    accessTier: access_tier
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: publicNetworkAccess
    allowBlobPublicAccess: allowBlobPublicAccess
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    deleteRetentionPolicy: {
      enabled: blobSoftDeleteRetentionDays != null
      days: blobSoftDeleteRetentionDays
    }
    isVersioningEnabled: false
  }
}
