<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$PathToSave,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[char]$DesiredDelimiter,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[String[]]$Properties
)

#Auto error handeling if a char is not passed as a parameter

$Properties = $Properties -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" } | Select-Object -Unique

$AllPropertiesUser = (Get-ADUser -Filter * -Properties * | Get-Member -MemberType Properties).Name
$AllPropertiesGroup = (Get-ADGroup -Filter * -Properties * | Get-Member -MemberType Properties).Name

$UserProperties = $Properties | Where-Object { $_ -in $AllPropertiesUser }
$GroupProperties = $Properties | Where-Object { $_ -in $AllPropertiesGroup }

$Users = Get-ADUser -Filter * -Properties $UserProperties | Select-Object $Properties #Export-Csv -NoTypeInformation -Path $PathToSave -Delimiter $DesiredDelimiter

$Groups = Get-ADGroup -Filter * -Properties $GroupProperties | Select-Object $GroupProperties #Export-Csv -NoTypeInformation -Path $PathToSave -Delimiter $DesiredDelimiter -Append

$all = $Users + $Groups

$all | Export-Csv -NoTypeInformation -Path $PathToSave -Delimiter $DesiredDelimiter

exit 0