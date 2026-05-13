<# .Name #>

[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$AccountName
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

$scriptPassword = $PSScriptRoot+"\PasswordGUIPrompt.ps1"

# Prompt for user details
$NewPassword  = & $scriptPassword

try {
    Set-ADAccountPassword `
        -Identity $AccountName `
        -Reset `
        -NewPassword $NewPassword

    Set-ADUser `
        -Identity $AccountName `
        -ChangePasswordAtLogon $true

    Unlock-ADAccount `
        -Identity $AccountName

    Enable-ADAccount `
        -Identity $AccountName

    Write-Host "Password succesfully reseted for user '$AccountName'" -ForegroundColor Green
}
catch {
    Write-Error "Failed to reset user's password: $_"
}