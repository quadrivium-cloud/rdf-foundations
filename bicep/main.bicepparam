using 'main.bicep'

param name ='strdfstorage'
param sku_tier ='Standard'
param access_tier ='Cool'
param accountReplication ='LRS'
param publicNetworkAccess = false
param allowBlobPublicAccess = false
param blobSoftDeleteRetentionDays = 7
