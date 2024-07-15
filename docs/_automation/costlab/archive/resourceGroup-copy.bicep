targetScope='subscription'

@description('Optional. . Used to ensure unique resource names. Default: "finops-hub".')
param labName string
param resourceGroupLocation string

@description('Number of VMs to provision')
@minValue(1)
@maxValue(10)
param numberOfRGs int
@description('Optional. Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management.')
param tags object = {}

var rgNames = [for i in range(0, numberOfRGs): '${labName}${i}']

resource newRG 'Microsoft.Resources/resourceGroups@2022-09-01' = [for rgName in rgNames: {
  name: rgName
  location: resourceGroupLocation
}]

// Deploy the module for each resource group
module idleResources 'modules/idleresources.bicep' = [for (rgName, i) in rgNames: {
  name: 'idleResources-module-${i}'
  scope: resourceGroup(rgName)
  params: {
    labName: labName
    location: resourceGroupLocation // Or specify the location if it's different
    tags: tags
  }
  dependsOn:newRG
}]

