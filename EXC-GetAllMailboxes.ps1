#╒═════════════════════════════════════════════════════════╕
#│ EXC-GetMailboxes.ps1                                    │
#╞═════════════════════════════════════════════════════════╡
#│ Created by:   Trey Donovan                              │
#│ Last Updated: 05/05/15                                  │
#╞═════════════════════════════════════════════════════════╡
#│ This script will generate a list of all Exchange        │
#│ mailboxes on a server regardless of domain scope (will  │
#│ include all subdomains) and export the list to CSV file │
#│ (C:\test.csv).                                          │
#╘═════════════════════════════════════════════════════════╛

$AllMailboxes = @() 
foreach ($ou in Get-OrganizationalUnit) { 
	$AllMailboxes += Get-Mailbox -OrganizationalUnit $ou.DistinguishedName -ResultSize Unlimited -ignoreDefaultScope |Select-Object OrganizationalUnit,DisplayName,PrimarySmtpAddress, @{Name="EmailAddresses";Expression={$_.EmailAddresses |Where-Object {$_.PrefixString -ceq "smtp"} | ForEach-Object {$_.SmtpAddress}}}
} 
$AllMailboxes |Export-Csv c:\test.csv -NoTypeInformation