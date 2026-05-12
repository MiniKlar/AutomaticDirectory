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

try {
    Import-Module ActiveDirectory -ErrorAction Stop
}
catch {
    Write-Error "Failed to import ActiveDirectory module. Ensure you have the necessary permissions and the module is installed."
    exit 1
}

$password = & $PSScriptRoot"\PasswordGUIPrompt.ps1"
    
Install-ADDSForest -DomainName $DomainAddress -DomainNetbiosName $NetbiosName -SafeModeAdministratorPassword $password -Force
