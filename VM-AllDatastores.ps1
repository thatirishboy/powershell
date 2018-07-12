#╒═════════════════════════════════════════════════════════╕
#│ VM-AllDatastores.ps1                                    │
#╞═════════════════════════════════════════════════════════╡
#│ Created by:   Trey Donovan                              │
#│ Last Updated: 04/12/12                                  │
#╞═════════════════════════════════════════════════════════╡
#│ This script will list all Datastores along with the     │
#│ size, provisioned size, and used space.                 │
#╘═════════════════════════════════════════════════════════╛

Get-VM |
Foreach-Object {
	if ($_) {
		$vm = $_
		$vm |
		Get-Datastore |
			Foreach-Object {
			if ($_) {
				$Datastore = $_
				"" |
				Select-Object -Property @{N="VM name";E={$vm.Name}},
				@{N="Datastore Name";E={$Datastore.Name}},
				@{N="Datastore Size (GB)";E={[Math]::Round($Datastore.CapacityGB,0)}},
				@{N="Datastore Total Provisioned size (GB)";E={[Math]::Round($Datastore.CapacityGB-$Datastore.FreeSpaceGB+$Datastore.ExtensionData.Summary.Uncommitted/1GB,0)}},
				@{N="Datastore Used Space (GB)";E={[Math]::Round($Datastore.CapacityGB-$Datastore.FreeSpaceGB,0)}}
			}
		}
	}
}
