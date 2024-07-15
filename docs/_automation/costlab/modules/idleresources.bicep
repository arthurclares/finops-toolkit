//==============================================================================
// Parameters
//==============================================================================
@description('Optional. Azure location where all resources should be created. See https://aka.ms/azureregions. Default: (resource group location).')
param location string = resourceGroup().location
@description('Optional. Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management.')
param tags object = {}





//==============================================================================
// Variables
//==============================================================================
var uniqueValue = uniqueString(resourceGroup().id)
var safeString = replace(replace(toLower(uniqueValue), '-', ''), '_', '')
var safesuffix = 'CheeseCrust'
var seconduniqueDNSName = 'toyhr${uniqueString(resourceGroup().id)}'
var diskName = '${safesuffix}-disk'
var pipName='${safesuffix}-pip'
var vaultName = '${safesuffix}-vault'
var lbName = '${safeString}-lb'
var lbSkuName = 'Standard'
var lbPublicIpAddressName = '${safeString}-lbPublicIP'
var lbFrontEndName = 'LoadBalancerFrontEnd'
var lbProbeName = 'loadBalancerHealthProbe'
var diskTags = {Job: 'TakeSnapshot'}
var resourceTagsProd = {
  CostCenter: '1000100'
  ApplicationName: 'PizzaOrderPortal'
  environmentType:'Prod'
  Owner:'DoughDevelopers'
  Project:'GourmetRollout'
}

//==============================================================================
// Resources
//==============================================================================

resource idlepip 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: pipName
  location: location
  tags: resourceTagsProd
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
 //   dnsSettings: {
 //     domainNameLabel: uniqueDNSName
 //   }
  }
}

resource idledisk 'Microsoft.Compute/disks@2023-10-02' = {
  name: diskName
  tags: diskTags
  location: location
    sku: {
    name: 'Premium_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 100
  }
}

resource recoveryServiceVault 'Microsoft.RecoveryServices/vaults@2021-01-01' = {
  name: vaultName
  location: location
  tags : resourceTagsProd
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    
  }
}


resource lbPublicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: lbPublicIpAddressName
  location: location
  tags:resourceTagsProd
  sku: {
    name: lbSkuName
  }
  properties: {
        publicIPAllocationMethod: 'Static'
        dnsSettings: {
          domainNameLabel:seconduniqueDNSName
        }
  }
}


resource loadbalancer 'Microsoft.Network/loadBalancers@2021-08-01' = {
  name: lbName
  location: location
  tags:resourceTagsProd
  sku: {
    name: lbSkuName
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: lbFrontEndName
        properties: {
          publicIPAddress: {
            id: lbPublicIPAddress.id
          }
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'myHTTPRule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, lbFrontEndName)
          }
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 15
          protocol: 'Tcp'
          enableTcpReset: true
          loadDistribution: 'Default'
          disableOutboundSnat: true
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', lbName, lbProbeName)
          }
        }
      }
    ]
    probes: [
      {
        name: lbProbeName
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
    outboundRules: [
    ]
  }
}


//todo add application gateway
// todo add premium snapshot


