# Get the Interface that is on the 192.168.2 network
#NOTE: Future enancements... Use -csession to do multiple servers :)
#Note: Future... pass IP range as paramter

$ipAddressFilter = "192.168.2.*"  # Change this filter to the ip filter you would like to change.

$IPConfig=Get-NetIPConfiguration
$Interface=$ipConfig.IPv4Address | Where-Object { $_.IPAddress -like $ipAddressFilter}
$Interface | Format-Table IPAddress, InterfaceIndex, InterfaceAlias
$ip=$Interface.IPAddress
$id = $Interface.InterfaceIndex
$name = $Interface.InterfaceAlias

Write-host "Would you like to set {$name $ip Interface:$id} to a PRIVATE network (Default is Yes)" -ForegroundColor Yellow 
    $Readhost = Read-Host " ( y / n ) " 
    Switch ($ReadHost) 
     { 
       Y {Write-host "Yes, Add Static Route "; $Continue=$true} 
       N {Write-Host "No, cancel"; $Continue=$false} 
       Default {Write-Host "Default, STOP"; $Continue=$false} 
     } 

if ($Continue) 
    {
    Write-host "Setting Network to Private for {$name $ip Interface:$id}" -ForegroundColor Green
    Set-NetConnectionProfile  -InterfaceIndex $id -NetworkCategory Private
    Get-NetConnectionProfile -InterfaceIndex $id 
    Get-NetConnectionProfile | Format-Table InterfaceAlias, interfaceIndex, NetworkCategory
    Write-Host "Completed! " -ForegroundColor Green

    }
    else {
     Get-NetConnectionProfile | Format-Table InterfaceAlias, interfaceIndex, NetworkCategory 
     write-host "Cancelled"  -ForegroundColor Yellow
     }