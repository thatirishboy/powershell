# .SYNOPSIS
# Script to sign other scripts with a cetrificate.
#
# .DESCRIPTION
# This script apply self-signed certificate to another script designated in the command argument.  Must have self-signed certificate set up on local computer first.
#
# Created by: Trey Donovan
# Last Updated: 11/10/11
#
# .EXAMPLE
# ./Sign-PowerShellScript.ps1 -Script Get-InstalledProgram.ps1

Param(
	[parameter(mandatory=$True)]
	[String]
	$Script
)

Set-AuthenticodeSignature $Script @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
