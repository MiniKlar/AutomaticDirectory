<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$DomainAddress,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$NetbiosName
)

$password = & $PSScriptRoot"\PasswordGUIPrompt.ps1"
    
Install-ADDSForest -DomainName $DomainAddress -DomainNetbiosName $NetbiosName -SafeModeAdministratorPassword $password -Force
