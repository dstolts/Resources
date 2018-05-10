# Get the Interface that is on the 192.168.2 network
#NOTE: Future enancements... Use -csession to do multiple servers :)

# change the below two variables before executing...
$ipAddressFilter = "192.168.2.*"     # this is the IP address mask to use in config lookup
$ipAddressPrefix = "192.168.2.0/24"  # this is the IP address DestinationPrefix to  set

#Let's get started...
$IPConfig=Get-NetIPConfiguration
$Interface=$ipConfig.IPv4Address | Where-Object { $_.IPAddress -like $ipAddressFilter }
$Interface | Format-Table IPAddress, InterfaceIndex, InterfaceAlias
$ip=$Interface.IPAddress
$id = $Interface.InterfaceIndex
$name = $Interface.InterfaceAlias

Write-host "Would you like to add static routes to {$name $ip Interface:$id} (Default is Yes)" -ForegroundColor Yellow 
    $Readhost = Read-Host " ( y / n ) " 
    Switch ($ReadHost) 
     { 
       Y {Write-host "Yes, Add Static Route "; $Continue=$true} 
       N {Write-Host "No, cancel"; $Continue=$false} 
       Default {Write-Host "Default, Continue"; $Continue=$true} 
     } 

if ($Continue) 
    {
    Write-host "Updating Local routing Table for {$name $ip Interface:$id}" -ForegroundColor Green
    Write-host "Current FULL Routing Table is: "
        Get-NetRoute 
    Write-host "Current Routing Table for {$name $ip Interface:$id} is: " -ForegroundColor Green
        $SaveRT = Get-NetRoute | Where-Object { $_.ifIndex -eq $id}
        $SaveRT
    # get-help Set-NetRoute -examples
    Set-NetRoute -InterfaceIndex $id –DestinationPrefix $ipAddressPrefix
    Get-NetRoute | Where-Object { $_.ifIndex -eq $id}

    }

