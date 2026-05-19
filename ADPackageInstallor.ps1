<#.Name#>

# Install ActiveDirectory and the needed dependencies for the domain controller role
try {
    $var = Get-WindowsFeature -Name AD-Domain-Services | Select-Object -Property InstallState
    if ($var.InstallState -eq "Installed") {
        throw
    }
} catch {
    Write-Host "AD-Domain-Services is already installed."
    exit 1
}

Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools

# Check if the module is installed and available for use
Get-Command -Module ADDSDeployment

exit 0