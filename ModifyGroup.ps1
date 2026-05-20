<#.Name#>

[CmdletBinding(PositionalBinding=$false)]

Param(
[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$GroupName,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$AttributeName,

[Parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]
[string]$AttributeValue
)

Set-ADGroup -Identity $GroupName -Replace @{$AttributeName = $AttributeValue}

if ($?) {
    Write-Host "The attribute $AttributeName has correctly been set to '$AttributeValue'."
}

exit 0