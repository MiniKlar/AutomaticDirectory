#Install ActiveDirectory and every dependencies needed for the domain controller role

Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools

#check if the module is installed and available for use
Get-Command -Module ADDSDeployment
