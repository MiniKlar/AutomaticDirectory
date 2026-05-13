<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$PathToLoad,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[char]$FileDelimiter
)

$FileOutput = Import-Csv -Delimiter $FileDelimiter -Path $PathToLoad

Write-Host $FileOutput