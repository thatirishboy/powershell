#===========================================================
#| Win-DiskCleanup.ps1                                     |
#===========================================================
#|                                                         |
#| Created by:   Trey Donovan                              |
#| Last Updated: 09/29/17                                  |
#|                                                         |
#===========================================================
#|                                                         |
#| This script will clear Windows Update catalog and clear |
#| temp files from profiles and Windows folders and        |
#| cache from all browsers for all users.                  |
#|                                                         |
#===========================================================
#| Note: You only have to change the "MailToRandom1" value |
#| in "Custom Definitions" to change the alarm action      |
#===========================================================

dir C:\Users | select Name | Export-Csv -Path C:\Users\$env:USERNAME\users.csv -NoTypeInformation
$list = Test-Path C:\Users\$env:USERNAME\users.csv
Get-Service -Name wuauserv | Stop-Service -Force -verbose -ErrorAction SilentlyContinue
Get-ChildItem "C:\Windows\SoftwareDistribution\*" -Recurse -Force -verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue
Get-ChildItem "C:\Windows\Temp\*" -Recurse -Force -verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue
Get-ChildItem "C:\Windows\prefetch\*" -Recurse -Force -verbose -ErrorAction SilentlyContinue | Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue
Get-Service -Name wuauserv | Start-Service -Verbose
wevtutil el | Foreach-Object {Write-Host "Clearing $_"; wevtutil cl "$_"}

If ($list) {
    #Clear Mozilla Firefox Cache
    Import-CSV -Path C:\Users\$env:USERNAME\users.csv -Header Name | foreach {
        Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache\* -Recurse -Force -EA SilentlyContinue -Verbose
        Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache\*.* -Recurse -Force -EA SilentlyContinue -Verbose
	    Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache2\entries\*.* -Recurse -Force -EA SilentlyContinue -Verbose
        Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\thumbnails\* -Recurse -Force -EA SilentlyContinue -Verbose
        Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cookies.sqlite -Recurse -Force -EA SilentlyContinue -Verbose
        Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\webappsstore.sqlite -Recurse -Force -EA SilentlyContinue -Verbose
        Remove-Item -path C:\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\chromeappsstore.sqlite -Recurse -Force -EA SilentlyContinue -Verbose
    }
    # Clear Google Chrome 
    Import-CSV -Path C:\Users\$env:USERNAME\users.csv -Header Name | foreach {
        Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -EA SilentlyContinue -Verbose
        Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cache2\entries\*" -Recurse -Force -EA SilentlyContinue -Verbose
        Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cookies" -Recurse -Force -EA SilentlyContinue -Verbose
        Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Media Cache" -Recurse -Force -EA SilentlyContinue -Verbose
        Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cookies-Journal" -Recurse -Force -EA SilentlyContinue -Verbose
    }
    # Clear Internet Explorer
    Import-CSV -Path C:\Users\$env:USERNAME\users.csv | foreach {
        Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -EA SilentlyContinue -Verbose
	    Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Microsoft\Windows\WER\*" -Recurse -Force -EA SilentlyContinue -Verbose
	    Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Temp\*" -Recurse -Force -EA SilentlyContinue -Verbose
	    Remove-Item -path "C:\Windows\Temp\*" -Recurse -Force -EA SilentlyContinue -Verbose
	    Remove-Item -path "C:\`$recycle.bin\" -Recurse -Force -EA SilentlyContinue -Verbose
    }
} Else {
	Write-Host -ForegroundColor Yellow "Session Cancelled"	
	Exit
}
