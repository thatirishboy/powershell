# .SYNOPSIS
# Enumerate all snapshots for all VMs.
#
# .DESCRIPTION
# Enumerate all snapshots for all VMs.
#
# Created by: Trey Donovan
# Last Updated: 03/14/12
#
# .EXAMPLE
# ./Get-VMSnapshots.ps1

Get-VM | Sort Name | Get-Snapshot | Where { $_.Name.Length -gt 0 } | Select VM,Name,Description,Created
