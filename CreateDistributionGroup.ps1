<# .Name #>

[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$GroupName,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$OU,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Scope,
    
    [ValidateNotNullOrEmpty()]
    [string]$Description
)

# Ensure the ActiveDirectory module is available
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Write-Error "Active Directory module not found. Please install RSAT or run on a domain controller."
    exit 1
}

try {
    Get-ADOrganizationalUnit -Identity $OU -ErrorAction Stop | Out-Null
}
catch {
    Write-Error "The specified OU does not exist: $OU"
    exit 1
}

# Create the AD group
try {
    New-ADGroup `
        -Name $GroupName `
        -GroupScope $Scope `
        -GroupCategory Distribution `
        -Path $OU `
        -Description $Description `
        -PassThru | Out-Host

    Write-Host "Group '$GroupName' created successfully in $OU" -ForegroundColor Green
} catch {
    Write-Error "Failed to create group: $_"
}
