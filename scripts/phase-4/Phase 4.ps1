# ==============================================================================
# Phase 4: Azure Files, Kerberos and FSLogix Permissions
# ==============================================================================

Connect-AzAccount -SubscriptionId "<subscription-id>" -TenantId "<tenant-id>"

# --- Temporary drive mount using the storage account key (NTFS setup only) ---
$StorageAccountName = "stazavdprofiles"
$ResourceGroupName   = "rg-avd-storage-01"
$AccessKey = (Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName)[0].Value
net use Z: "\\$StorageAccountName.file.core.windows.net\fslogix-profiles" $AccessKey /user:AZURE\$StorageAccountName

# --- Set NTFS permissions ---
icacls Z:\ /grant "CONTOSO\grp-avd-users:(OI)(CI)M"
icacls Z:\

# --- Clean up the temporary mount ---
net use Z: /delete /yes

# --- Verify identity-based (Kerberos/AD) configuration on the storage account ---
$sa = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
$sa.AzureFilesIdentityBasedAuth | Format-List *