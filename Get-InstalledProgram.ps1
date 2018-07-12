# .SYNOPSIS
# Script to find all installations of a given application.
#
# .DESCRIPTION
# This script scans all online network computers listed in AD for installations of RealVNC.
#
# Created by: Trey Donovan
# Last Updated: 04/20/12
#
# .EXAMPLE
# ./Get-InstalledProgram.ps1 -Application "VNC 4.0"
# .EXAMPLE
# ./Get-InstalledProgram.ps1 -Application "RealVNC" | Out-File .\vncscan.txt

Param(
	[parameter(mandatory=$True)]
	[String]
	[alias("app")]
	$Application
)

# Enumerate Computers from AD
$a = Get-Date
$blah = [ADSI]"$base"
$objDomain = New-Object System.DirectoryServices.DirectoryEntry
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.Filter = "(objectClass=computer)"
$objSearcher.SearchRoot = $blah
$propList = "cn","operatingSystem"
foreach ($i in $propList){$objSearcher.PropertiesToLoad.Add($i)}
$results = $objSearcher.FindAll()
$i = 0
"Starting Scan for $Application $a`n====================================="

# Cycle Through Computers
foreach ($objResult in $results)
{
    $computer = $objResult.Properties.cn
	#$server_progress = [int][Math]::Ceiling((($i / $results.Length) * 100))
	#Write-Progress -Activity "Checking $computer" -PercentComplete $server_progress -Status "Processing servers - $server_progress%" -Id 1;
	$isAlive = Test-Connection $computer -count 1 -quiet  # Check if computer is online
	if ($isAlive -eq "True")
	{
		$branch='LocalMachine'	# Branch of the Registry
		$subBranch="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"	# Main Sub Branch you need to open
		$registry=[microsoft.win32.registrykey]::OpenRemoteBaseKey('Localmachine',$computer)  
		$registrykey=$registry.OpenSubKey($subBranch)  
		$subKeys=$registrykey.GetSubKeyNames()  
		$j = 0

		# Check Registry for Installed Program
		foreach ($key in $subKeys)  
		{  
			$reg_progress = [int][Math]::Ceiling((($j / $subKeys.length) * 100))
			#Write-Progress -Activity "Scanning Registry Key $key" -PercentComplete $reg_progress -Status "Processing registry - $reg_progress%" -Id 2;
			$exactkey=$key  
			$newSubKey=$subBranch+"\\"+$exactkey  
			$ReadUninstall=$registry.OpenSubKey($newSubKey)  
			$value=$ReadUninstall.GetValue("DisplayName")  
			If ($value -eq $Application)
			{
				"$Application found on $computer"
			}
			$j++
		}
	}
	$i++
}
$b = Get-Date
"=====================================`n$Application Scan Scan Completed $b"
