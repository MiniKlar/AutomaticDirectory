<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$PathToSave,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
<<<<<<< Updated upstream
[char]$DesiredDelimiter
)
#Auto error handeling if a char is not passed as a parameter

Get-ADUser -Filter * | Export-Csv -Path $PathToSave -Delimiter $DesiredDelimiter

"#TYPE Microsoft.ActiveDirectory.Management.ADGroup" | Add-Content -Path $PathToSave

Get-ADGroup -Filter * | Export-Csv -Path $PathToSave -Delimiter $DesiredDelimiter -Append -Force
=======
[char]$DesiredDelimiter,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[String[]]$UserProperties,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[String[]]$GroupProperties
)

#Auto error handeling if a char is not passed as a parameter

$Users = Get-ADUser -Filter * -Properties $UserProperties | Select-Object $UserProperties | Export-Csv -NoTypeInformation -Path $PathToSave -Delimiter $DesiredDelimiter

#"#TYPE Microsoft.ActiveDirectory.Management.ADGroup" | Add-Content -Path $PathToSave

$Groups = Get-ADGroup -Filter * -Properties $GroupProperties | Select-Object $GroupProperties | Export-Csv -NoTypeInformation -Path $PathToSave -Delimiter $DesiredDelimiter -Append -Force
>>>>>>> Stashed changes
