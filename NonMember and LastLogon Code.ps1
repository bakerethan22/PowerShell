##Checks group membership of specified OU
$Users = New-Object -TypeName System.Collections.ArrayList
$myuser = Get-ADUser -Identity ebaker -Properties MemberOf
$mygroups = $myuser.MemberOf
foreach ($group in $mygroups) {
    try {
    $curgroup = Get-ADGroup -Identity $group
    $curgroupName = $curgroup.Name
    } catch {
    $group | Out-Null
    }
    $Users.add($curgroupName) | Out-Null
}
$groupsearch = "IT"
if ($myuser.contains($groupsearch)) {
 Write-Host Specified User already belongs to this group -ForegroundColor Green

} else {
    Write-Host Specified User does not belong to this group -ForegroundColor Red
}



#Checks for recently active and enabled users that aren't currently in specified OU group
$Users = New-Object -TypeName System.Collections.ArrayList
$myuser = Get-ADUser "Enabled -eq 'True'" -Properties MemberOf| Where-Object {$_.memberof -notmatch 'STIGGOnlineTraining'} | Where-Object {$_.LastLogonDate -ge (Get-Date).AddDays(-5)}| 
    Where-Object {$_.LastLogonDate -ne $null} | Select-Object Name,LastLogonDate| Sort-Object LastLogonDate | Export-CSV -Path $ExportPath

$mygroups = $myuser.MemberOf
foreach ($group in $mygroups) {
    try {
    $curgroup = Get-ADGroup -Identity $group
    $curgroupName = $curgroup.Name
    } catch {
    $group | Out-Null
    }
    $Users.add($curgroupName) | Out-Null
}
$Users
$groupsearch = "STIGGOnlineTraining"
if ($myuser.contains($groupsearch)) {
 Write-Host True -ForegroundColor Green

} else {
    Write-Host False -ForegroundColor Red
}

#CSV file for lastlogonDate for active users within the last 5 days
$timestamp =  Get-Date -format yyyy-MM-dd
$timestamp = $timestamp.toString()
$ExportPath = "C:\Users\ebaker\Desktop\LastLogonDays_$timestamp.csv"
Get-ADUser -Filter "Enabled -eq 'True'" -Properties LastLogonDate | Where-Object {$_.LastLogonDate -ge (Get-Date).AddDays(-5)}| Where-Object {$_.LastLogonDate -ne $null} | 
    Select-Object Name,LastLogonDate| Sort-Object LastLogonDate | Export-CSV -NoTypeInformation $ExportPath


#CSV file for last 5 days logged in for active users and not part of certain group
$timestamp =  Get-Date -format yyyy-MM-dd
$timestamp = $timestamp.toString()
$groupsearch = "STIGGOnlineUsers"
$ExportPath = "C:\Users\ebaker\Desktop\RecentLog&NoMember_$timestamp.csv"
$myuser = Get-ADUser -Filter "Enabled -eq 'True'" -Properties LastLogonDate,MemberOf | Where-Object {$_.LastLogonDate -ge (Get-Date).AddDays(-5)} | 
    Where-Object {$_.LastLogonDate -ne $null} | Where-Object {$_.memberof -notmatch $groupsearch} | 
        Select-Object Name,LastLogonDate, "Not a Member for STIGGOnlineTraining" | Sort-Object LastLogonDate | Export-CSV -NoTypeInformation $ExportPath

#CSV file for non members of a certain group
$timestamp =  Get-Date -format yyyy-MM-dd
$timestamp = $timestamp.toString()
$ExportPath = "C:\Users\ebaker\Desktop\NotMember_$timestamp.csv"
$myuser = Get-ADUser -Filter "Enabled -eq 'True'" -Properties MemberOf,Name | Where-Object {$_.memberof -notmatch 'XRAY Users'} | 
        Select-Object Name | Sort-Object Name | Export-CSV -NoTypeInformation $ExportPath


$timestamp =  Get-Date -format yyyy-MM-dd
$timestamp = $timestamp.toString()
$ExportPath = "C:\Users\ebaker\Desktop\NotMember_$timestamp.csv"
$objGroup = Get-ADGroup "XRAY Users"
Get-ADUser -Properties memberOf -Filter {Enabled -eq $true} | Where-Object {$objGroup.DistinguishedName -notin $_.memberOf}


$users = (Get-ADUser -Property memberOf).memberof | Where-Object {$_ -like '*GGOnlineTraining*'} | Where-Object {$_.LastLogonDate -ge (Get-Date).AddDays(-5)} | foreach-Object {
    $user.Name

}
$grouplookup = "GGOnlineTraining"


$ADUser = Get-ADUser ebaker | Select-Object SamAccountName
$ExistingGroups = Get-ADPrincipalGroupMembership $ADUser.SamAccountName | Select-Object Name