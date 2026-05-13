<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$DomainAddress
)

$InDomain = Get-CimInstance -ClassName Win32_ComputerSystem

if ($InDomain.PartOfDomain) {
    Write-Output "Machine has joined a domain."
} else {
    Write-Output "Machine is not in a domain"
    $cred = Get-Credential
    Add-Computer -DomainName test.com -Credential $cred -Force -Restart
}

$cred = Get-Credential
$password = & $PSScriptRoot"\PasswordGUIPrompt.ps1"

Install-ADDSDomainController -DomainName $DomainAddress -SafeModeAdministratorPassword $password -Credential $cred