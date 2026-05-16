<# .Name #>

[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$GroupName
)

# Ensure the ActiveDirectory module is available
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Write-Error "Active Directory module not found. Please install RSAT or run on a domain controller."
    exit 1
}

try {
    Get-ADGroup -Identity $GroupName -ErrorAction Stop | Out-Null
}
catch {
    Write-Error "The specified group does not exist: $GroupName"
    exit 1
}

try {
    Get-ADGroupMember $GroupName
} catch {
    Write-Error "Failed to lsit group's users: $_"
}