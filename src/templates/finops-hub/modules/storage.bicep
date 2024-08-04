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

@description('Optional. List of scope IDs to create exports for.')
param exportScopes array

@description('Optional. To use Private Endpoints, add target subnet resource Id.')
param subnetResourceId string = ''

@description('Optional. The user assigned managed identity to use for the storage account.')
param userAssignedManagedIdentityResourceId string

@description('Optional. The principal ID of the user assigned managed identity to use for the storage account.')
param userAssignedManagedIdentityPrincipalId string

@description('Optional. The resource ID of the storage account to use for deployment scripts.')
param dsStorageAccountResourceId string

@description('Optional. To use Private Endpoints, add target subnet resource Id for the deployment scripts')
param scriptsSubnetResourceId string = ''

@description('Optional. To create networking resources.')
@allowed([
  'Public'
  'Private'
  'PrivateWithExistingNetwork'
])
param networkingOption string = 'Public'

@description('Optional. Id of the scripts created subnet.')
param newScriptsSubnetResourceId string

@description('Optional. Id of the created subnet for private endpoints.')
param newsubnetResourceId string

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

module storageAccount 'br/public:avm/res/storage/storage-account:0.11.0' = {
  name: storageAccountName
  params: {
    name: storageAccountName
    skuName: sku
    kind: 'BlockBlobStorage'
    tags: union(tags, tagsByResource[?'Microsoft.Storage/storageAccounts'] ?? {})
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    publicNetworkAccess: (networkingOption == 'Public') ? 'Enabled' : 'Disabled'
    enableHierarchicalNamespace: true
    blobServices: {
      containers: [
        {
          name: 'config'
          publicAccess: 'None'
          metadata: {}
        }
        {
          name: 'msexports'
          publicAccess: 'None'
          metadata: {}
        }
        {
          name: 'ingestion'
          publicAccess: 'None'
          metadata: {}
        }
      ]
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
        principalId: userAssignedManagedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'e40ec5ca-96e0-45a2-b4ff-59039f2c2b59'
        principalId: userAssignedManagedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    networkAcls: (networkingOption == 'Public') ? {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    } : {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: networkingOption == 'PrivateWithExistingNetwork' ? scriptsSubnetResourceId : newScriptsSubnetResourceId
          action: 'Allow'
          state: 'Succeeded'
        }
      ]
    }
  }
}

//------------------------------------------------------------------------------
// Private Endpoints
//------------------------------------------------------------------------------

resource privateEndpointBlob 'Microsoft.Network/privateEndpoints@2022-05-01' = if(networkingOption != 'Public'){
  name: 'pve-blob-${storageAccount.name}'
  location: location
  properties: {

    customNetworkInterfaceName: 'nic-blob-${storageAccount.name}'
    privateLinkServiceConnections: [
      {
        name: 'pve-blob-${storageAccount.name}'
        properties: {
          privateLinkServiceId: storageAccount.outputs.resourceId
          groupIds: ['blob']
        }
      }
    ]
    subnet: {
      id: networkingOption == 'PrivateWithExistingNetwork' ? subnetResourceId : newsubnetResourceId
      properties: {
        privateEndpointNetworkPolicies: 'Enabled'
      }

    }
  }
}

resource privateEndpointDfs 'Microsoft.Network/privateEndpoints@2022-05-01' = if(networkingOption != 'Public'){
  name: 'pve-dfs-${storageAccount.name}'
  location: location
  properties: {

    customNetworkInterfaceName: 'nic-dfs-${storageAccount.name}'
    privateLinkServiceConnections: [
      {
        name: 'pve-dfs-${storageAccount.name}'
        properties: {
          privateLinkServiceId: storageAccount.outputs.resourceId
          groupIds: ['dfs']
        }
      }
    ]
    subnet: {
      id: networkingOption == 'PrivateWithExistingNetwork' ? subnetResourceId : newsubnetResourceId
      properties: {
        privateEndpointNetworkPolicies: 'Enabled'
      }

    }
  }
}



//------------------------------------------------------------------------------
// Settings.json
//------------------------------------------------------------------------------
module uploadSettings 'br/public:avm/res/resources/deployment-script:0.2.4' = {
  name: 'uploadSettings'
  params: {
    name: 'uploadSettings'
    kind: 'AzurePowerShell'
    location: startsWith(location, 'china') ? 'chinaeast2' : location
    tags: union(tags, tagsByResource[?'Microsoft.Resources/deploymentScripts'] ?? {})
    managedIdentities: {
      userAssignedResourcesIds: [
        userAssignedManagedIdentityResourceId
      ]
    }
    azPowerShellVersion: '9.7'
    retentionInterval: 'PT1H'
    environmentVariables: {
      secureList: [
        {
          name: 'ftkVersion'
          value: loadTextContent('./ftkver.txt')
        }
        {
          name: 'exportScopes'
          value: join(exportScopes, '|')
        }
        {
          name: 'storageAccountName'
          value: storageAccountName
        }
        {
          name: 'containerName'
          value: 'config'
        }
      ]
    }
    scriptContent: loadTextContent('./scripts/Copy-FileToAzureBlob.ps1')
    subnetResourceIds: (networkingOption == 'Public') ? [] : (networkingOption == 'Private ') ? [newScriptsSubnetResourceId] : [scriptsSubnetResourceId]
    storageAccountResourceId: (networkingOption == 'Public') ? null : dsStorageAccountResourceId
  }
}

//==============================================================================
// Outputs
//==============================================================================

@description('Resource ID of the storage account created for the hub instance. This must be used when creating the Cost Management export.')
output storageAccountId string = storageAccount.outputs.resourceId

@description('The name of the storage account.')
output name string = storageAccount.name

@description('The name of the container used for configuration settings.')
output configContainer string = 'config'

@description('The name of the container used for Cost Management exports.')
output exportContainer string = 'msexports'

@description('The name of the container used for normalized data ingestion.')
output ingestionContainer string = 'ingestion'
