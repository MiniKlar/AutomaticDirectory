<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$SourceGroup,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$DestinationGroup
)

# Check if the source group exists

try {
    Get-ADGroup -Identity $SourceGroup | Out-Null
} catch {
   Write-Host "The source group does not exist."
   exit 1
}

# Check if the destination group exists

try {
    Get-ADGroup -Identity $DestinationGroup | Out-Null
} catch {
   Write-Host "The destination group does not exist."
   exit 1
}

# Copy all the users from the source group to the destination group

$Users = Get-ADGroupMember -Identity $SourceGroup

foreach ($User in $Users) {
    Add-ADGroupMember -Identity $DestinationGroup -Members $User
}

Write-Host "All the members from the source group have been copied to the destination group."

exit 0