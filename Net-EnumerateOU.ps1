#===========================================================
#| Net-EnumerateOU.ps1                                     |
#===========================================================
#|                                                         |
#| Created by:   Trey Donovan                              |
#| Last Updated: 06/20/12                                  |
#|                                                         |
#===========================================================
#|                                                         |
#| This script enumerates all computer objects in a        |
#| pre-definted OU.  Results are saved to .\servers.txt    |
#|                                                         |
#===========================================================

$ou = [ADSI]"LDAP://OU=Domain Controllers,DC=exchange,DC=local"
foreach ($child in $ou.psbase.Children) { 
    if ($child.ObjectCategory -like '*computer*') {
		Add-Content .\servers.txt $child.Name
	} 
}
