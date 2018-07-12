# .SYNOPSIS
# One-liner to collect detailed information on all Exchange mailboxes.
#
# .DESCRIPTION
# This script will output to CSV file detailed information on all mailboxes in Exchange.
#
# Created by: Trey Donovan
# Last Updated: 04/05/12
#
# .EXAMPLE
# ./Get-MailboxStats.ps1
#
#.OUTPUTS
# Comma-separated file named GMS.csv
#

"DisplayName,TotalItemSize(MB),ItemCount,StorageLimitSize,Database,LegacyDN" | Out-File GMS.csv; get-mailbox -resultsize unlimited | Get-MailboxStatistics | foreach{$a = $_.DisplayName;$b=$_.TotalItemSize.Value.ToMB();$c=$_.itemcount;$d=$_.storagelimitstatus;$e=$_.database;$f=$_.legacydn;"$a,$b,$c,$d,$e,$f"} | Out-File GMS.csv -Append
