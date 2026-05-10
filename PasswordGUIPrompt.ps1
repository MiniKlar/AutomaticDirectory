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

$FirstPasswordObject = New-Object System.Windows.Controls.PasswordBox
$FirstPasswordObject.PasswordChar = "*"

$SecondPasswordObject = New-Object System.Windows.Controls.PasswordBox
$SecondPasswordObject.PasswordChar = "*"

$Button = New-Object System.Windows.Controls.Button
$Button.Content = "OK"
$Button.ClickMode = "Release"
$Button.Background = "LightBlue"
$Button.Add_Click({
    if ($FirstPasswordObject.Password -eq "" -or $SecondPasswordObject.Password -eq "") {
        Write-Host "Password empty"
    }
    elseif ($FirstPasswordObject.Password -eq $SecondPasswordObject.Password) {
        $PresentationObject.Close()
    }
    else {
        Write-Host "Password not matching"
    }
})

$StackPanel.Children.Add($LabelObject)
$StackPanel.Children.Add($FirstPasswordObject)
$StackPanel.Children.Add($SecondPasswordObject)
$StackPanel.Children.Add($Button)

$PresentationObject.AddChild($StackPanel)
$PresentationObject.ShowDialog()
