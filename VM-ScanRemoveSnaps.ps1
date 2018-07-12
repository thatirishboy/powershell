#===========================================================
#| VM-ScanRemoveSnaps.ps1                                  |
#===========================================================
#|                                                         |
#| Created by:   Trey Donovan                              |
#| Last Updated: 03/14/12                                  |
#|                                                         |
#===========================================================
#|                                                         |
#| This script check for all VM snapshots and give an      |
#| option to remove it.                                    |
#|                                                         |
#===========================================================

clear
foreach ($vm in get-vm | sort-object){ 
	$snaps = get-snapshot -vm $vm 
	$vmname = $vm.name 
	"**************************************************************" 
	"Checking $vmname ..." 
	foreach ($snap in $snaps){ 
		$snapName = $snap.name 
		if ($snapname -ne $null){ 
			"  " 
			$strOut = "Found snapshot: $snapname on: $vmname" 
			$strOut | Out-Default 
			$snap | select-object * 
			# Rem the following line to perform just inventory, leave to get the remove prompt. 
			remove-snapshot -snapshot $snap 
		} 
		else {"No snapshots found on $vmname"} 
		"  " 
	} 
}
