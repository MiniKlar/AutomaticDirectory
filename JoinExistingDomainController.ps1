<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$DomainAddress
)

# Ensure the ADDSDeployment module is available
try {
    Import-Module ADDSDeployment -ErrorAction Stop
}
catch {
    Write-Error "Failed to import ADDSDeployment module. Ensure you have the necessary permissions and the module is installed."
    exit 1
}

# Check if the server is already part of a domain
$InDomain = Get-CimInstance -ClassName Win32_ComputerSystem

if ($InDomain.PartOfDomain) {
    Write-Output "This server has already joined a domain."
    exit 1
} else {
    Write-Output "This server is not part of a domain."
    $cred = Get-Credential # Warning: Input the primary DC's credentials
    Add-Computer -DomainName $DomainAddress -Credential $cred -Force -Restart
}

# Promote the AD server to Domain Controller for the specific domain

$cred = Get-Credential
$password = & $PSScriptRoot"\PasswordGUIPrompt.ps1"

Install-ADDSDomainController -DomainName $DomainAddress -SafeModeAdministratorPassword $password -Credential $cred

exit 0