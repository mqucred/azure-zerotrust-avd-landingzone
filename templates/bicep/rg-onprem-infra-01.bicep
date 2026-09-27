param virtualMachines_vm_onprem_dc_01_name string = 'vm-onprem-dc-01'
param virtualNetworks_vnet_onprem_prod_01_name string = 'vnet-onprem-prod-01'
param networkInterfaces_nic_vm_onprem_dc_01_name string = 'nic-vm-onprem-dc-01'
param publicIPAddresses_pip_vm_onprem_dc_01_name string = 'pip-vm-onprem-dc-01'
param storageAccounts_subergonpvmo091710500_name string = 'subergonpvmo091710500'
param networkSecurityGroups_nic_vm_onprem_dc_01_nsg_name string = 'nic-vm-onprem-dc-01-nsg'
param virtualNetworks_vnet_hub_prod_01_externalid string = '/subscriptions/Sub-Id/resourceGroups/rg-hub-network-01/providers/Microsoft.Network/virtualNetworks/vnet-hub-prod-01'
param virtualNetworks_vnet_spoke_avd_prod_01_externalid string = '/subscriptions/Sub-Id/resourceGroups/rg-spoke-avd-01/providers/Microsoft.Network/virtualNetworks/vnet-spoke-avd-prod-01'

resource networkSecurityGroups_nic_vm_onprem_dc_01_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_nic_vm_onprem_dc_01_nsg_name
  location: 'centralindia'
  properties: {
    securityRules: [
      {
        name: 'rdp-allow'
        id: networkSecurityGroups_nic_vm_onprem_dc_01_nsg_name_rdp_allow.id
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
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

resource publicIPAddresses_pip_vm_onprem_dc_01_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pip_vm_onprem_dc_01_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Location: 'CentralIndia'
    Phase: 'Phase1-Part1'
    Project: 'ZeroTrustAVD'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '74.225.197.107'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_vnet_onprem_prod_01_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet_onprem_prod_01_name
  location: 'centralindia'
  tags: {
    Location: 'CentralIndia'
    Environment: 'Lab'
    Phase: 'Phase1-Part1'
    Project: 'ZeroTrustAVD'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.100.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    dhcpOptions: {
      dnsServers: [
        '10.100.1.4'
      ]
    }
    subnets: [
      {
        name: 'snet-onprem-dc-01'
        id: virtualNetworks_vnet_onprem_prod_01_name_snet_onprem_dc_01.id
        properties: {
          addressPrefix: '10.100.1.0/24'
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
        name: 'peer-onprem-to-hub'
        id: virtualNetworks_vnet_onprem_prod_01_name_peer_onprem_to_hub.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_hub_prod_01_externalid
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          remoteAddressSpace: {
            addressPrefixes: [
              '10.200.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.200.0.0/16'
            ]
          }
        }
      }
      {
        name: 'peer-onprem-to-spoke'
        id: virtualNetworks_vnet_onprem_prod_01_name_peer_onprem_to_spoke.id
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

resource storageAccounts_subergonpvmo091710500_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_subergonpvmo091710500_name
  location: 'centralindia'
  sku: {
    name: 'Standard_GRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: false
    networkAcls: {
      ipv6Rules: []
      bypass: 'None'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource virtualMachines_vm_onprem_dc_01_name_BGInfo 'Microsoft.Compute/virtualMachines/extensions@2026-03-01' = {
  parent: virtualMachines_vm_onprem_dc_01_name_resource
  name: 'BGInfo'
  location: 'centralindia'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'BGInfo'
    typeHandlerVersion: '2.2'
  }
}

resource networkSecurityGroups_nic_vm_onprem_dc_01_nsg_name_rdp_allow 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_nic_vm_onprem_dc_01_nsg_name}/rdp-allow'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_nic_vm_onprem_dc_01_nsg_name_resource
  ]
}

resource virtualNetworks_vnet_onprem_prod_01_name_snet_onprem_dc_01 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_onprem_prod_01_name}/snet-onprem-dc-01'
  properties: {
    addressPrefix: '10.100.1.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_onprem_prod_01_name_resource
  ]
}

resource virtualNetworks_vnet_onprem_prod_01_name_peer_onprem_to_hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = {
  name: '${virtualNetworks_vnet_onprem_prod_01_name}/peer-onprem-to-hub'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_hub_prod_01_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        '10.200.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.200.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet_onprem_prod_01_name_resource
  ]
}

resource virtualNetworks_vnet_onprem_prod_01_name_peer_onprem_to_spoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = {
  name: '${virtualNetworks_vnet_onprem_prod_01_name}/peer-onprem-to-spoke'
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
    virtualNetworks_vnet_onprem_prod_01_name_resource
  ]
}

resource storageAccounts_subergonpvmo091710500_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_subergonpvmo091710500_name_resource
  name: 'default'
  sku: {
    name: 'Standard_GRS'
    tier: 'Standard'
  }
  properties: {
    staticWebsite: {
      enabled: false
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_subergonpvmo091710500_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_subergonpvmo091710500_name_resource
  name: 'default'
  sku: {
    name: 'Standard_GRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_subergonpvmo091710500_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_subergonpvmo091710500_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_subergonpvmo091710500_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_subergonpvmo091710500_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource virtualMachines_vm_onprem_dc_01_name_resource 'Microsoft.Compute/virtualMachines@2026-03-01' = {
  name: virtualMachines_vm_onprem_dc_01_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Location: 'CentralIndia'
    Phase: 'Phase1-Part1'
    Project: 'ZeroTrustAVD'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v6'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm_onprem_dc_01_name}_OsDisk_1_fdac0959257845a9921c2c2e4515c616'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_onprem_dc_01_name}_OsDisk_1_fdac0959257845a9921c2c2e4515c616'
          )
        }
        deleteOption: 'Detach'
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: virtualMachines_vm_onprem_dc_01_name
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'localadmin'
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
          id: networkInterfaces_nic_vm_onprem_dc_01_name_resource.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: 'https://${storageAccounts_subergonpvmo091710500_name}.blob.core.windows.net/'
      }
    }
  }
  dependsOn: [
    storageAccounts_subergonpvmo091710500_name_resource
  ]
}

resource storageAccounts_subergonpvmo091710500_name_default_bootdiagnostics_vmonpremd_504b3efc_0237_4fb8_862f_86e900a34440 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  parent: storageAccounts_subergonpvmo091710500_name_default
  name: 'bootdiagnostics-vmonpremd-504b3efc-0237-4fb8-862f-86e900a34440'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_subergonpvmo091710500_name_resource
  ]
}

resource storageAccounts_subergonpvmo091710500_name_default_network_watcher_logs 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  parent: storageAccounts_subergonpvmo091710500_name_default
  name: 'network-watcher-logs'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_subergonpvmo091710500_name_resource
  ]
}

resource networkInterfaces_nic_vm_onprem_dc_01_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_nic_vm_onprem_dc_01_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Location: 'CentralIndia'
    Phase: 'Phase1-Part1'
    Project: 'ZeroTrustAVD'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_nic_vm_onprem_dc_01_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.100.1.4'
          privateIPAllocationMethod: 'Static'
          publicIPAddress: {
            id: publicIPAddresses_pip_vm_onprem_dc_01_name_resource.id
          }
          subnet: {
            id: virtualNetworks_vnet_onprem_prod_01_name_snet_onprem_dc_01.id
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
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_nic_vm_onprem_dc_01_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
