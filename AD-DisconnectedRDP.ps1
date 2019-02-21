Import-Module ActiveDirectory
$arrayofStringsNonInterestedIn = "console" , "RDP" , "services"
$SessionList = "ACTIVE SERVER SESSIONS REPORT - " + $today + "`n`n"
$Servers = Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' }
ForEach ($Server in $Servers) {
	$ServerName = $Server.Name
	Write-Host "Querying $ServerName"
	$queryResults = (qwinsta /server:$ServerName | foreach { (($_.trim() -replace "\s+",","))} | ConvertFrom-Csv) 
	ForEach ($queryResult in $queryResults) { 
		$RDPUser = $queryResult.USERNAME 
		$sessionType = $queryResult.SESSIONNAME 
		$State=$queryResult.State
		If ($queryResult.ID -eq "Disc") {
			$RDPUser = $queryResult.Sessionname
			$SessionType=" "
			$State=$queryResult.ID
		}
	    If (($RDPUser -match "[a-z]") -and ($RDPUser -ne $NULL) -and ($RDPUser -ne "Disc")) { 
			Write-Host $ServerName logged in by $RDPUser on $sessionType
			$SessionList = $SessionList + "`n`n" + $ServerName + " logged in by " + $RDPUser + " on " + $sessionType
		}
	}
}

get-content $sessionlist | where {$arrayofStringsNonInterestedIn -notcontains $_}
Write-host $SessionList

$SessionList2 = ""
ForEach($l in $SessionList.split("`n")){
    if ($l.Trim().Equals("")){continue}
    if ($l.Contains("services")) {continue}
    if ($l.Trim().EndsWith("on")) {$SessionList2 += $l + "`n"}
}
Write-host $SessionList2 
