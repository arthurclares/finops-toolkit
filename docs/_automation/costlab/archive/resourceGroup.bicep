targetScope = 'subscription'

param labName string = 'DonatelloPizza'
@description('Azure location where all resources should be created. Default: eastus')
param resourceGroupLocation string = 'italynorth'
param numberOfRGs int 

var rgNames = [for i in range(0, numberOfRGs): '${labName}${i}']

resource newRG 'Microsoft.Resources/resourceGroups@2024-03-01' = [for rgName in rgNames: {
  name: rgName
  location: resourceGroupLocation
}]

output rgNames array = rgNames
