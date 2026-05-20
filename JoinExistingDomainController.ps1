<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$DomainAddress
)

$InDomain = Get-CimInstance -ClassName Win32_ComputerSystem

if ($InDomain.PartOfDomain) {
    Write-Output "This server has already joined a domain."
    exit 1
} else {
    Write-Output "This server is not part of a domain."
    #Credentials of the primary DC
    $cred = Get-Credential
    Add-Computer -DomainName test.com -Credential $cred -Force -Restart
}

$cred = Get-Credential
$password = & $PSScriptRoot"\PasswordGUIPrompt.ps1"

Install-ADDSDomainController -DomainName $DomainAddress -SafeModeAdministratorPassword $password -Credential $cred

exit 0