#===========================================================
#| Net-ChangeDNSServers.ps1                                |
#===========================================================
#|                                                         |
#| Created by:   Trey Donovan                              |
#| Last Updated: 11/09/11                                  |
#|                                                         |
#===========================================================
#|                                                         |
#| This script will change the DNS servers on remote       |
#| machines listed in a text file to the specified IP      |
#| addresses.  Must be run as a Domain Admin.              |
#|                                                         |
#===========================================================

$servers = Get-Content .\computers.txt 

foreach($server in $servers) {
	Write-Host "Connect to $server..."
	$nics = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $server -ErrorAction Inquire | Where{$_.IPEnabled -eq "TRUE"}
	$newDNS = "10.9.1.45","10.27.140.165"
	foreach($nic in $nics) {
		Write-Host "`tExisting DNS Servers " $nic.DNSServerSearchOrder
		$x = $nic.SetDNSServerSearchOrder($newDNS)
		if($x.ReturnValue -eq 0) {
			Write-Host "`tSuccessfully Changed DNS Servers on " $server
		}
		else {
			Write-Host "`tFailed to Change DNS Servers on " $server
		}
	}
}
