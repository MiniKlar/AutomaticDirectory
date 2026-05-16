<# .Name #>

[CmdletBinding(PositionalBinding=$false)]
param(
    [string]$Attributes
)

# Ensure the ActiveDirectory module is available
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Write-Error "Active Directory module not found. Please install RSAT or run on a domain controller."
    exit 1
}

# Replace attributes by '*' if empty
if ([string]::IsNullOrWhiteSpace($Attributes)) {
    $Attributes = "*"
} elseif ($Attributes -notmatch '^[a-zA-Z0-9_,]+$') {
    Write-Error "Please enter valid attributes"
    exit 1
}

$AttributeArray = $Attributes -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" } | Select-Object -Unique
$GroupArray = (Get-ADGroup -Filter * -Properties SamAccountName).SamAccountName

foreach($group in $GroupArray){
    try {
        if ($AttributeArray -contains "*") {
            Get-ADGroup $group -Properties $AttributeArray
        } else {
            $values = (Get-ADGroup $group -Properties $AttributeArray)
            $values = $values | Select-Object $AttributeArray

            foreach ($attr in $AttributeArray) {
                $value = ($values | Select-Object $attr).$attr

                if ([string]::IsNullOrWhiteSpace($value)) {
                    Write-Host "'$group' $attr isn't set" -ForegroundColor DarkYellow
                }
                else {
                    Write-Host "'$group' $attr : $Value" -ForegroundColor Green
                }
            }
        }
    }
    catch {
        Write-Error "Failed to retrieve group's attribute (Stopping here to avoid duplicate error messages): $_"
        exit 1
    }
    Write-Host ""
}