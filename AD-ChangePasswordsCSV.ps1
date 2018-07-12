#╒═════════════════════════════════════════════════════════╕
#│ AD-ChangePasswordsCSV.ps1                               │
#╞═════════════════════════════════════════════════════════╡
#│ Created by:   Trey Donovan                              │
#│ Last Updated: 06/22/16                                  │
#╞═════════════════════════════════════════════════════════╡
#│ This script takes a CSV file to change passwords for    │
#│ existing AD accounts.                                   │
#│                                                         │
#│ Requirements:                                           │
#│   - Must be run on domain controller                    │
#│   - Must run as a Domain Admin with permission to       │
#│     modify users                                        │
#╘═════════════════════════════════════════════════════════╛

Write-Host Processing... -ForegroundColor YELLOW
ipmo ActiveDirectory
$sourcefile = ".\pcpsb.csv"
$users = Import-Csv $sourcefile
$i = 1
ForEach ($user in $users) {
	$useremail = $user.email
	$filter = "EmailAddress -eq ""$useremail"""
	$username = Get-ADUser -Filter $filter
	$password = (ConvertTo-SecureString -AsPlainText $user.password -Force)
	Write-Progress -Activity ("Setting password for " + $username) -PercentComplete (($i/(@($users).count)*100 ))  -CurrentOperation "$i% complete" -Status "Please wait."
	Set-ADAccountPassword -Identity $username -NewPassword $password -Reset
}
Write-Host "Thank you, drive through." -ForegroundColor MAGENTA
