#╒═════════════════════════════════════════════════════════╕
#│ AD-RemoveAndRemapPrinters.ps1                           │
#╞═════════════════════════════════════════════════════════╡
#│ Created by:   Trey Donovan                              │
#│ Last Updated: 09/14/17                                  │
#╞═════════════════════════════════════════════════════════╡
#│ This script removed all mapped printers then enumerates │
#│ all available printers on print server and maps them.   │
#│                                                         │
#│ Requirements:                                           │
#│   - Must be joined to the domain                        │
#│   - Have name of print server in the second part        │
#╘═════════════════════════════════════════════════════════╛


# Remove all mapped printers
Get-WmiObject -Class Win32_Printer | where{$_.Network -eq ‘true‘}| foreach{$_.delete()}

# Map all available printers
& { $Wmi = ([wmiclass]'Win32_Printer') ; $Wmi.Scope.Options.EnablePrivileges = $true; gwmi win32_printer -ComputerName 'PS1' -Filter 'shared=true' | foreach {$Wmi.AddPrinterConnection( [string]::Concat('\\', $_.__SERVER, '\', $_.ShareName) )} }