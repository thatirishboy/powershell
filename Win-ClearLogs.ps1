#╒═════════════════════════════════════════════════════════╕
#│ Win-ClearLogs.ps1                                       │
#╞═════════════════════════════════════════════════════════╡
#│ Created by:   Trey Donovan                              │
#│ Last Updated: 01/30/17                                  │
#╞═════════════════════════════════════════════════════════╡
#│ This script enumerates and clears all local Event Logs. │
#│ existing AD accounts.                                   │
#│                                                         │
#│ Requirements:                                           │
#│   - Must run as administrator                           │
#╘═════════════════════════════════════════════════════════╛

$Logs = Get-EventLog -List | ForEach {$_.Log}
$Logs | ForEach {Clear-EventLog -Log $_ }
Get-EventLog -List