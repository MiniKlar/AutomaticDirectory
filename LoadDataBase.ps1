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

# Load database 

$FileOutput = Import-Csv -Delimiter $FileDelimiter -Path $PathToLoad

Write-Host $FileOutput

exit 0