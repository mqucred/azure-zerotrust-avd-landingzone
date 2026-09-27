param virtualMachines_vm_hub_nva_01_name string = 'vm-hub-nva-01'
param virtualNetworks_vnet_hub_prod_01_name string = 'vnet-hub-prod-01'
param networkInterfaces_vm_hub_nva_01830_name string = 'vm-hub-nva-01830'
param publicIPAddresses_vm_hub_nva_01_ip_name string = 'vm-hub-nva-01-ip'
param networkSecurityGroups_vm_hub_nva_01_nsg_name string = 'vm-hub-nva-01-nsg'
param virtualNetworks_vnet_spoke_avd_prod_01_externalid string = '/subscriptions/Sub-id/resourceGroups/rg-spoke-avd-01/providers/Microsoft.Network/virtualNetworks/vnet-spoke-avd-prod-01'

resource networkSecurityGroups_vm_hub_nva_01_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_vm_hub_nva_01_nsg_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Location: 'CentralIndia'
    Phase: 'Phase2'
    Project: 'ZeroTrustAVD'
  }
  properties: {
    securityRules: [
      {
        name: 'SSH'
        id: networkSecurityGroups_vm_hub_nva_01_nsg_name_SSH.id
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_vm_hub_nva_01_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_vm_hub_nva_01_ip_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Location: 'CentralIndia'
    Phase: 'Phase2'
    Project: 'ZeroTrustAVD'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '52.172.236.127'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_vnet_hub_prod_01_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet_hub_prod_01_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Project: 'ZeroTrustAVD'
    Location: 'CentralIndia'
    Phase: 'Phase2'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.200.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'snet-hub-fw'
        id: virtualNetworks_vnet_hub_prod_01_name_snet_hub_fw.id
        properties: {
          addressPrefix: '10.200.1.0/24'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_vnet_hub_prod_01_name_GatewaySubnet.id
        properties: {
          addressPrefix: '10.200.255.0/27'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'peer-hub-to-spoke'
        id: virtualNetworks_vnet_hub_prod_01_name_peer_hub_to_spoke.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_spoke_avd_prod_01_externalid
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          remoteAddressSpace: {
            addressPrefixes: [
              '10.210.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.210.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualMachines_vm_hub_nva_01_name_resource 'Microsoft.Compute/virtualMachines@2026-03-01' = {
  name: virtualMachines_vm_hub_nva_01_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Location: 'CentralIndia'
    Phase: 'Phase2'
    Project: 'ZeroTrustAVD'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_vm_hub_nva_01_name}_OsDisk_1_0624b373b9214e679c579622a57919e0'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_hub_nva_01_name}_OsDisk_1_0624b373b9214e679c579622a57919e0'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_vm_hub_nva_01_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_hub_nva_01830_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource networkSecurityGroups_vm_hub_nva_01_nsg_name_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_vm_hub_nva_01_nsg_name}/SSH'
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_vm_hub_nva_01_nsg_name_resource
  ]
}

resource virtualNetworks_vnet_hub_prod_01_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_hub_prod_01_name}/GatewaySubnet'
  properties: {
    addressPrefix: '10.200.255.0/27'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_hub_prod_01_name_resource
  ]
}

resource virtualNetworks_vnet_hub_prod_01_name_snet_hub_fw 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_hub_prod_01_name}/snet-hub-fw'
  properties: {
    addressPrefix: '10.200.1.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_hub_prod_01_name_resource
  ]
}

resource virtualNetworks_vnet_hub_prod_01_name_peer_hub_to_spoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = {
  name: '${virtualNetworks_vnet_hub_prod_01_name}/peer-hub-to-spoke'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_spoke_avd_prod_01_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        '10.210.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.210.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet_hub_prod_01_name_resource
  ]
}

resource networkInterfaces_vm_hub_nva_01830_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_vm_hub_nva_01830_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Location: 'CentralIndia'
    Phase: 'Phase2'
    Project: 'ZeroTrustAVD'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_hub_nva_01830_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.200.1.4'
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: publicIPAddresses_vm_hub_nva_01_ip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_vnet_hub_prod_01_name_snet_hub_fw.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: true
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_vm_hub_nva_01_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
