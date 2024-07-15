//==============================================================================
// Parameters
//==============================================================================
targetScope = 'subscription'

param labName string = 'DonatellosPizza'
@description('Azure location where all resources should be created. Default: italynorth')
param resourceGroupLocation string = 'italynorth'
param numberOfRGs int = 6

@description('Optional. Tags to apply to all resources.')
param tags object = {}



param adminUsername string = 'doughmasterchef'
param adminPasswordOrKey string = 'P3pp3r0ni!'
param numberOfVms int = 1

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------
var rgNames = [for i in range(0, numberOfRGs): '${labName}${i}']
var projectTags=  union(tags, {
  Project:'GourmetRollout'
  CostCenter: '1000100'
})   

//==============================================================================
// Resources
//==============================================================================

resource newRG 'Microsoft.Resources/resourceGroups@2024-03-01' = [for rgName in rgNames: {
  name: rgName
  tags:projectTags
  location: resourceGroupLocation
}]

//==============================================================================
// Modules
//==============================================================================

// Deploy the module for each resource group
module idleResources 'modules/idleresources.bicep' = [for (rgName, i) in rgNames: {
  name: 'idleResources-module-${i}'
  scope: resourceGroup(rgName)
  params: {
    location: resourceGroupLocation
    tags: tags
  }
  dependsOn: [
    newRG[i]
  ]
}]

module multiVM 'modules/compute.bicep' = [for (rgName, i) in rgNames: {
  name: 'multiVM-module-${i}'
  scope: resourceGroup(rgName)
  params: {
    location: resourceGroupLocation
    adminUsername: adminUsername
    adminPasswordOrKey: adminPasswordOrKey
    numberOfVms: numberOfVms
    tags: tags
  }
  dependsOn: [
    newRG[i]
  ]
}]

//==============================================================================
// Output
//==============================================================================
output rgNames array = rgNames
