#╒═════════════════════════════════════════════════════════╕
#│ Net-PingComputers.ps1                                   │
#╞═════════════════════════════════════════════════════════╡
#│ Created by:   Trey Donovan                              │
#│ Last Updated: 11/10/11                                  │
#╞═════════════════════════════════════════════════════════╡
#│ This script will ping all computers in the AD and tell  │
#│ whether they reply or not.                              │
#╘═════════════════════════════════════════════════════════╛

$datetime = Get-Date -Format "yyyyMMddhhmmss"
$strCategory = "computer"
 
# Create a Domain object. With no params will tie to computer domain
$objDomain = New-Object System.DirectoryServices.DirectoryEntry
 
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher; # AD Searcher object
$objSearcher.SearchRoot = $objDomain; # Set Search root to our domain
$objSearcher.Filter = ("(objectCategory=$strCategory)"); # Search filter
 
$colProplist = "name"
foreach ($i in $colPropList) {
	$objSearcher.PropertiesToLoad.Add($i)
}
 
$colResults = $objSearcher.FindAll()
 
foreach ($objResult in $colResults) {
	$objComputer = $objResult.Properties
	# Get the computer ping properties
	$computer = $objComputer.name
	$ipAddress = $pingStatus.ProtocolAddress
	# Ping the computer
	$pingStatus = Get-WmiObject -Class Win32_PingStatus -Filter "Address = '$computer'"
	if($pingStatus.StatusCode -eq 0) {
		Write-Host -ForegroundColor Green  "Reply received from $computer"
	} else {
		Write-Host -ForegroundColor Red "No Reply received from $computer"
	}
}
