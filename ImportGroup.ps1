<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$OriginGroupName,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$DestinationGroupName
)

$Users = Get-ADGroupMember -Identity $OriginGroupName

foreach ($User in $Users) {
    Add-ADGroupMember -Identity $DestinationGroupName -Members $User
}

Write-Host "All members from the origin group have been copied to the destination group"