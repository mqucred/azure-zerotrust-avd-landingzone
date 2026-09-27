# ==============================================================================
# Phase 3: Hybrid Identity and Microsoft Entra Connect
# ==============================================================================
# The UPN suffix, Entra Connect install, and OU filtering were done via GUI
# (AD Domains and Trusts, the Entra Connect wizard). Only the verification
# commands were run in PowerShell, on the domain controller.

Get-ADSyncScheduler
Start-ADSyncSyncCycle -PolicyType Delta