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
    Write-Host "User does not exist."
    exit 1
}

$var = (Get-ADGroupMember -Identity gg | Select-Object -Property name).name

if ([string]::IsNullOrWhiteSpace($var)) {
    Write-Host "User is not in the group."
    exit 1
}

Remove-ADGroupMember -Identity $GroupName -Members $UserName
Write-Host "$UserName has been deleted from $GroupName!"