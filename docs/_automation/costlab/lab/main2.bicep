//==============================================================================
// Parameters
//==============================================================================
param locations array = [
  'uksouth'
  'ukwest'
  'westus2'
] 
//param ResourceGroupName string = 'arclarescostopt'
@description('Uses RG location to deploy other resources.')
param location string = resourceGroup().location
@description('Provide a name for App Service starting with "toystore-"')
param appServiceAppName string = 'toystore-${uniqueString(resourceGroup().id)}'
//param ResourceGroupName string
@description('Provide a name for the storage account. Use only lower case letters and numbers. The name must be unique across Azure.')
@minLength(3)
@maxLength(24)
param storageAccountName string = 'toystore${uniqueString(resourceGroup().id)}'

@description('Set different SKUs depending if this is deployed to PRD or Dev environments')
@allowed([
  'dev'
  'prod'
])
param environmentType string

@description('Define Tags')
param resourceTags object = {
  EnvironmentName: 'Test'
  CostCenter: '1000100'
  Team: 'Human Resources'
}

@description('The name and tier of the App Service plan SKU.')
param appServicePlanSku object

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorPassword string

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object

@description('The name of the audit storage account SKU.')
param auditStorageAccountSkuName string = 'Standard_LRS'

@description('The name and tier of the SQL database SKU.')
param sqlAuditDatabaseSku object = {
  name: 'Standard'
  tier: 'Standard'
}

@description('The name of the environment. This must be Development or Production.')
@allowed([
  'Development'
  'Production'
])
param environmentName string = 'Development'

@description('The IP address range for all virtual networks to use.')
param virtualNetworkAddressPrefix string = '10.10.0.0/16'

@description('The name and IP address range for each subnet in the virtual networks.')
param subnets array = [
  {
    name: 'frontend'
    ipAddressRange: '10.10.5.0/24'
  }
  {
    name: 'backend'
    ipAddressRange: '10.10.10.0/24'
  }
]

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var subnetProperties = [for subnet in subnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]

//==============================================================================
// Modules
//==============================================================================

module appService 'modules/appService.bicep' = {
  name: 'appService'
    params: {
    location: location
    appServiceAppName: appServiceAppName
    environmentType: environmentType
    }
}


module appServicefullsolution 'modules/appServicefullsolution.bicep' = {
  name: 'appServiceFullSolution'
    params: {
    location: location
    appServicePlanSku: appServicePlanSku
    sqlDatabaseSku: sqlDatabaseSku
    sqlServerAdministratorLogin : sqlServerAdministratorLogin
    sqlServerAdministratorPassword : sqlServerAdministratorPassword
    }
}


module sqldb 'modules/sqldb.bicep' = {
  name: 'sqldb'
    params: {
    location: location
    auditStorageAccountSkuName: auditStorageAccountSkuName
    environmentName:environmentName
    sqlAuditDatabaseSku: sqlAuditDatabaseSku
    sqlServerAdministratorLogin : sqlServerAdministratorLogin
    sqlServerAdministratorPassword : sqlServerAdministratorPassword
    }
}

//==============================================================================
// Resources
//==============================================================================

resource virtualNetworks 'Microsoft.Network/virtualNetworks@2021-08-01' = [for location in locations: {
  name: 'teddybear-${location}'
  location: location
  properties:{
    addressSpace:{
      addressPrefixes:[
        virtualNetworkAddressPrefix
      ]
    }
    subnets: subnetProperties
  }
}]


resource sampleStorageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  tags: resourceTags
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'Storage'
}

//==============================================================================
// Outputs
//==============================================================================

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
output AppServicePlanRG string = appServicefullsolution.outputs.AppServiceAppHostNameFullSolution
output AppServiceAppHostNameFullSolution string = appServicefullsolution.outputs.AppServicePlanRG
output AppServiceNumberOfInstances int = appServicefullsolution.outputs.AppServiceNumberOfInstances
output SQLDBName string = appServicefullsolution.outputs.sqlDBName
output SQLServerName string = appServicefullsolution.outputs.SQLServerName
output sqldbAuditName string = sqldb.outputs.sqldbName
output auditStorageAccountName string = sqldb.outputs.storageAccountSkuName
//output auditStatus string = sqldb.outputs.storageAudit
output numberOfDeployments int = sqldb.outputs.numberOfResources
