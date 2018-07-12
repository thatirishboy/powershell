# .SYNOPSIS
# Script to find list all processes using more than 25% CPU.
#
# .DESCRIPTION
# This script will return all processes using more than 25% CPU utilization.
#
# Created by: Trey Donovan
# Last Updated: 11/09/11
#
# .EXAMPLE
# ./Get-ProcessesOver25Percent.ps1 BACKUP,FILESERVERVM,DC1PERKINS

if ($env:NUMBER_OF_PROCESSORS -eq 2){
	$procpercent = 50                  #represents 25 % of the CPU usage on a 2 CPU system
} elseif ($env:NUMBER_OF_PROCESSORS -eq 4){
	$procpercent = 100                 #represents 25 % of the CPU usage on a 4 CPU system
}

$servers = $args[0]
$customtable = @{Expression={$_.InstanceName};Label="Process_Name";width=9}, @{Expression={$_.CookedValue/$env:NUMBER_OF_PROCESSORS -as [int]};Label="CPU_usage_%"}

foreach ($server in $servers){
	$server
	$Proc = Get-counter -ComputerName $server "\Process(*)\% processor time"
	$procresult = $Proc.CounterSamples | where {$_.cookedvalue -ge $procpercent} | where {$_.instanceName -ne "idle"} | where {$_.instanceName -ne "_total"}
	if ($procresult -eq $null){
		$procpercentconvert = $procpercent/$env:NUMBER_OF_PROCESSORS
		"No Processes with CPU usage greater than $procpercentconvert %"
	} else {
		$procresult | Format-Table $customtable -auto
	}
}
