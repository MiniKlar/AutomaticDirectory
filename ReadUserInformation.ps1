<# .Name #>

[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$AccountName,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$AttributeName
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
    $value = (Get-ADUser $AccountName -Properties $AttributeName).$AttributeName
    if ([string]::IsNullOrWhiteSpace($value)) {
        Write-Host "'$AccountName' $AttributeName isn't set" -ForegroundColor DarkYellow
    }
    else {
        Write-Host "'$AccountName' $AttributeName : $Value" -ForegroundColor Green
    }
}
catch {
    Write-Error "Failed to retrieve user's attribute: $_"
}