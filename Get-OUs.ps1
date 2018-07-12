# .SYNOPSIS
# Get list of all PCs in specified OU.
#
# .DESCRIPTION
# This script enumerates all computer objects in a pre-definted OU.
#
# Created by: Trey Donovan
# Last Updated: 06/20/12
#
# .EXAMPLE
# ./Get-OUs.ps1
# .EXAMPLE
# ./Get-OUs.ps1 | Out-File .\servers.txt

$ou = [ADSI]"LDAP://OU=Domain Controllers,DC=exchange,DC=local"
foreach ($child in $ou.psbase.Children) { 
    if ($child.ObjectCategory -like '*computer*') {
		$child.Name
	} 
}
