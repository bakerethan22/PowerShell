##Adds users to STIGGOnline
$Group = "STIGGOnlineTraining"
$userArray = New-Object -TypeName System.Collections.ArrayList
$timestamp = (Get-Date).AddDays(-5)
$userlist = Get-ADUser -Property LastLogonDate, MemberOf -Filter {lastLogonDate -ge $timestamp -and Name -like 'da*'}
foreach ($User in $Userlist) {
    $MemberOf = $User.memberof | Where-Object {$_ -like '*GGOnlineTraining*'}
    if ($null -eq $MemberOf) {
    $User.Name
    $userArray.Add($User) | Out-Null
    }
}
foreach ($User in $userArray) {
    $UPN = $User.Name
    Add-ADGroupMember -Identity $Group -Members $User.SamAccountName -WhatIf
    Write-Host "Added $UPN to $Group" -ForeGroundColor Green
} #-WhatIf does a unit test on the output


##Remove users from STIGGOnline
$Group = "STIGGOnlineTraining"
$userArray = New-Object -TypeName System.Collections.ArrayList
$timestamp = (Get-Date).AddDays(-5)
$userlist = Get-ADUser -Property LastLogonDate, MemberOf -Filter {lastLogonDate -ge $timestamp -and Name -like 'da*'}
foreach ($User in $Userlist) {
    $MemberOf = $User.memberof | Where-Object {$_ -like '*GGOnlineTraining*'}
    if ($null -eq $MemberOf) {
    $User.Name
    $userArray.Add($User) | Out-Null
    }
}
foreach ($User in $userArray) {
    $UPN = $User.Name
    Add-ADGroupMember -Identity $Group -Members $User.SamAccountName -WhatIf
    Write-Host "Added $UPN to $Group" -ForeGroundColor Green
} #-WhatIf does a unit test on the output