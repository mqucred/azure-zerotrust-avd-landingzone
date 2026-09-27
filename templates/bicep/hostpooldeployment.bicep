param virtualMachines_avd_sh_0_name string = 'avd-sh-0'
param publicIPAddresses_nat_pip_name string = 'nat-pip'
param routeTables_rt_spoke_to_hub_name string = 'rt-spoke-to-hub'
param networkInterfaces_avd_sh_0_nic_name string = 'avd-sh-0-nic'
param virtualNetworks_vnet_spoke_avd_prod_01_name string = 'vnet-spoke-avd-prod-01'
param hostpools_pool_avd_prod_01_name string = 'pool-avd-prod-01'
param workspaces_workspace_avd_prod_01_name string = 'workspace-avd-prod-01'
param applicationgroups_ag_avd_desktop_01_name string = 'ag-avd-desktop-01'
param virtualNetworks_vnet_hub_prod_01_externalid string = '/subscriptions/Sub-id/resourceGroups/rg-hub-network-01/providers/Microsoft.Network/virtualNetworks/vnet-hub-prod-01'

resource hostpools_pool_avd_prod_01_name_resource 'Microsoft.DesktopVirtualization/hostpools@2026-04-01-preview' = {
  name: hostpools_pool_avd_prod_01_name
  location: 'centralindia'
  identity: {
    type: 'None'
  }
  properties: {
    allowRDPShortPathWithPrivateLink: 'Disabled'
    deploymentScope: 'Geographical'
    managedPrivateUDP: 'Default'
    directUDP: 'Default'
    publicUDP: 'Default'
    relayUDP: 'Default'
    managementType: 'Standard'
    publicNetworkAccess: 'Enabled'
    hostPoolType: 'Pooled'
    customRdpProperty: 'drivestoredirect:s:;usbdevicestoredirect:s:;redirectclipboard:i:0;redirectprinters:i:0;audiomode:i:0;videoplaybackmode:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;'
    maxSessionLimit: 999999
    loadBalancerType: 'BreadthFirst'
    validationEnvironment: false
    ring: 1
    vmTemplate: '{"namePrefix":"avd-sh","hibernate":false,"osDiskType":"StandardSSD_LRS","diskSizeGB":128,"securityType":"TrustedLaunch","secureBoot":true,"vTPM":true,"vmInfrastructureType":"Cloud","virtualProcessorCount":null,"memoryGB":null,"maximumMemoryGB":null,"minimumMemoryGB":null,"dynamicMemoryConfig":false}'
    preferredAppGroupType: 'Desktop'
    startVMOnConnect: false
  }
}

resource publicIPAddresses_nat_pip_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_nat_pip_name
  location: 'centralindia'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.207.203.113'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource routeTables_rt_spoke_to_hub_name_resource 'Microsoft.Network/routeTables@2025-07-01' = {
  name: routeTables_rt_spoke_to_hub_name
  location: 'centralindia'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'r-default-to-nva'
        id: routeTables_rt_spoke_to_hub_name_r_default_to_nva.id
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.200.1.4'
        }
      }
    ]
  }
}

resource virtualMachines_avd_sh_0_name_resource 'Microsoft.Compute/virtualMachines@2026-03-01' = {
  name: virtualMachines_avd_sh_0_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Location: 'CentralIndia'
    Project: 'ZeroTrustAVD'
    'cm-resource-parent': '/subscriptions/Sub-id/resourceGroups/rg-spoke-avd-01/providers/Microsoft.DesktopVirtualization/hostpools/pool-avd-prod-01'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v5'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'microsoftwindowsdesktop'
        offer: 'office-365'
        sku: 'win11-23h2-avd-m365'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_avd_sh_0_name}_OsDisk_1_a07b9a4800d44d9ab391b15f607b616e'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_avd_sh_0_name}_OsDisk_1_a07b9a4800d44d9ab391b15f607b616e'
          )
        }
        deleteOption: 'Detach'
        diskSizeGB: 128
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_avd_sh_0_name
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
          id: networkInterfaces_avd_sh_0_nic_name_resource.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    licenseType: 'Windows_Client'
  }
}

resource virtualMachines_avd_sh_0_name_Microsoft_PowerShell_DSC 'Microsoft.Compute/virtualMachines/extensions@2026-03-01' = {
  parent: virtualMachines_avd_sh_0_name_resource
  name: 'Microsoft.PowerShell.DSC'
  location: 'centralindia'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.73'
    settings: {
      modulesUrl: 'https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.03519.1433.zip'
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      properties: {
        hostPoolName: 'pool-avd-prod-01'
        registrationInfoTokenCredential: {
          UserName: 'PLACEHOLDER_DO_NOT_USE'
          Password: 'PrivateSettingsRef:RegistrationInfoToken'
        }
        aadJoin: false
        UseAgentDownloadEndpoint: true
        aadJoinPreview: false
        mdmId: ''
        sessionHostConfigurationLastUpdateTime: ''
      }
    }
    protectedSettings: {}
  }
}

resource applicationgroups_ag_avd_desktop_01_name_resource 'Microsoft.DesktopVirtualization/applicationgroups@2026-04-01-preview' = {
  name: applicationgroups_ag_avd_desktop_01_name
  location: 'centralindia'
  kind: 'Desktop'
  properties: {
    hostPoolArmPath: hostpools_pool_avd_prod_01_name_resource.id
    applicationGroupType: 'Desktop'
  }
}

resource workspaces_workspace_avd_prod_01_name_resource 'Microsoft.DesktopVirtualization/workspaces@2026-04-01-preview' = {
  name: workspaces_workspace_avd_prod_01_name
  location: 'centralindia'
  properties: {
    deploymentScope: 'Geographical'
    publicNetworkAccess: 'Enabled'
    applicationGroupReferences: [
      applicationgroups_ag_avd_desktop_01_name_resource.id
    ]
  }
}

resource networkInterfaces_avd_sh_0_nic_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_avd_sh_0_nic_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Location: 'CentralIndia'
    Project: 'ZeroTrustAVD'
    'cm-resource-parent': '/subscriptions/Sub-id/resourcegroups/rg-spoke-avd-01/providers/Microsoft.DesktopVirtualization/hostpools/pool-avd-prod-01'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        id: '${networkInterfaces_avd_sh_0_nic_name_resource.id}/ipConfigurations/ipconfig'
        properties: {
          privateIPAddress: '10.210.1.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet_spoke_avd_prod_01_name_snet_avd_sessionhosts.id
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
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource routeTables_rt_spoke_to_hub_name_r_default_to_nva 'Microsoft.Network/routeTables/routes@2025-07-01' = {
  name: '${routeTables_rt_spoke_to_hub_name}/r-default-to-nva'
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.200.1.4'
  }
  dependsOn: [
    routeTables_rt_spoke_to_hub_name_resource
  ]
}

resource virtualNetworks_vnet_spoke_avd_prod_01_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet_spoke_avd_prod_01_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Project: 'ZeroTrustAVD'
    Phase: 'Phase2'
    Location: 'CentralIndia'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.210.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    dhcpOptions: {
      dnsServers: []
    }
    subnets: [
      {
        name: 'snet-avd-sessionhosts'
        id: virtualNetworks_vnet_spoke_avd_prod_01_name_snet_avd_sessionhosts.id
        properties: {
          addressPrefix: '10.210.1.0/24'
          routeTable: {
            id: routeTables_rt_spoke_to_hub_name_resource.id
          }
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
        name: 'peer-spoke-to-hub'
        id: virtualNetworks_vnet_spoke_avd_prod_01_name_peer_spoke_to_hub.id
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
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_spoke_avd_prod_01_name_peer_spoke_to_hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = {
  name: '${virtualNetworks_vnet_spoke_avd_prod_01_name}/peer-spoke-to-hub'
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
    virtualNetworks_vnet_spoke_avd_prod_01_name_resource
  ]
}

resource virtualNetworks_vnet_spoke_avd_prod_01_name_snet_avd_sessionhosts 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_spoke_avd_prod_01_name}/snet-avd-sessionhosts'
  properties: {
    addressPrefix: '10.210.1.0/24'
    routeTable: {
      id: routeTables_rt_spoke_to_hub_name_resource.id
    }
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_spoke_avd_prod_01_name_resource
  ]
}
