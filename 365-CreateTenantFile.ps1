#╒═════════════════════════════════════════════════════════╕
#│ 365-CreateTenantFile.ps1                                │
#╞═════════════════════════════════════════════════════════╡
#│ Created by:   Trey Donovan                              │
#│ Last Updated: 07/28/16                                  │
#╞═════════════════════════════════════════════════════════╡
#│ This script prompts for Office365 admin credentials and │
#│ generates an encrypted .key file to store on local      │
#│ drive for use with other scripts that require a login   │
#│ to Office365.                                           │
#╘═════════════════════════════════════════════════════════╛

Read-Host -Prompt "Enter your tenant password" -AsSecureString | ConvertFrom-SecureString | Out-File "C:\O365Connections\keys\tenant1.key"