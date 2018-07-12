#╒═════════════════════════════════════════════════════════╕
#│ AD-PurgeInactiveComputers.ps1                           │
#╞═════════════════════════════════════════════════════════╡
#│ Created by:   Trey Donovan                              │
#│ Last Updated: 02/02/16                                  │
#╞═════════════════════════════════════════════════════════╡
#│ Script to add users to query Active Directory and return│
#│ the computer accounts which have not logged for the past│
#│ 120 days and remove the computer accounts from AD.      │
#│                                                         │ 
#│ Populates a variable ($then) with the number of days to │
#│ check for inactivity.  Performs readable conversion of  │
#│ the lastLogonTimeStamp property.  Then runs cmdlet to   │
#│ remove the computer accounts that meet the criteria.    │
#│ Results are written to file C:\adpurge.txt.             │
#╞═════════════════════════════════════════════════════════╡
#│ Updated: 10/24/17 - Changed Remove-ADComputer to        │
#│                     Remove-ADObject function to allow   │
#│                     recursive removal of leaf objects.  │
#╘═════════════════════════════════════════════════════════╛

ipmo activedirectory
$then = (Get-Date).AddDays(-45)
$results = Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -lt $then}
$count = $results.count

$logfile = "Purging $count computer accounts that haven't been seen since $then :`r`n`r`n"
Foreach ($computer in $results) {
	$logfile += $computer.name
	$logfile += "`r`n"
	Remove-ADObject -Identity $computer -Recursive -confirm:$false
}

$newresults = Get-ADComputer -Filter *
$newcount = $newresults.count
$logfile += "`r`n-------------------------- `r`n$newcount computers after purge."
$logfilename = "C:\adpurge.txt"
$logfile | Out-File $logfilename
