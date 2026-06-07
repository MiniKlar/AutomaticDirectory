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

# Check if the server is already a domain controller
if ((Get-CimInstance Win32_OperatingSystem).ProductType -eq 2) {
    Write-Error "This server is already a domain controller."
    exit 1
}

# Try to resolve the domain to configure DNS automatically
try {
    $resolved = Resolve-DnsName -Name $DomainAddress -ErrorAction Stop
} catch {
    Write-Host "Unable to resolve $DomainAddress. Searching for a DNS server via network (subnet)..."
    $PrimaryDCIP = & "$PSScriptRoot/OpenGUIPrompt.ps1" -promptString "Enter the IP address of a domain controller for $DomainAddress :"
    
    if ($PrimaryDCIP) {
        try {
            $Interface = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
            if (-not $Interface) {
                throw "No active (Up) network adapter found."
            }
            Set-DnsClientServerAddress -InterfaceIndex $Interface.InterfaceIndex -ServerAddresses $PrimaryDCIP -ErrorAction Stop
            Write-Host "DNS configured on $PrimaryDCIP"
        } catch {
            Write-Error "Failed to configure DNS: $($_.Exception.Message)"
            exit 1
        }
    } else {
        Write-Error "No domain controller IP provided. Cannot proceed."
        exit 1
    }
}

try {
    # Get domain administrator credentials
    Write-Host "Please provide credentials for an administrator of domain $DomainAddress"
    $cred = Get-Credential

    # Normalize the user name to the "long" (FQDN) form, e.g. toutexiste.com\Administrator.
    # Install-ADDSDomainController fails with RPC error 1749 ("The security context is
    # invalid") and hangs at "Creating the NTDS settings object" when given a bare or
    # NetBIOS-style name (Administrator / DOMAIN\Administrator). The GUI wizard normalizes
    # this automatically; the cmdlet does not.
    $userName = $cred.UserName
    if ($userName -notmatch '[\\@]') {
        # Bare "Administrator" -> prepend the domain FQDN
        $userName = "$DomainAddress\$userName"
    } elseif ($userName -match '^[^\\]+\\(.+)$') {
        # "DOMAIN\Administrator" (NetBIOS) -> rebuild with the domain FQDN
        $userName = "$DomainAddress\$($Matches[1])"
    }
    if ($userName -ne $cred.UserName) {
        $cred = New-Object System.Management.Automation.PSCredential($userName, $cred.Password)
    }

    # Get DSRM password
    Write-Host "Please enter the DSRM password (Safe Mode)."
    $dsrmPassword = & "$PSScriptRoot/PasswordGUIPrompt.ps1"

    # Promote as an additional DC
    # -Force suppresses the interactive confirmation prompt that would otherwise
    # block the cmdlet indefinitely while configuring AD DS.
    Install-ADDSDomainController `
        -DomainName $DomainAddress `
        -SafeModeAdministratorPassword $dsrmPassword `
        -Credential $cred `
        -Force
} catch {
    Write-Error "Promotion failed: $($_.Exception.Message)"
    exit 1
}

# Note: Install-ADDSDomainController restarts the server on success, so execution
# typically does not reach this point.
Write-Host "Promotion successful. The server will restart."
exit 0