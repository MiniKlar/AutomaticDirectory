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

# Check if the user exists

try {
    Get-ADUser -Identity $UserName | Out-Null
} catch {
    Write-Host "User $UserName does not exist."
    exit 1
}

# Check if the user is currently in the group before deleting

$var = (Get-ADGroupMember -Identity $GroupName | Select-Object -Property SamAccountName | Where-Object -Property SamAccountName -Match -Value $UserName).SamAccountName

if ([string]::IsNullOrWhiteSpace($var)) {
    Write-Host "$UserName is not in $GroupName group."
    exit 1
}

# Remove the user from the group

Remove-ADGroupMember -Identity $GroupName -Members $UserName
Write-Host "$UserName has been deleted from $GroupName!"

exit 0