$script = $PSScriptRoot+"\OpenGUIPrompt.ps1"

$DomainAddress = & $script -promptString "Please enter the name of the new domain (ex: mydomain.local)"
$NetbiosName = & $script -promptString "Please enter the NetBIOS name of the new domain (ex: MYDOMAIN)"
    
Install-ADDSDomainForest -DomainName $DomainAddress -NetBIOSName $NetbiosName