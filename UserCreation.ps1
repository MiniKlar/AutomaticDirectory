<# .Name #>

[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$AccountName,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$OU,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Group
)

# Ensure the ActiveDirectory module is available
try {
    Import-Module ActiveDirectory -ErrorAction Stop
} catch {
    Write-Error "Active Directory module not found. Please install RSAT or run on a domain controller."
    exit 1
}

# Ensure the specified Organizational Unit exists
try {
    Get-ADOrganizationalUnit -Identity $OU -ErrorAction Stop | Out-Null
}
catch {
    Write-Error "The specified OU does not exist: $OU"
    exit 1
}

# Ensure the specified Group exists
try {
    Get-ADGroup -Identity $GroupName | Out-Null
} catch {
    Write-Host "Group does not exist."
    exit 1
}

$script = $PSScriptRoot+"\OpenGUIPrompt.ps1"
$scriptPassword = $PSScriptRoot+"\PasswordGUIPrompt.ps1"

# Prompt for user details
$FirstName = & $script -promptString "Please enter your first name"
$LastName  = & $script -promptString "Please enter your last name"
$Password  = & $scriptPassword

# Validate required fields
if ([string]::IsNullOrWhiteSpace($FirstName) -or
    [string]::IsNullOrWhiteSpace($LastName)) {
    Write-Error "All name fields are required."
    exit 1
}

# Get the DNS
$domain = (Get-ADDomain).DNSRoot

# Create mail
$mail = "$($FirstName.ToLower()).$($LastName.ToLower())@$domain"

# Create the AD user
try {
    New-ADUser `
        -GivenName $FirstName `
        -Surname $LastName `
        -Name "$FirstName $LastName" `
        -SamAccountName $AccountName `
        -UserPrincipalName $mail `
        -EmailAddress $mail `
        -Path $OU `
        -AccountPassword $Password `
        -Enabled $true `
        -ChangePasswordAtLogon $true `
        -PassThru | Out-Host

    Write-Host "User '$AccountName' created successfully in $OU" -ForegroundColor Green
} catch {
    Write-Error "Failed to create user: $_"
}


$addGroup = $PSScriptRoot+"\AddUserToGroup.ps1"
& $addGroup -UserName  $AccountName -GroupName $Group