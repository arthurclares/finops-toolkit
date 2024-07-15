//==============================================================================
// Parameters
//==============================================================================

//@description('Mandatory. . Used to ensure unique resource names')
//param labName string 
//@description('Mandatory. Azure location where all resources should be created. See https://aka.ms/azureregions. Default: (resource group location).')
param resourceGroupLocation string = resourceGroup().location 
//param numberOfRGs int 


//@description('Optional. Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management.')
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
//var rgNames = [for i in range(0, numberOfRGs): '${labName}${i}']

//==============================================================================
// Resources
//==============================================================================


//==============================================================================
// Modules
//==============================================================================

// Deploy the module for each resource group
module idleResources 'modules/idleresources.bicep' =  {
  name: 'idleResources-module-'
  params: {
    location: resourceGroupLocation
    tags: tags
  }
}


module multiVM 'modules/compute.bicep' = {
  name: 'multiVM-module-'
  params: {
   //solutionName : solutionName
   location: resourceGroupLocation
   adminUsername:adminUsername
   adminPasswordOrKey:adminPasswordOrKey
   numberOfVms:numberOfVms
    tags:tags
  }
}


//==============================================================================
// Output
//==============================================================================
