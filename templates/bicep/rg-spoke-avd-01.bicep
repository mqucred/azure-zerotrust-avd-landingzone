param virtualMachines_avd_sh_0_name string = 'avd-sh-0'
param publicIPAddresses_nat_pip_name string = 'nat-pip'
param natGateways_natgw_avd_spoke_name string = 'natgw-avd-spoke'
param routeTables_rt_spoke_to_hub_name string = 'rt-spoke-to-hub'
param virtualMachines_vm_spoke_test_name string = 'vm-spoke-test'
param networkInterfaces_avd_sh_0_nic_name string = 'avd-sh-0-nic'
param networkInterfaces_vm_spoke_test103_name string = 'vm-spoke-test103'
param virtualNetworks_vnet_spoke_avd_prod_01_name string = 'vnet-spoke-avd-prod-01'
param networkSecurityGroups_vm_spoke_test_nsg_name string = 'vm-spoke-test-nsg'
param hostpools_pool_avd_prod_01_name string = 'pool-avd-prod-01'
param dataCollectionRules_dcr_avd_winsecurity_name string = 'dcr-avd-winsecurity'
param privateEndpoints_pe_stazavdprofiles_file_name string = 'pe-stazavdprofiles-file'
param workspaces_workspace_avd_prod_01_name string = 'workspace-avd-prod-01'
param applicationgroups_ag_avd_desktop_01_name string = 'ag-avd-desktop-01'
param privateDnsZones_privatelink_file_core_windows_net_name string = 'privatelink.file.core.windows.net'
param workspaces_law_central_secops_01_externalid string = '/subscriptions/Sub-ID/resourceGroups/rg-hub-network-01/providers/Microsoft.OperationalInsights/workspaces/law-central-secops-01'
param virtualNetworks_vnet_onprem_prod_01_externalid string = '/subscriptions/Sub-ID/resourceGroups/rg-onprem-infra-01/providers/Microsoft.Network/virtualNetworks/vnet-onprem-prod-01'
param storageAccounts_stazavdprofiles_externalid string = '/subscriptions/Sub-ID/resourceGroups/rg-avd-storage-01/providers/Microsoft.Storage/storageAccounts/stazavdprofiles'
param virtualNetworks_vnet_hub_prod_01_externalid string = '/subscriptions/Sub-ID/resourceGroups/rg-hub-network-01/providers/Microsoft.Network/virtualNetworks/vnet-hub-prod-01'

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

resource dataCollectionRules_dcr_avd_winsecurity_name_resource 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: dataCollectionRules_dcr_avd_winsecurity_name
  location: 'centralindia'
  tags: {
    createdBy: 'Sentinel'
  }
  kind: 'Windows'
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          streams: [
            'Microsoft-SecurityEvent'
          ]
          xPathQueries: [
            'Security!*[System[(EventID=1) or (EventID=299) or (EventID=300) or (EventID=324) or (EventID=340) or (EventID=403) or (EventID=404) or (EventID=410) or (EventID=411) or (EventID=412) or (EventID=413) or (EventID=431) or (EventID=500) or (EventID=501) or (EventID=1100)]]'
            'Security!*[System[(EventID=1102) or (EventID=1107) or (EventID=1108) or (EventID=4608) or (EventID=4610) or (EventID=4611) or (EventID=4614) or (EventID=4622) or (EventID=4624) or (EventID=4625) or (EventID=4634) or (EventID=4647) or (EventID=4648) or (EventID=4649) or (EventID=4657)]]'
            'Security!*[System[(EventID=4661) or (EventID=4662) or (EventID=4663) or (EventID=4665) or (EventID=4666) or (EventID=4667) or (EventID=4688) or (EventID=4670) or (EventID=4672) or (EventID=4673) or (EventID=4674) or (EventID=4675) or (EventID=4689) or (EventID=4697) or (EventID=4700)]]'
            'Security!*[System[(EventID=4702) or (EventID=4704) or (EventID=4705) or (EventID=4716) or (EventID=4717) or (EventID=4718) or (EventID=4719) or (EventID=4720) or (EventID=4722) or (EventID=4723) or (EventID=4724) or (EventID=4725) or (EventID=4726) or (EventID=4727) or (EventID=4728)]]'
            'Security!*[System[(EventID=4729) or (EventID=4733) or (EventID=4732) or (EventID=4735) or (EventID=4737) or (EventID=4738) or (EventID=4739) or (EventID=4740) or (EventID=4742) or (EventID=4744) or (EventID=4745) or (EventID=4746) or (EventID=4750) or (EventID=4751) or (EventID=4752)]]'
            'Security!*[System[(EventID=4754) or (EventID=4755) or (EventID=4756) or (EventID=4757) or (EventID=4760) or (EventID=4761) or (EventID=4762) or (EventID=4764) or (EventID=4767) or (EventID=4768) or (EventID=4771) or (EventID=4774) or (EventID=4778) or (EventID=4779) or (EventID=4781)]]'
            'Security!*[System[(EventID=4793) or (EventID=4797) or (EventID=4798) or (EventID=4799) or (EventID=4800) or (EventID=4801) or (EventID=4802) or (EventID=4803) or (EventID=4825) or (EventID=4826) or (EventID=4870) or (EventID=4886) or (EventID=4887) or (EventID=4888) or (EventID=4893)]]'
            'Security!*[System[(EventID=4898) or (EventID=4902) or (EventID=4904) or (EventID=4905) or (EventID=4907) or (EventID=4931) or (EventID=4932) or (EventID=4933) or (EventID=4946) or (EventID=4948) or (EventID=4956) or (EventID=4985) or (EventID=5024) or (EventID=5033) or (EventID=5059)]]'
            'Security!*[System[(EventID=5136) or (EventID=5137) or (EventID=5140) or (EventID=5145) or (EventID=5632) or (EventID=6144) or (EventID=6145) or (EventID=6272) or (EventID=6273) or (EventID=6278) or (EventID=6416) or (EventID=6423) or (EventID=6424) or (EventID=8001) or (EventID=8002)]]'
            'Security!*[System[(EventID=8003) or (EventID=8004) or (EventID=8005) or (EventID=8006) or (EventID=8007) or (EventID=8222) or (EventID=26401) or (EventID=30004)]]'
            'Microsoft-Windows-AppLocker/EXE and DLL!*[System[(EventID=8001) or (EventID=8002) or (EventID=8003) or (EventID=8004)]]'
            'Microsoft-Windows-AppLocker/MSI and Script!*[System[(EventID=8005) or (EventID=8006) or (EventID=8007)]]'
          ]
          name: 'eventLogsDataSource'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaces_law_central_secops_01_externalid
          name: 'DataCollectionEvent'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-SecurityEvent'
        ]
        destinations: [
          'DataCollectionEvent'
        ]
      }
    ]
  }
}

resource networkSecurityGroups_vm_spoke_test_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_vm_spoke_test_nsg_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Project: 'ZeroTrustAVD'
  }
  properties: {
    securityRules: [
      {
        name: 'SSH'
        id: networkSecurityGroups_vm_spoke_test_nsg_name_SSH.id
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

resource privateDnsZones_privatelink_file_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_file_core_windows_net_name
  location: 'global'
  properties: {}
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
    'cm-resource-parent': '/subscriptions/Sub-ID/resourceGroups/rg-spoke-avd-01/providers/Microsoft.DesktopVirtualization/hostpools/pool-avd-prod-01'
  }
  identity: {
    type: 'SystemAssigned'
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
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_avd_sh_0_name}_OsDisk_1_a07b9a4800d44d9ab391b15f607b616e'
          )
        }
        deleteOption: 'Detach'
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

resource virtualMachines_vm_spoke_test_name_resource 'Microsoft.Compute/virtualMachines@2026-03-01' = {
  name: virtualMachines_vm_spoke_test_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
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
        name: '${virtualMachines_vm_spoke_test_name}_OsDisk_1_64b82f42bc4641ac835f2af3df5d3899'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_spoke_test_name}_OsDisk_1_64b82f42bc4641ac835f2af3df5d3899'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_vm_spoke_test_name
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
          id: networkInterfaces_vm_spoke_test103_name_resource.id
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
      configurationFunction: 'Configuration.ps1\\AddSessionHost'
      properties: {
        hostPoolName: 'pool-avd-prod-01'
      }
      modulesUrl: 'https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.03519.1433.zip'
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

resource hostpools_pool_avd_prod_01_name_avd_sh_0_contoso_local 'Microsoft.DesktopVirtualization/hostpools/sessionhosts@2026-04-01-preview' = {
  parent: hostpools_pool_avd_prod_01_name_resource
  name: 'avd-sh-0.contoso.local'
  properties: {
    allowNewSession: true
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

resource natGateways_natgw_avd_spoke_name_resource 'Microsoft.Network/natGateways@2025-07-01' = {
  name: natGateways_natgw_avd_spoke_name
  location: 'centralindia'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: publicIPAddresses_nat_pip_name_resource.id
      }
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
    'cm-resource-parent': '/subscriptions/Sub-ID/resourcegroups/rg-spoke-avd-01/providers/Microsoft.DesktopVirtualization/hostpools/pool-avd-prod-01'
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

resource networkSecurityGroups_vm_spoke_test_nsg_name_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_vm_spoke_test_nsg_name}/SSH'
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
    networkSecurityGroups_vm_spoke_test_nsg_name_resource
  ]
}

resource privateDnsZones_privatelink_file_core_windows_net_name_stazavdprofiles 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'stazavdprofiles'
  properties: {
    metadata: {
      creator: 'created by private endpoint pe-stazavdprofiles-file with resource guid fcb3da4a-2844-418d-8dcb-1a94b900b149'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.210.3.4'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_file_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource privateDnsZones_privatelink_file_core_windows_net_name_link_onprem 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'link-onprem'
  location: 'global'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_vnet_onprem_prod_01_externalid
    }
  }
}

resource privateEndpoints_pe_stazavdprofiles_file_name_resource 'Microsoft.Network/privateEndpoints@2025-07-01' = {
  name: privateEndpoints_pe_stazavdprofiles_file_name
  location: 'centralindia'
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'conn-stazavdprofiles-file'
        id: '${privateEndpoints_pe_stazavdprofiles_file_name_resource.id}/privateLinkServiceConnections/conn-stazavdprofiles-file'
        properties: {
          privateLinkServiceId: storageAccounts_stazavdprofiles_externalid
          groupIds: [
            'file'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: virtualNetworks_vnet_spoke_avd_prod_01_name_snet_private_endpoints.id
    }
    ipConfigurations: []
    customDnsConfigs: []
    ipVersionType: 'IPv4'
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
    natGateway: {
      id: natGateways_natgw_avd_spoke_name_resource.id
    }
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

resource virtualNetworks_vnet_spoke_avd_prod_01_name_snet_private_endpoints 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_spoke_avd_prod_01_name}/snet-private-endpoints'
  properties: {
    addressPrefix: '10.210.3.0/24'
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

resource virtualNetworks_vnet_spoke_avd_prod_01_name_peer_spoke_to_hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = {
  name: '${virtualNetworks_vnet_spoke_avd_prod_01_name}/peer-spoke-to-hub'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'RemoteNotInSync'
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

resource virtualNetworks_vnet_spoke_avd_prod_01_name_peer_spoke_to_onprem 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = {
  name: '${virtualNetworks_vnet_spoke_avd_prod_01_name}/peer-spoke-to-onprem'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'RemoteNotInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_onprem_prod_01_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        '10.100.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.100.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet_spoke_avd_prod_01_name_resource
  ]
}

resource networkInterfaces_vm_spoke_test103_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_vm_spoke_test103_name
  location: 'centralindia'
  tags: {
    Environment: 'Lab'
    Project: 'ZeroTrustAVD'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_spoke_test103_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.210.2.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet_spoke_avd_prod_01_name_snet_test.id
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
      id: networkSecurityGroups_vm_spoke_test_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource privateDnsZones_privatelink_file_core_windows_net_name_link_spoke 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'link-spoke'
  location: 'global'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_vnet_spoke_avd_prod_01_name_resource.id
    }
  }
}

resource privateEndpoints_pe_stazavdprofiles_file_name_file_dns_group 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2025-07-01' = {
  name: '${privateEndpoints_pe_stazavdprofiles_file_name}/file-dns-group'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-file-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_file_core_windows_net_name_resource.id
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints_pe_stazavdprofiles_file_name_resource
  ]
}

resource virtualNetworks_vnet_spoke_avd_prod_01_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet_spoke_avd_prod_01_name
  location: 'centralindia'
  tags: {
    Phase: 'Phase2'
    Location: 'CentralIndia'
    Environment: 'Lab'
    Project: 'ZeroTrustAVD'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.210.0.0/16'
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
        name: 'snet-avd-sessionhosts'
        id: virtualNetworks_vnet_spoke_avd_prod_01_name_snet_avd_sessionhosts.id
        properties: {
          addressPrefix: '10.210.1.0/24'
          natGateway: {
            id: natGateways_natgw_avd_spoke_name_resource.id
          }
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet-test'
        id: virtualNetworks_vnet_spoke_avd_prod_01_name_snet_test.id
        properties: {
          addressPrefix: '10.210.2.0/24'
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
      {
        name: 'snet-private-endpoints'
        id: virtualNetworks_vnet_spoke_avd_prod_01_name_snet_private_endpoints.id
        properties: {
          addressPrefix: '10.210.3.0/24'
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
          peeringSyncLevel: 'RemoteNotInSync'
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
        name: 'peer-spoke-to-onprem'
        id: virtualNetworks_vnet_spoke_avd_prod_01_name_peer_spoke_to_onprem.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'RemoteNotInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_onprem_prod_01_externalid
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          remoteAddressSpace: {
            addressPrefixes: [
              '10.100.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.100.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_spoke_avd_prod_01_name_snet_avd_sessionhosts 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_spoke_avd_prod_01_name}/snet-avd-sessionhosts'
  properties: {
    addressPrefix: '10.210.1.0/24'
    natGateway: {
      id: natGateways_natgw_avd_spoke_name_resource.id
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

resource virtualNetworks_vnet_spoke_avd_prod_01_name_snet_test 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_spoke_avd_prod_01_name}/snet-test'
  properties: {
    addressPrefix: '10.210.2.0/24'
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
