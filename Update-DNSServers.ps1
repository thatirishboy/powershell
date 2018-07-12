# .SYNOPSIS
# Script to change primary and secondary DNS servers.
#
# .DESCRIPTION
# This script will change the DNS servers on remote machines listed in a text file (.\computers.txt) to the specified IP addresses.  Must be run as a Domain Admin.              |
#
# Created by: Trey Donovan
# Last Updated: 11/09/11
#
# .EXAMPLE
# ./Update-DNSServers.ps1

Param(
	[parameter(mandatory=$True)]
	[String]
	[alias("pri")]
	$Primary,
	[String]
	[alias("sec")]
	$Secondary
)

$servers = Get-Content .\computers.txt 

foreach($server in $servers) {
	"Connect to $server..."
	$nics = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $server -ErrorAction Inquire | Where{$_.IPEnabled -eq "TRUE"}
	$newDNS = "$Primary,Secondary"
	foreach($nic in $nics) {
		"`tExisting DNS Servers $nic.DNSServerSearchOrder"
		$x = $nic.SetDNSServerSearchOrder($newDNS)
		if($x.ReturnValue -eq 0) {
			"`tSuccessfully Changed DNS Servers on $server"
		}
		else {
			"`tFailed to Change DNS Servers on $server"
		}
	}
}
