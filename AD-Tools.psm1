#╒═════════════════════════════════════════════════════════╕
#│ AD-Tools.psm1                                           │
#╞═════════════════════════════════════════════════════════╡
#│ Created by:   Trey Donovan                              │
#│ Last Updated: 11/06/19                                  │
#╞═════════════════════════════════════════════════════════╡
#│ Module containing frequently used AD cmdlets and script │
#│ functions.                                              │
#╘═════════════════════════════════════════════════════════╛

function Get-ADComputerCount { # // Get Current AD Computer Count
    $adcompcount = Get-ADComputer -Filter {(Enabled -eq $True)}
    return $adcompcount.count
}

function Get-ADComputerOS { # // Get OS of AD computers
    param($compname = "*")
    $adcompos = Get-ADComputer -Filter $compname -Property Name,OperatingSystem
    return $adcompos
}

function Set-FSMORoles { # // Transfer All FSMO Roles
    param($targetdc)
    Move-ADDirectoryServerOperationMasterRole -Identity $targetdc -OperationMasterRole SchemaMaster,RIDMaster,InfrastructureMaster,DomainNamingMaster,PDCEmulator
}

function Set-TimeSync { # // Set Time Sync
    net stop w32time
    w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org"
    w32tm /config /reliable:yes
    net start w32time
    w32tm /config /update
    w32tm /resync /rediscover
}

function Get-GPResult { # // GP Result to File
    param($path = "C:\Trey\",$filename = "gpresult.html")
    If(-not (Test-Path $path)) {
        try {
            New-Item -Path $path -ItemType Directory -ErrorAction Stop | Out-Null
        } catch {
            Write-Error -Message "Unable to create directory '$path'. Error was: $_" -ErrorAction Stop
        }
    }
    If(Test-Path $path\$filename) {
        try {
            Remove-Item $path\$filename -ErrorAction Stop | Out-Null
        } catch {
            Write-Error -Message "Unable to delete file '$path'\'$filename'.  Error was: $_" -ErrorAction Stop
        }
    }
    Set-Location $path
    gpresult /h $path\$filename
}

function Remove-ADLeafObject { # // Remove AD Leaf Objects
    param($computername)
    Remove-ADobject (Get-ADComputer $computername).distinguishedname -Recursive -Confirm:$false 
}

function Get-SeenComputers { # // Get AD Computers Last Seen in x Days
    param($days = 30)
    $then = (Get-Date).AddDays($days)
    $results = Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -lt $then}
    return $results
}

function Get-UnseenComputers { # // Get AD Computers Not Seen in x Days
    param($days = 30)
    $then = (Get-Date).AddDays($days)
    $results = Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -gt $then}
    return $results
}

function Set-UPN { # // Set UPN
    param($user,$upn)
    Set-ADUser -UserPrincipalName $user + $upn -Identity $user
}

function Get-EnabledUsers { # // Get Enabled AD Users
    Get-ADUser -Filter 'enabled -eq $true' | fl name
}

function Get-ExpiredCertificates { # // Find Expired Certificates
    Get-ChildItem cert:\ -Recurse | Where-Object {$_ -is [System.Security.Cryptography.X509Certificates.X509Certificate2] -and $_.NotAfter -lt (Get-Date)} | Select-Object -Property FriendlyName,NotAfter
}

function Get-CAs { # // Find All CAs
    certutil -config - -ping
}

function Get-ProxyAddress { # // Get ProxyAddresses in AD
    Get-AdUser -Filter 'enabled -eq $true' -Properties proxyaddresses | Select name, @{L='ProxyAddress_1'; E={$_.proxyaddresses[0]}}, @{L='ProxyAddress_2';E={$_.ProxyAddresses[1]}}, @{L='ProxyAddress_3';E={$_.ProxyAddresses[2]}}, @{L='ProxyAddress_4';E={$_.ProxyAddresses[3]}}, @{L='ProxyAddress_5';E={$_.ProxyAddresses[4]}} | Export-CSV .\proxyaddresses.csv -NoTypeInformation
}
