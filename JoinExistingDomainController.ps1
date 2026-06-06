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

# Check if the server is already in a Forest
try {
    Get-ADForest -ErrorAction Stop | Out-Null
    Write-Error "The server is already in a Forest."
    exit 1
} catch {}

# Try to resolve the domain to configure DNS automatically
try {
    $resolved = Resolve-DnsName -Name $DomainAddress -ErrorAction Stop
} catch {
    Write-Host "Unable to resolve $DomainAddress. Searching for a DNS server via network (subnet)..."
    $PrimaryDCIP = & "$PSScriptRoot/OpenGUIPrompt.ps1" -promptString "Enter the IP address of a domain controller for $DomainAddress :"
    
    if ($PrimaryDCIP) {
        $Interface = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
        Set-DnsClientServerAddress -InterfaceIndex $Interface.InterfaceIndex -ServerAddresses $PrimaryDCIP
        Write-Host "DNS configured on $PrimaryDCIP"
    }
}

try {
    # Get domain administrator credentials
    Write-Host "Please provide credentials for an administrator of domain $DomainAddress"
    $cred = Get-Credential

    # Get DSRM password
    Write-Host "Please enter the DSRM password (Safe Mode)."
    $dsrmPassword = & "$PSScriptRoot/PasswordGUIPrompt.ps1"

    # Promote as an additional DC
    Install-ADDSDomainController `
        -DomainName $DomainAddress `
        -SafeModeAdministratorPassword $dsrmPassword `
        -Credential $cred
} catch {
    Write-Error "Promotion failed: $($_.Exception.Message)"
    exit 1
}

Write-Host "Promotion successful. The server will restart."
exit 0