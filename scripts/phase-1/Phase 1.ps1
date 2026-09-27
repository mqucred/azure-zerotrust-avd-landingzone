# ==============================================================================
# Phase 1: Simulated On-Premises Infrastructure and AD DS
# ==============================================================================
# Most of Phase 1 was done via Windows Server GUI (dcpromo wizard, AD Users and
# Computers, DNS Manager). The commands below are the verification steps that
# were run in PowerShell after promotion.

# Connect
Connect-AzAccount -SubscriptionId "<subscription-id>" -TenantId "<tenant-id>"

# --- Run ON the domain controller (vm-onprem-dc-01), post-promotion ---
Get-Service NTDS, DNS, kdc
Get-SmbShare SYSVOL, NETLOGON

# --- VNet DNS pointed at the DC (run from Cloud Shell / any Az session) ---
$vnetOnPrem = Get-AzVirtualNetwork -ResourceGroupName "rg-onprem-infra-01" -Name "vnet-onprem-prod-01"
$vnetOnPrem.DhcpOptions.DnsServers = @("10.100.1.4")
Set-AzVirtualNetwork -VirtualNetwork $vnetOnPrem