param natGateways_natgw_avd_spoke_name string = 'natgw-avd-spoke'
param publicIPAddresses_nat_pip_externalid string = '/subscriptions/Sub-id/resourceGroups/rg-spoke-avd-01/providers/Microsoft.Network/publicIPAddresses/nat-pip'

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
        id: publicIPAddresses_nat_pip_externalid
      }
    ]
  }
}
