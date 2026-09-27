param storageAccounts_stazavdprofiles_name string = 'stazavdprofiles'

resource storageAccounts_stazavdprofiles_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_stazavdprofiles_name
  location: 'centralindia'
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
  kind: 'FileStorage'
  properties: {
    publicNetworkAccess: 'Disabled'
    allowCrossTenantReplication: false
    azureFilesIdentityBasedAuthentication: {
      directoryServiceOptions: 'AD'
      activeDirectoryProperties: {
        samAccountName: storageAccounts_stazavdprofiles_name
        accountType: 'Computer'
        domainName: 'contoso.local'
        netBiosDomainName: 'contoso.local'
        forestName: 'contoso.local'
        domainGuid: '374d0ab5-a0d3-4b1a-85a2-7ce0eea208a3'
        domainSid: 'S-1-5-21-2108838030-1519520354-1096189142'
        azureStorageSid: 'S-1-5-21-2108838030-1519520354-1096189142-1607'
      }
    }
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    largeFileSharesState: 'Enabled'
    networkAcls: {
      ipv6Rules: []
      resourceAccessRules: []
      bypass: 'None'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Deny'
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
  }
}

resource storageAccounts_stazavdprofiles_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_stazavdprofiles_name_resource
  name: 'default'
  sku: {
    name: 'Premium_LRS'
    tier: 'Premium'
  }
  properties: {
    protocolSettings: {
      smb: {
        multichannel: {
          enabled: true
        }
      }
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

resource storageAccounts_stazavdprofiles_name_storageAccounts_stazavdprofiles_name_fbe05ea5_6994_4e3b_b290_460a8fcc9ad5 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2026-04-01' = {
  parent: storageAccounts_stazavdprofiles_name_resource
  name: '${storageAccounts_stazavdprofiles_name}.fbe05ea5-6994-4e3b-b290-460a8fcc9ad5'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource storageAccounts_stazavdprofiles_name_default_fslogix_profiles 'Microsoft.Storage/storageAccounts/fileServices/shares@2026-04-01' = {
  parent: storageAccounts_stazavdprofiles_name_default
  name: 'fslogix-profiles'
  properties: {
    fileSharePaidBursting: {
      paidBurstingEnabled: false
    }
    accessTier: 'Premium'
    shareQuota: 100
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_stazavdprofiles_name_resource
  ]
}
