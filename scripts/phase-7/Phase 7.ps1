# ==============================================================================
# Phase 7: Zero-Trust Storage (Private Endpoint and Private DNS)
# ==============================================================================

Connect-AzAccount -SubscriptionId "<subscription-id>" -TenantId "<tenant-id>"

$rgSpoke  = "rg-spoke-avd-01"
$rgStorage = "rg-avd-storage-01"

# --- 1. Endpoint subnet ---
$vnet = Get-AzVirtualNetwork -ResourceGroupName $rgSpoke -Name "vnet-spoke-avd-prod-01"
Add-AzVirtualNetworkSubnetConfig -Name "snet-private-endpoints" -AddressPrefix "10.210.3.0/24" -VirtualNetwork $vnet
$vnet | Set-AzVirtualNetwork

# --- 2. Private DNS zone and links (spoke + on-prem) ---
New-AzPrivateDnsZone -ResourceGroupName $rgSpoke -Name "privatelink.file.core.windows.net"

$spoke  = Get-AzVirtualNetwork -ResourceGroupName $rgSpoke -Name "vnet-spoke-avd-prod-01"
$onprem = Get-AzVirtualNetwork -ResourceGroupName "rg-onprem-infra-01" -Name "vnet-onprem-prod-01"

New-AzPrivateDnsVirtualNetworkLink -ResourceGroupName $rgSpoke -ZoneName "privatelink.file.core.windows.net" `
    -Name "link-spoke" -VirtualNetworkId $spoke.Id
New-AzPrivateDnsVirtualNetworkLink -ResourceGroupName $rgSpoke -ZoneName "privatelink.file.core.windows.net" `
    -Name "link-onprem" -VirtualNetworkId $onprem.Id

# Verify
Get-AzPrivateDnsVirtualNetworkLink -ResourceGroupName $rgSpoke -ZoneName "privatelink.file.core.windows.net" |
    Select-Object Name, VirtualNetworkLinkState, RegistrationEnabled

# --- 3. Private endpoint with a DNS zone group ---
$sa     = Get-AzStorageAccount -ResourceGroupName $rgStorage -Name "stazavdprofiles"
$subnet = $vnet.Subnets | Where-Object Name -eq "snet-private-endpoints"

$conn = New-AzPrivateLinkServiceConnection -Name "conn-stazavdprofiles-file" -PrivateLinkServiceId $sa.Id -GroupId "file"
$pe   = New-AzPrivateEndpoint -ResourceGroupName $rgSpoke -Name "pe-stazavdprofiles-file" `
          -Location "centralindia" -Subnet $subnet -PrivateLinkServiceConnection $conn

$zone = Get-AzPrivateDnsZone -ResourceGroupName $rgSpoke -Name "privatelink.file.core.windows.net"
$cfg  = New-AzPrivateDnsZoneConfig -Name "privatelink-file-core-windows-net" -PrivateDnsZoneId $zone.ResourceId
New-AzPrivateDnsZoneGroup -ResourceGroupName $rgSpoke -PrivateEndpointName "pe-stazavdprofiles-file" `
    -Name "file-dns-group" -PrivateDnsZoneConfig $cfg

# Verify
Get-AzPrivateEndpoint -ResourceGroupName $rgSpoke -Name "pe-stazavdprofiles-file" |
    Select-Object Name, ProvisioningState, @{n='Status';e={$_.PrivateLinkServiceConnections[0].PrivateLinkServiceConnectionState.Status}}
Get-AzPrivateDnsRecordSet -ResourceGroupName $rgSpoke -ZoneName "privatelink.file.core.windows.net" -RecordType A |
    Select-Object Name, @{n='IP';e={$_.Records.Ipv4Address}}

# --- 4. Conditional forwarder on the domain controller (run ON the DC) ---
Add-DnsServerConditionalForwarderZone -Name "file.core.windows.net" -MasterServers 168.63.129.16 -ReplicationScope Forest
Get-DnsServerZone -Name "file.core.windows.net" | Select-Object ZoneName, ZoneType, MasterServers

# --- 5. Name resolution checks (host and DC) ---
# On the DC:
#   Clear-DnsServerCache -Force
#   Resolve-DnsName stazavdprofiles.file.core.windows.net -Server 127.0.0.1
# From Cloud Shell, on the session host, via Run Command:
$dnsCheck = "Clear-DnsClientCache; Resolve-DnsName stazavdprofiles.file.core.windows.net | Select Name, Type, IPAddress"
Invoke-AzVMRunCommand -ResourceGroupName $rgSpoke -VMName "avd-sh-0" -CommandId "RunPowerShellScript" -ScriptString $dnsCheck

# --- 6. SMB connection check (confirms the private path is used) ---
$smbCheck = "Get-NetTCPConnection -RemotePort 445 -State Established | Select RemoteAddress, State"
Invoke-AzVMRunCommand -ResourceGroupName $rgSpoke -VMName "avd-sh-0" -CommandId "RunPowerShellScript" -ScriptString $smbCheck

# --- 7. Disable public network access ---
Set-AzStorageAccount -ResourceGroupName $rgStorage -Name "stazavdprofiles" -PublicNetworkAccess Disabled

# --- Verification from outside the VNets (Cloud Shell) ---
# curl -i "https://stazavdprofiles.file.core.windows.net/fslogix-profiles?restype=share" -H "x-ms-version: 2022-11-02"
# Expect: HTTP/1.1 403, x-ms-error-code: AuthorizationFailure

# --- Cleanup: key rotation ---
New-AzStorageAccountKey -ResourceGroupName $rgStorage -Name "stazavdprofiles" -KeyName "key1"
New-AzStorageAccountKey -ResourceGroupName $rgStorage -Name "stazavdprofiles" -KeyName "key2"