Import-Module Appx
Import-Module Dism

# Sets Execution Policy to run machine-wide (comment out if unneeded)
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force

$AppList = @(
    "Microsoft.BingNews",
    "Microsoft.Getstarted",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MixedReality.Portal",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.SkypeApp",
    "Microsoft.Todos",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.WindowsTips",
    "Microsoft.WindowsCamera",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameCallableUI",
    "SpotifyAB.SpotifyMusic",
    "Disney.37853FC22B2CE",
    "TikTok.TikTok"
)

ForEach ($App in $AppList) {
    $AppFullName = (Get-AppxPackage -AllUsers | Where-Object {$_.Name -eq $App}).PackageFullName
    $ProAppFullName = (Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $App}).PackageName
    
    if ($AppFullName) {
        Write-Host "Removing package: $App"
        Remove-AppxPackage -Package $AppFullName -AllUsers
    } else {
        Write-Host "Unable to find package: $App"
    }
    
    if ($ProAppFullName) {
        Write-Host "Removing provisioned package: $ProAppFullName"
        Remove-AppxProvisionedPackage -Online -PackageName $ProAppFullName
    } else {
        Write-Host "Unable to find provisioned package: $App"
    }
}

# Restore Execution Policy (comment out if unneeded)
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted -Force

# If you have an issue with Adobe, use this (uncomment below if needed)
# Remove-AppxPackage -AllUsers -Package AdobeNotificationClient_6.0.0.1_x86__enpm4xejd91yc