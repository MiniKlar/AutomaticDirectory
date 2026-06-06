<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$UserName,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$GroupName
)

# Check if the user exists.
try {
    Get-ADUser -Identity $UserName | Out-Null
} catch {
    Write-Host "User does not exist."
    exit 1
}

# Check if the group exists.
try {
    Get-ADGroup -Identity $GroupName | Out-Null
} catch {
    Write-Host "Group does not exist."
    exit 1
}

# Check if the user is already in the group
try {
    $var = Get-ADGroupMember -Identity $GroupName | Select-Object -Property "SamAccountName"
    if ($var.SamAccountName -eq "$UserName") {
       throw
    }
} catch {
    Write-Host "User $UserName is already in $GroupName group"
    exit 1
}

# Add the user in the group
Add-ADGroupMember -Identity $GroupName -Members $UserName
Write-Host "$UserName has been added to $GroupName!"
exit 0