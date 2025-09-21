targetScope = 'subscription'

// Parameters from main.bicepparam
param name string
param sku_tier string
param access_tier string
param accountReplication string
param publicNetworkAccess bool
param allowBlobPublicAccess bool
param blobSoftDeleteRetentionDays int
param resource_group_name string = 'rg-rdf-foundations-bicep'
param resource_group_location string = 'uksouth'

// Create the resource group at subscription scope
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resource_group_name
  location: resource_group_location
}

// Deploy the storage account into the resource group via a module
module saModule './storageAccount.bicep' = {
  name: 'deployStorage'
  scope: resourceGroup(rg.name)
  params: {
    name: name
    location: rg.location
    access_tier: access_tier
    sku_tier: sku_tier
    accountReplication: accountReplication
    publicNetworkAccess: publicNetworkAccess ? 'Enabled' : 'Disabled'
    allowBlobPublicAccess: allowBlobPublicAccess
    blobSoftDeleteRetentionDays: blobSoftDeleteRetentionDays
  }
}
