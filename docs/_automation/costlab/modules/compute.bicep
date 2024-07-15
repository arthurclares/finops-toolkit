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

//==============================================================================
// Resources
//==============================================================================

module Network 'network.bicep' = {
  name: 'network-module'
  params: {
    location:location
  }
  }

resource Windowsnic 'Microsoft.Network/networkInterfaces@2023-09-01' = [for i in range(0, numberOfVms): {
  name: '${windowsnicName}${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: windowsnicName
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: Network.outputs.subnetRef1
          }
        }
      }
    ]
  }
}]

resource linuxNic 'Microsoft.Network/networkInterfaces@2023-09-01' = [for i in range(0, numberOfVms): {
  name: '${linuxNicName}${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: linuxNicName
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: Network.outputs.subnetRef1
          }
        }
      }
    ]
  }
}]

resource bigVMNic 'Microsoft.Network/networkInterfaces@2023-09-01' ={
  name: BigVMNicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: BigVMNicName
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: Network.outputs.subnetRef1
          }
        }
      }
    ]
  }
}

//Deploy Windows VM
resource WindowsVM 'Microsoft.Compute/virtualMachines@2023-09-01' = [for i in range(0, numberOfVms): {
  name: '${WindowsName}${i}'
  zones: split(string(((i % 3) + 1)), ',')
  location: location
  tags: powerOffAutomation
  properties: {
    licenseType: 'Windows_Server'
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: '${WindowsName}${i}'
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
    }
    storageProfile: {
      imageReference: windowsImage 
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${windowsnicName}${i}')
        }
      ]
    }
    securityProfile: ((securityType == 'TrustedLaunch') ? securityProfileJson : null)
  }
  dependsOn: [
    Windowsnic
  ]
}]

//Deploy Linux VM
resource LinuxVM 'Microsoft.Compute/virtualMachines@2023-09-01' = [for i in range(0, numberOfVms): {
  name: '${LinuxName}${i}'
  zones: split(string(((i % 3) + 1)), ',')
  location: location
  tags: resourceTagsDev
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: '${LinuxName}${i}'
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: ((authenticationType == 'password') ? null : linuxConfiguration)
    }
    storageProfile: {
      imageReference: linuxImage
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${linuxNicName}${i}')
        }
      ]
    }
    securityProfile: ((securityType == 'TrustedLaunch') ? securityProfileJson : null)
  }
  dependsOn: [
    linuxNic
  ]
}]


//Deploy Big VM
resource LargeVM 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: BigVMName
  location: location
  tags: resourceTagsProd
  properties: {
    hardwareProfile: {
      vmSize: bigvmSize
    }
    osProfile: {
      computerName: BigVMName
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
    }
    storageProfile: {
      imageReference: windowsImage
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', BigVMNicName)
        }
      ]
    }
    //securityProfile: ((securityType == 'TrustedLaunch') ? securityProfileJson : null)
  }
  dependsOn: [
    bigVMNic
  ]
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
name: appServicePlanName
location: location
  sku: {
  name: appServicePlanSku
//tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
 }
}


// remover website
//resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
// name: appServiceAppName
// location: location
// properties: {
//   serverFarmId: appServicePlan.id
//   httpsOnly: true
//  }/
//}


//==============================================================================
// output
//==============================================================================

//==============================================================================
// Output
//==============================================================================

// Output the VM sizes
output windowsVmSize string = vmSize
output linuxVmSize string = vmSize
output bigVmSize string = bigvmSize

// Output the App Service Plan ID
output appServicePlanId string = appServicePlan.id

// Output location
output deploymentLocation string = location

// Output the resource group name
output resourceGroupName string = resourceGroup().name
