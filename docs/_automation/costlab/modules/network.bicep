param location string = resourceGroup().location
var virtualNetworkName = 'my-vnet'
var subnetRef1 = resourceId('Microsoft.Network/virtualNetworks/subnets/', virtualNetworkName, subnet1Name)
var subnetRef2 = resourceId('Microsoft.Network/virtualNetworks/subnets/', virtualNetworkName, subnet2Name)
var windowsOrUbuntu = 'Windows'
var subnet2Name = 'Subnet-2'
var subnet1Name  = 'Subnet-1'
var networkSecurityGroupName = 'allowRemoting'


resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'RemoteConnection'
        properties: {
          description: 'Allow RDP/SSH'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: ((windowsOrUbuntu == 'Windows') ? '3389' : '22')
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }

  resource subnet1 'subnets' existing = {
    name: subnet1Name
  }

  resource subnet2 'subnets' existing = {
    name: subnet2Name
  }
}

output subnet1ResourceId string = virtualNetwork::subnet1.id
output subnet2ResourceId string = virtualNetwork::subnet2.id
output networkId string =virtualNetwork.id
output subnetRef1 string = subnetRef1
output subnetRef2 string = subnetRef2
