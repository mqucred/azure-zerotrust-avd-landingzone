# ==============================================================================
# Phase 5: AVD Host Pool, Session Host and FSLogix
# ==============================================================================

Connect-AzAccount -SubscriptionId "<subscription-id>" -TenantId "<tenant-id>"

# --- Diagnose: effective routes on the session host NIC ---
Get-AzEffectiveRouteTable -ResourceGroupName "rg-spoke-avd-01" -NetworkInterfaceName "avd-sh-0-nic" |
    Where-Object { $_.AddressPrefix -contains "0.0.0.0/0" }

# --- Diagnose: connectivity test from the host (via Run Command) ---
$testScript = "Test-NetConnection wvdportalstorageblob.blob.core.windows.net -Port 443"
Invoke-AzVMRunCommand -ResourceGroupName "rg-spoke-avd-01" -VMName "avd-sh-0" `
    -CommandId "RunPowerShellScript" -ScriptString $testScript

# --- Workaround: NAT Gateway attached, route table detached ---
$vnet   = Get-AzVirtualNetwork -ResourceGroupName "rg-spoke-avd-01" -Name "vnet-spoke-avd-prod-01"
$subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name "snet-avd-sessionhosts"
$natGw  = Get-AzNatGateway -ResourceGroupName "rg-spoke-avd-01" -Name "natgw-avd-spoke"
$subnet.NatGateway  = $natGw
$subnet.RouteTable  = $null
Set-AzVirtualNetwork -VirtualNetwork $vnet

# --- Remove the failed DSC extension, then redeploy with a real registration token ---
Remove-AzVMExtension -ResourceGroupName "rg-spoke-avd-01" -VMName "avd-sh-0" -Name "Microsoft.PowerShell.DSC" -Force

$hostPoolName = "pool-avd-prod-01"
$rgSpoke      = "rg-spoke-avd-01"
$registrationToken = (New-AzWvdRegistrationInfo -ResourceGroupName $rgSpoke -HostPoolName $hostPoolName `
    -ExpirationTime (Get-Date).AddDays(1)).Token

$PublicSettings = @{
    modulesUrl            = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.03519.1433.zip"
    configurationFunction  = "Configuration.ps1\AddSessionHost"
    properties = @{ hostPoolName = $hostPoolName }
}
$ProtectedSettings = @{
    properties = @{ registrationInfoToken = $registrationToken }
}

Set-AzVMExtension -ResourceGroupName $rgSpoke -VMName "avd-sh-0" `
    -Name "Microsoft.PowerShell.DSC" -Publisher "Microsoft.Powershell" `
    -ExtensionType "DSC" -TypeHandlerVersion "2.73" `
    -Settings $PublicSettings -ProtectedSettings $ProtectedSettings

# --- Check host pool health checks ---
Get-AzWvdSessionHost -ResourceGroupName $rgSpoke -HostPoolName $hostPoolName |
    Select-Object Name, Status, UpdateState, HealthCheckResult

# --- Domain join (no OU path; move the object afterward) ---
$joinScript = @'
$pw = ConvertTo-SecureString 'PASTE_PASSWORD_HERE' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential('CONTOSO\<domain-admin-username>', $pw)
Add-Computer -DomainName contoso.local -Credential $cred -Restart -Force
'@
Invoke-AzVMRunCommand -ResourceGroupName $rgSpoke -VMName "avd-sh-0" `
    -CommandId "RunPowerShellScript" -ScriptString $joinScript

# --- FSLogix registry configuration (run on the host, or via Run Command) ---
$fslogixScript = @'
$registryPath = "HKLM:\SOFTWARE\FSLogix\Profiles"
if (-not (Test-Path $registryPath)) { New-Item -Path $registryPath -Force | Out-Null }
Set-ItemProperty -Path $registryPath -Name "Enabled" -Type DWord -Value 1
Set-ItemProperty -Path $registryPath -Name "VHDLocations" -Type MultiString -Value "\\stazavdprofiles.file.core.windows.net\fslogix-profiles"
Set-ItemProperty -Path $registryPath -Name "SizeInMB" -Type DWord -Value 30000
Set-ItemProperty -Path $registryPath -Name "IsDynamic" -Type DWord -Value 1
'@
Invoke-AzVMRunCommand -ResourceGroupName $rgSpoke -VMName "avd-sh-0" `
    -CommandId "RunPowerShellScript" -ScriptString $fslogixScript