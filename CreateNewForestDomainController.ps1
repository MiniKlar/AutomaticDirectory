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

# Ensure the ADDSDeployment module is available
try {
    Import-Module ADDSDeployment -ErrorAction Stop
}
catch {
    Write-Error "Failed to import ADDSDeployment module. Ensure you have the necessary permissions and the module is installed."
    exit 1
}

# Check if the server is already in a Forest

try {
    Get-ADForest
} catch {
    Write-Error "The domain '$DomainAddress' is not reachable or does not exist."
    exit 1
}

# Retrieve password with custom window
$password = & $PSScriptRoot"\PasswordGUIPrompt.ps1"

# Promote the Active Directory to a Forest Domain Controller
Install-ADDSForest -DomainName $DomainAddress -DomainNetbiosName $NetbiosName -SafeModeAdministratorPassword $password -Force

exit 0