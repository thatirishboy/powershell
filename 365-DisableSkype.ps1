$users = Get-MsolUser -All | Where-Object {$_.isLicensed -eq $true}
foreach ($user in $users) {
	Write-Host "Checking " $user.UserPrincipalName -foregroundcolor "Cyan"
	$CurrentSku = $user.Licenses.Accountskuid
	#If more than one SKU, Have to check them all!
	if ($currentSku.count -gt 1) {
		Write-Host $user.UserPrincipalName "Has Multiple SKU Assigned. Checking all of them" -foregroundcolor "White"
		for($i = 0; $i -lt $currentSku.count; $i++)	{
			#Loop trough Each SKU to see if one of their services has the word Skype inside
			if($user.Licenses[$i].ServiceStatus.ServicePlan.ServiceName -like "*Skype*" ) {
				Write-host $user.Licenses[$i].AccountSkuid "has Skype. Will  Disable" -foregroundcolor "Yellow"
				$NewSkU = New-MsolLicenseOptions -AccountSkuId $user.Licenses[$i].AccountSkuid -DisabledPlans MCOSTANDARD
				Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -LicenseOptions $NewSkU
				Write-Host "Skype disabled for " $user.UserPrincipalName " On SKU " $user.Licenses[$i].AccountSkuid -foregroundcolor "Green"
			}
			else {
				Write-host $user.Licenses[$i].AccountSkuid " doesn't have Skype. Skip" -foregroundcolor "Magenta"
			}
		}
	}
	else {
		$NewSkU = New-MsolLicenseOptions -AccountSkuId $CurrentSku -DisabledPlans MCOSTANDARD
		Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -LicenseOptions $NewSkU
		Write-Host "Skype disabled for " $user.UserPrincipalName -foregroundcolor "Green"
	}
}