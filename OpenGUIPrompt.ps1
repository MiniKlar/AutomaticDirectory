<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$promptString
)

Add-Type -AssemblyName Microsoft.visualBasic

$test = [Microsoft.visualBasic.Interaction]::InputBox($promptString, "AutomaticDiscovery")

return $test