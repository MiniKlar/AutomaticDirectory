<# .Name #>

[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$AccountName,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$AttributeName,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Value
)

# Ensure the ActiveDirectory module is available
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Write-Error "Active Directory module not found. Please install RSAT or run on a domain controller."
    exit 1
}

try {
    Get-ADUser -Identity $AccountName -ErrorAction Stop | Out-Null
}
catch {
    Write-Error "The specified user '$AccountName' doesn't exist"
    exit 1
}

try {
    Set-ADUser `
        -Identity $AccountName `
        -Replace @{$AttributeName = $Value}

    Write-Host "'$AccountName' $AttributeName succesfully changed to $Value" -ForegroundColor Green
}
catch {
    Write-Error "Failed to change user's attribute: $_"
}