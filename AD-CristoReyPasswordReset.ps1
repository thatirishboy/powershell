$exportfile = "c:\trey\passreset.csv"
Write-Host Gathering users.... -foreground darkgreen
$users = Get-ADUser -SearchBase "OU=Students,DC=CR,DC=local" -filter *
Write-Host Setting passwords.... -foreground darkgreen
ForEach ($user in $users) {
	$number = Get-Random -Minimum 1111 -Maximum 9999
	$last = $user.surname
	$last = $last.tolower()
	If ($last.length -gt 4) { $last = $last.substring(0,4) }
	$newpass = $last + $number
	$hash = @{
		"Full Name" = $user.name
		"AccountName" = $user.sAMAccountName
		"New Password" = $newpass
	}
	$newpass = ConvertTo-SecureString -String $newpass -AsPlainText -Force
	Write-Host Setting $user.SAMAccountName... -foreground yellow
	Set-ADAccountPassword -Identity $user -NewPassword $newpass -Reset
	$newrow = New-Object PSObject -Property $hash
	Export-Csv $exportfile -InputObject $newrow -Append -Force -NoTypeInformation
}
Write-Host Done -foreground darkgreen
