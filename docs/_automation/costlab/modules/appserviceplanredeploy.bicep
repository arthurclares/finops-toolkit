//==============================================================================
// Parameters
//==============================================================================
@description('Optional. Azure location where all resources should be created. See https://aka.ms/azureregions. Default: (resource group location).')
param location string = resourceGroup().location
@description('Optional. Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management.')
param tags object = {}
@description('Username for the Virtual Machine.')
param adminUsername string

param numberOfVms int = 1

param authenticationType string = 'password'

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
@secure()
param adminPasswordOrKey string

@description('Size of the virtual machine')
param vmSize string = 'Standard_D2s_v3'

@description('Size of the virtual machine')
param bigvmSize string = 'Standard_D16s_v3'

@description('Security Type of the Virtual Machine.')
param securityType string = 'TrustedLaunch'

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
param OSVersion string = '2022-datacenter-azure-edition'

@description('The unique name of the solution. This is used to ensure that resource names are unique.')
param solutionName string = 'pizza${uniqueString(resourceGroup().id)}'

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------
var WindowsName = 'PizzaWinVM'
var LinuxName = 'PizzaLinVM'
var securityProfileJson = {
  uefiSettings: {
    secureBootEnabled: true
    vTpmEnabled: true
  }
  securityType: securityType
}
var BigVMName = 'BigPizzaVM'
var windowsnicName = 'PizzaWinNic'
var linuxNicName = 'PizzaLinNic'
var BigVMNicName = 'BigPizzaNic'
var windowsImage = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: OSVersion
  version: 'latest'
}
var linuxImage = {
  publisher: 'Canonical'
  offer: '0001-com-ubuntu-server-lunar-daily'
  sku: '23_04-daily-gen2'
  version: 'latest'
}
var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  }
}

var resourceTagsDev = {
  CostCenter: '1000100'
  ApplicationName: 'DoughDynasty'
  environmentType:'Dev'
  Owner:'PizzaOpsTeam'
  Project:'GourmetRollout'
}

var resourceTagsProd = {
  CostCenter: '1000100'
  ApplicationName: 'PizzaOrderPortal'
  environmentType:'Prod'
  Owner:'DoughDevelopers'
  Project:'GourmetRollout'
}
var powerOffAutomation=  union(resourceTagsProd, {
   Status: 'PowerOff'
})   

var environmentType = 'Prod'

var appServicePlanName = '${environmentType}-${solutionName}-plan'
var appServiceAppName = '${environmentType}-${solutionName}-app'
var appServicePlanInstanceCount = 1
var appServicePlanSku = 'P2v2'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
name: appServicePlanName
location: location
  sku: {
  name: appServicePlanSku
//tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
 }
}
