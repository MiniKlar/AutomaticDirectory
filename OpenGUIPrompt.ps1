<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$promptString
)

Add-Type -AssemblyName Microsoft.visualBasic

$test = [Microsoft.visualBasic.Interaction]::InputBox($promptString, "AutomaticDiscovery")

$test 

#$script = $PSScriptRoot+"\OpenGUIPrompt.ps1" //chemin du script
#& $script -promptString "Please enter your xxx" //lancer script
