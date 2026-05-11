$script = $PSScriptRoot+"\OpenGUIPrompt.ps1"

$DomainAddress = & $script -promptString "Please enter the name of the new domain (ex: mydomain.local)"
#$NetbiosName = & $script -promptString "Please enter the NetBIOS name of the new domain (ex: MYDOMAIN)"

$password = ConvertTo-SecureString $PSScriptRoot+"\PasswordGUIPrompt.ps1" -AsPlainText -Force
    
Install-ADDSForest -DomainName $DomainAddress -SafeModeAdministratorPassword $password -Force