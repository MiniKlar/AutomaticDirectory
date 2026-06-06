<#.Name#>

# Create a window that prompt the user to enter a password

if ($args.Count -gt 0) {
    Write-Host "Usage: ./PasswordGUIPrompt.ps1"
    exit 1
}

Add-Type -AssemblyName PresentationFramework

$PresentationObject = New-Object System.Windows.Window
$PresentationObject.Title = "AutomaticDirectory"
$PresentationObject.Height = 150
$PresentationObject.Width = 500
$PresentationObject.WindowStartupLocation = "CenterScreen"

$StackPanel = New-Object System.Windows.Controls.StackPanel
$StackPanel.Background = "#ffffff"

$LabelObject = New-Object System.Windows.Controls.Label
$LabelObject.Content = "Please enter your password here"

$ErrorPanel = New-Object System.Windows.Controls.Label
$ErrorPanel.Foreground = "#ff0000"
$ErrorPanel.VerticalAlignment = "center"
$ErrorPanel.HorizontalAlignment ="center"

$FirstPasswordObject = New-Object System.Windows.Controls.PasswordBox
$FirstPasswordObject.PasswordChar = "*"

$SecondPasswordObject = New-Object System.Windows.Controls.PasswordBox
$SecondPasswordObject.PasswordChar = "*"

$Key = New-Object System.Windows.Input.Key

$Button = New-Object System.Windows.Controls.Button
$Button.Content = "OK"
$Button.ClickMode = "Release"
$Button.Background = "LightBlue"
$Button.Add_Click({
    if ($FirstPasswordObject.Password -eq "" -or $SecondPasswordObject.Password -eq "") {
        $ErrorPanel.Content = "Password empty"
    }
    elseif ($FirstPasswordObject.Password -eq $SecondPasswordObject.Password) {
        $PresentationObject.Close()
    }
    else {
        $ErrorPanel.Content = "Password not matching"
    }
})

$StackPanel.Children.Add($LabelObject) | Out-Null
$StackPanel.Children.Add($FirstPasswordObject) | Out-Null
$StackPanel.Children.Add($SecondPasswordObject) | Out-Null
$StackPanel.Children.Add($Button) | Out-Null
$StackPanel.Children.Add($ErrorPanel) | Out-Null

$PresentationObject.AddChild($StackPanel)
$PresentationObject.ShowDialog() | Out-Null
return $FirstPasswordObject.SecurePassword