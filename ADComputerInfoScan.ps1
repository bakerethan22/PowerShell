##Creates a list of all the of the domain's computers

$timestamp =  Get-Date -format yyyy-MM-dd
$timestamp = $timestamp.toString()
$ExportPath = 'C:/users/ebaker/Desktop'
$complist = Get-ADComputer -Filter "Enabled -eq 'True'" -Properties *
$complist | ForEach-Object {

    $computer= $_

    Get-ADPrincipalGroupMembership -Identity $_| Select-Object @{
        Name = 'Name'; Expression = {
            $computer.Name
        }
    }, @{
        Name = 'SAMAccount'; Expression = {
            $computer.SamAccountName
        }
    }, @{
        Name = 'Description'; Expression = {
            $computer.Description
        }
    }, @{
        Name = 'IP Address'; Expression = {
            $computer.IPv4Address
        }
    }, @{
        Name = 'Last Logon'; Expression = {
            $computer.LastLogonDate
        }
    }, @{
        Name = 'Group'; Expression = {
            $_.SamAccountName
        }
    }, @{
        Name = 'OS'; Expression = {
            $computer.Operatingsystem
        }
    }, @{
        Name = 'OS Version'; Expression = {
            $computer.OperatingsystemVersion
        }
    }, @{
        Name = 'When Created'; Expression = {
            $computer.whenCreated
        }
    }
} | Sort-Object Name | Export-Csv -Path $ExportPath -NoTypeInformation