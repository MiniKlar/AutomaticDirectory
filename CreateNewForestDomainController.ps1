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

# Check if we can import the AD module to know if we have correctly installed the AD. This allow us to check if we can create a Forest.

try {
    Import-Module ActiveDirectory -ErrorAction Stop
}
catch {
    Write-Error "Failed to import ActiveDirectory module. Ensure you have the necessary permissions and that the module is installed on your server."
    exit 1
}

# Check if the server is already in a Forest

try {
    Get-ADForest
} catch {
    Write-Host "You are already in a forest"
    exit 1
}

# Install the Forest

$password = & $PSScriptRoot"\PasswordGUIPrompt.ps1"
    
Install-ADDSForest -DomainName $DomainAddress -DomainNetbiosName $NetbiosName -SafeModeAdministratorPassword $password -Force

exit 0