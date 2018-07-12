cls
$ErrorActionPreference = "SilentlyContinue"
Get-Content (ENTER PATH TO YOUR INPUT FILE HERE) | foreach {
    [ADSI]"WinNT://$_/administrator" | select `
    $(Name="Account";Expression={($_.PSBase).Path}}, `
    $(Name="Password Set";Expression={(Get-Date).AddSeconds(-($_.PasswordAge)[0])}}; `
    $(Name="PasswordAge (Days)";Expression={[int]((4-.PasswordAge)[0]/86400) }}, `
    $(Name="Last Logon";Expression={$_.LastLogin}}, `
    $(Name="Days Since Last Logn";Expression={ `
    (New-TimeSpan -start ($_.LastLogin[0]) -end (Get-Date)).days}}} `
| Export-csv (ENTER PATH TO YOUR OUTPUT FILE HERE) -notypeinformation
