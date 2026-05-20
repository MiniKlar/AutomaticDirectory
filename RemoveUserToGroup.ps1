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

try {
    Get-ADUser -Identity $UserName | Out-Null
} catch {
    Write-Host "User $UserName does not exist."
    exit 1
}

$var = (Get-ADGroupMember -Identity $GroupName | Select-Object -Property SamAccountName | Where-Object -Property SamAccountName -Match -Value $UserName).SamAccountName

if ([string]::IsNullOrWhiteSpace($var)) {
    Write-Host "$UserName is not in $GroupName group."
    exit 1
}

Remove-ADGroupMember -Identity $GroupName -Members $UserName
Write-Host "$UserName has been deleted from $GroupName!"

exit 0