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
    Write-Error "Failed to import ActiveDirectory module. Ensure you have the necessary permissions and that the module is installed on your server."
    exit 1
}

try {
    Get-ADForest #check if this is working when server is not in a forest
} catch {
    Write-Host "You are already in a forest"
    exit 1
}

$password = & $PSScriptRoot"\PasswordGUIPrompt.ps1"
    
Install-ADDSForest -DomainName $DomainAddress -DomainNetbiosName $NetbiosName -SafeModeAdministratorPassword $password -Force

exit 0