<# .Name #>

[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Attributes
)

# Ensure the ActiveDirectory module is available
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Write-Error "Active Directory module not found. Please install RSAT or run on a domain controller."
    exit 1
}

if ($Attributes -notmatch '^[a-zA-Z0-9_,]+$') {
    Write-Error "Please enter valid attributes"
    exit 1
}

$AttributeArray = $Attributes -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" } | Select-Object -Unique
$UserArray = (Get-ADUser -Filter * -Properties SamAccountName).SamAccountName

foreach($user in $UserArray){
    try {
        $values = (Get-ADUser $user -Properties $AttributeArray)
        $values = $values | Select-Object $AttributeArray

        foreach ($attr in $AttributeArray) {
            $value = ($values | Select-Object $attr).$attr

            if ([string]::IsNullOrWhiteSpace($value)) {
                Write-Host "'$user' $attr isn't set" -ForegroundColor DarkYellow
            }
            else {
                Write-Host "'$user' $attr : $Value" -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Error "Failed to retrieve user's attribute (Stopping here to avoid duplicate error messages): $_"
        exit 1
    }
    Write-Host ""
}