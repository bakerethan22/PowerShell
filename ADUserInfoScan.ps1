##Creates a list of all enabled users in the active directory

$timestamp =  Get-Date -format yyyy-MM-dd
$timestamp = $timestamp.toString()
$ExportPath = 'C:\Users\ebaker\Desktop'
 $Users = New-Object -TypeName System.Collections.ArrayList
 $userlist = Get-ADUser -Filter "Enabled -eq 'True'" -Properties *
 foreach ($user in $userlist) {
     if( $user.Manager -ne $null ) {
			    $Manager = Get-ADUser -Identity $user.Manager -Server ($user.Manager.Substring(($user.Manager | Select-String "DC=").Matches.Index + 3, 3) + ".Doncasters.com")
		        }
     $mygroups = $user.MemberOf
     try {
           
         foreach ($group in $mygroups) {
            try {
                $curgroup = Get-ADGroup -Identity $group
                $curgroupName = $curgroup.Name
            } catch {
                $curgroupName = $group
            }
             $UserObject = [pscustomobject]@{
                 UserID       = $user.SamAccountName
                 upn          = $user.UserPrincipalName
                 name         = $user.Name
                 first_name   = $user.GivenName
                 last_name    = $user.Surname
                 email        = $user.EmailAddress
                 title        = $user.Title
                 department   = $user.Department
                 address      = $user.StreetAddress
                 city         = $user.City
                 state        = $user.State
                 zip          = $user.PostalCode
                 country      = $user.Country
                 company      = $user.Company
                 memberof     = $curgroupName
                 manager      = if($user.Manager -eq $null){""}else{$Manager.name}
                 mgr_email    = if($user.Manager -eq $null){""}else{$Manager.UserPrincipalName}
                 lastlogon    = $user.LastLogonDate
                 pwexpire     = $user.PasswordExpired
                 pwlastset    = $user.PasswordLastSet
                 pwnotrequired= $user.PasswordNotRequired
                 pwneverexpire= $user.PasswordNeverExpires
                 lastbadpw    = $user.LastBadPasswordAttempt
             }
             $Users.add($UserObject) | Out-Null
         }
     }
     catch {
         $group
     }
 }
 $Users | Sort-Object Name | Export-CSV $ExportPath -NoTypeInformation