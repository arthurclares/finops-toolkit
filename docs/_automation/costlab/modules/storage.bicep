// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

//==============================================================================
// Parameters
//==============================================================================

@description('Required. Name of the hub. Used to ensure unique resource names.')
param hubName string

@description('Required. Suffix to add to the storage account name to ensure uniqueness.')
param uniqueSuffix string

@description('Optional. Azure location where all resources should be created. See https://aka.ms/azureregions. Default: (resource group location).')
param location string = resourceGroup().location

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
])
@description('Optional. Storage SKU to use. LRS = Lowest cost, ZRS = High availability. Note Standard SKUs are not available for Data Lake gen2 storage. Allowed: Premium_LRS, Premium_ZRS. Default: Premium_LRS.')
param sku string = 'Premium_LRS'

@description('Optional. Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management.')
param tags object = {}

@description('Optional. Tags to apply to resources based on their resource type. Resource type specific tags will be merged with tags for all resources.')
param tagsByResource object = {}


//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------

// Generate globally unique storage account name: 3-24 chars; lowercase letters/numbers only
var safeHubName = replace(replace(toLower(hubName), '-', ''), '_', '')
var storageAccountSuffix = uniqueSuffix
var storageAccountName = '${take(safeHubName, 24 - length(storageAccountSuffix))}${storageAccountSuffix}'

//==============================================================================
// Resources
//==============================================================================

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: sku
  }
  kind: 'BlockBlobStorage'
  tags: union(tags, contains(tagsByResource, 'Microsoft.Storage/storageAccounts') ? tagsByResource['Microsoft.Storage/storageAccounts'] : {})
  properties: {
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

//------------------------------------------------------------------------------
// Containers
//------------------------------------------------------------------------------

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  parent: storageAccount
  name: 'default'
}

//==============================================================================
// Outputs
//==============================================================================

@description('The resource ID of the storage account.')
output resourceId string = storageAccount.id

@description('The name of the storage account.')
output name string = storageAccount.name

