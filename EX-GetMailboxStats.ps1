#===========================================================
#| EX-GetMailboxStats.ps1                                  |
#===========================================================
#|                                                         |
#| Created by:   Trey Donovan                              |
#| Last Updated: 04/05/12                                  |
#|                                                         |
#===========================================================
#|                                                         |
#| This script will output to CSV file detailed information|
#| on all mailboxes in Exchange.                           |
#|                                                         |
#===========================================================

"DisplayName,TotalItemSize(MB),ItemCount,StorageLimitSize,Database,LegacyDN" | out-file GMS.csv; get-mailbox -resultsize unlimited | Get-MailboxStatistics | foreach{$a = $_.DisplayName;$b=$_.TotalItemSize.Value.ToMB();$c=$_.itemcount;$d=$_.storagelimitstatus;$e=$_.database;$f=$_.legacydn;"$a,$b,$c,$d,$e,$f"} | out-file GMS.csv -Append
