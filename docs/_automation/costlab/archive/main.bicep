//==============================================================================
// Parameters
//==============================================================================
targetScope='subscription'

@description('Mandatory. . Used to ensure unique resource names')
param labName string 
@description('Mandatory. Azure location where all resources should be created. See https://aka.ms/azureregions. Default: (resource group location).')
param resourceGroupLocation string 
param numberOfRGs int 


@description('Optional. Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management.')
param tags object = {}

param adminUsername string 
@secure()
param adminPasswordOrKey string
param numberOfVms int = 1

//@description('The unique name of the solution. This is used to ensure that resource names are unique.')
//@minLength(5)
//@maxLength(30)
//param solutionName string = 'toyhr'

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------
var rgNames = [for i in range(0, numberOfRGs): '${labName}${i}']

//==============================================================================
// Resources
//==============================================================================


resource newRG 'Microsoft.Resources/resourceGroups@2024-03-01' = [for rgName in rgNames: {
  name: rgName
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
  dependsOn:newRG
}]


module multiVM 'modules/compute.bicep' = [for (rgName, i) in rgNames: {
  name: 'multiVM-module-${i}'
 scope: resourceGroup(rgName)
  params: {
   //solutionName : solutionName
   location: resourceGroupLocation
   adminUsername:adminUsername
   adminPasswordOrKey:adminPasswordOrKey
   numberOfVms:numberOfVms
    tags:tags
  }
  dependsOn:newRG
}]


//==============================================================================
// Output
//==============================================================================
