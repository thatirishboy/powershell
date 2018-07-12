#===========================================================
#| VM-EnumerateAllSnapshots.ps1                            |
#===========================================================
#|                                                         |
#| Created by:   Trey Donovan                              |
#| Last Updated: 03/14/12                                  |
#|                                                         |
#===========================================================
#|                                                         |
#| This script will eumerate all VM snapshots.             |
#|                                                         |
#===========================================================

# Last modified: 03/14/12 by Trey Donovan

# This script will eumerate all VM snapshots.

Get-VM | Sort Name | Get-Snapshot | Where { $_.Name.Length -gt 0 } | Select VM,Name,Description,Created