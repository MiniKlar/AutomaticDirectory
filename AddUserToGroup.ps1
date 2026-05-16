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

Add-ADGroupMember -Identity $GroupName -Members $UserName
Write-Host "$UserName has been added to $GroupName!"