<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$promptString
)

# Creation of a window that will input the user what you need (you can ask what you need via the argument of the program)

Add-Type -AssemblyName Microsoft.visualBasic

$test = [Microsoft.visualBasic.Interaction]::InputBox($promptString, "AutomaticDiscovery")

return $test