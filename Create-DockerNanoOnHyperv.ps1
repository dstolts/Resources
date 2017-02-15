#Create Nano on Hyper-V
# Leverages Source: https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/deploy-containers-on-nano

Powershell as admin

get-executionpolicy
set-ExecutionPolicy RemoteSigned

# Mount Win2016 Iso
Mount-DiskImage -ImagePath "C:\_Hyper-V\en_windows_server_2016_x64_dvd_9718492.iso"
Mount-DiskImage -ImagePath "C:\_Hyper-V\en_windows_server_2016_x64_dvd_9718492.iso"

# Create folder c:\nano and copy files from nanoserver on DVD
Try {
  md c:\nano -erroraction SilentlyContinue
} 
Catch {}
copy E:\NanoServer\NanoServerImageGenerator\NanoServerImageGenerator.psm1 c:\nano -Force
copy E:\NanoServer\NanoServerImageGenerator\Convert-WindowsImage.ps1 c:\nano -Force
Set-Location C:\nano 
#import Nano Image Module to Powershell
import-module C:\nano\NanoServerImageGenerator.psm1


<#
import-module C:\nano\NanoServerImageGenerator.psm1
-erroractionsilentlycontinue
    New-NanoServerImage 
    [-DeploymentType] {Host | Guest} 
    [-Edition] {Standard | Datacenter} 
    -TargetPath <string> 
    -AdministratorPassword <securestring> 
    [-MediaPath <string>] 
    [-BasePath <string>] 
    [-MaxSize <uint64>] 
    [-Storage] 
    [-Compute] [-Defender] [-Clustering] 
    [-OEMDrivers] 
    [-Containers] [-SetupUI <string[]>] [-Package <string[]>] 
    [-ServicingPackagePath <string[]>] [-ComputerName <string>] [-UnattendPath <string>] [-DomainName <string>] 
    [-DomainBlobPath <string>] [-ReuseDomainNode] [-DriverPath <string[]>] [-InterfaceNameOrIndex <string>] 
    [-Ipv6Address <string>] [-Ipv6Dns <string[]>] [-Ipv4Address <string>] [-Ipv4SubnetMask <string>] [-Ipv4Gateway 
    <string>] [-Ipv4Dns <string[]>] [-DebugMethod {Serial | Net | 1394 | USB}] [-EnableEMS] [-EMSPort <byte>] 
    [-EMSBaudRate <uint32>] [-EnableRemoteManagementPort] [-CopyPath <Object>] [-SetupCompleteCommand <string[]>] 
    [-Development] [-LogPath <string>] [-OfflineScriptPath <string[]>] [-OfflineScriptArgument <hashtable>] 
    [-Internal <string>]  [<CommonParameters>]
#>

mkdir C:\ServicingPackages  -erroraction SilentlyContinue
mkdir C:\ServicingPackages\expanded\KB3176936  -erroraction SilentlyContinue
mkdir C:\ServicingPackages\expanded\KB3192366  -erroraction SilentlyContinue
mkdir C:\ServicingPackages\expanded\KB376936

Write-Host "Required KBs https://technet.microsoft.com/en-us/windows-server-docs/get-started/update-nano-server"

# Need to add some error trapping later
$WebClient = New-Object System.Net.WebClient 

# http://catalog.update.microsoft.com/v7/site/Search.aspx?q=KB3192366
Write-Host "Download from... http://catalog.update.microsoft.com/v7/site/Search.aspx?q=KB3192366"
$url = "http://download.windowsupdate.com/d/msdownload/update/software/crup/2016/09/windows10.0-kb3192366-x64_af96b0015c04f5dcb186b879f07a31c32cf2e494.msu"
$path = "C:\ServicingPackages\windows10.0-kb3192366-x64.msu"
Write-Host "Downloading" $Path -ForegroundColor Green   
$WebClient.DownloadFile( $url, $path )

# http://catalog.update.microsoft.com/v7/site/Search.aspx?q=KB3176936
Write-host "Downloading KB... http://catalog.update.microsoft.com/v7/site/Search.aspx?q=KB3176936"
Write-Host "Windows Server 2016" 
$url = "http://download.windowsupdate.com/c/msdownload/update/software/crup/2016/09/windows10.0-kb3176936-x64_5cff7cd74d68a8c7f07711b800008888b0fa8e81.msu"
$path = "C:\ServicingPackages\windows10.0-kb3176936-x64.msu"
Write-Host "Downloading" $Path -ForegroundColor Green   
$WebClient.DownloadFile( $url, $path )
Write-Host "Windows 10 x86"
$Url = "http://download.windowsupdate.com/d/msdownload/update/software/crup/2016/08/windows10.0-kb3176936-x86_1a65d59f938f00a666e7d2de6cd291a5e1d477ae.msu" 
$Path = "C:\ServicingPackages\windows10.0-kb3176936-x86.msu"
Write-Host "Downloading" $Path -ForegroundColor Green     
$WebClient.DownloadFile( $url, $path ) 
Write-Host "Windows 10 x64"
$Url = "http://download.windowsupdate.com/c/msdownload/update/software/crup/2016/08/windows10.0-kb3176936-x64_795777f8a7f8cd1a4c96ee030848f9f888490555.msu" 
$Path = "C:\ServicingPackages\windows10.0-kb3176936-x64.msu"
Write-Host "Downloading" $Path -ForegroundColor Green 
$WebClient.DownloadFile( $url, $path ) 

Write-Host "Extracting Files..."
Expand C:\ServicingPackages\windows10.0-kb3192366-x64.msu -F:*   C:\ServicingPackages\expanded\KB3192366 
Dir C:\ServicingPackages\expanded\KB3192366
Expand  C:\ServicingPackages\windows10.0-kb3176936-x64.msu -F:*  C:\ServicingPackages\expanded\KB376936 
Dir C:\ServicingPackages\expanded\KB376936

mkdir C:\ServicingPackages\cabs  -erroraction SilentlyContinue
copy C:\ServicingPackages\expanded\KB376936\Windows10.0-KB3176936-x64.cab C:\ServicingPackages\cabs
copy C:\ServicingPackages\expanded\KB3192366\Windows10.0-KB3192366-x64.cab C:\ServicingPackages\cabs
Dir C:\ServicingPackages\cabs




mkdir $WorkFolder -erroraction SilentlyContinue
$WorkFolder = "c:\nano\UPSNano01"
$VHDPath = "$WorkFolder\UPSNano.vhd"
$SRV1 = "NanoUPS01"
New-NanoServerImage -ServicingPackagePath 'C:\ServicingPackages\cabs\Windows10.0-KB3176936-x64.cab', 'C:\ServicingPackages\cabs\Windows10.0-KB3192366-x64.cab' -BasePath ".\Base" -TargetPath $VHDPath -MediaPath "E:\" -ComputerName $SRV1 -Package 'Microsoft-NanoServer-Compute-Package','Microsoft-NanoServer-OEM-Drivers-Package','Microsoft-NanoServer-Guest-Package','Microsoft-NanoServer-Storage-Package' -DeploymentType "Host" -Edition "Datacenter" 
<#this is the same as the above New-NanoServerImage but cut so you can see it all
New-NanoServerImage 
-ServicingPackagePath 'C:\ServicingPackages\cabs\Windows10.0-KB3176936-x64.cab', 'C:\ServicingPackages\cabs\Windows10.0-KB3192366-x64.cab' 
-BasePath ".\Base" -TargetPath $VHDPath -MediaPath "E:\" 
-ComputerName $SRV1 
-Packages 
'Microsoft-NanoServer-Compute-Package',
'Microsoft-NanoServer-OEM-Drivers-Package',
'Microsoft-NanoServer-Guest-Package',
'Microsoft-NanoServer-Storage-Package' 
-DeploymentType "Host" 
-Edition "Datacenter" 

#-Language en_us
#> 

#region Create a new Hyper-V VM with hard drive, memory & network resources configured using the new VHD.
# Variables go here...
# Create Virtual Machines
$MyNewVM = New-VM –Name $Srv1 –MemoryStartupBytes 1GB –VHDPath $VHDpath
Add-VMNetworkAdapter -VMName $SRV1 -SwitchName "Wireless"
#  or get it after the fact with... $MyNewVM = Get-VM -Name $SRV1
$MyNewVMName = $MyNewVM.Name
#$MyNewVM = Get-VM -VMName $MyNewVMName
#$MyNewVMName = $MyNewVM.Name
$MyNewVM.Name
Start-VM $MyNewVM 
#endregion

#region List the IP addresses of all VMs have user select one to use
$VMIpAddresses = Get-VM | ?{$_.VMName -eq $MyNewVM.Name} |?{$_.ReplicationMode -ne “Replica”} | Select -ExpandProperty NetworkAdapters | Select VMName, IPAddresses, Status
$VMIpAddresses
# Grab the IP Address you will use to connect to this NanoServer
Write-Host "From the list above, you can type in a response or copy and paste..." -ForegroundColor Yellow
Write-Host " What IP Address would you like to use to connect to your Nano server? " -ForegroundColor Yellow
$MyVmIp = Read-Host "Nano server IP? " 
$MyVmIp 
#endregion

#region Start the WinRM Service And authorize connection to server
net start WinRM     
Set-Item WSMan:\localhost\Client\TrustedHosts -Value $MyVmIp  # servername or IP
$MyVmIP
#endregion

#region Connect to Nano
Enter-PSSession -VMName $MyNewVMName -Credential "$MyNewVMName\Administrator"
hostname
#endregion

#region Install Windows Updates
$sess = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
Invoke-CimMethod -InputObject $sess -MethodName ApplyApplicableUpdates
Restart-Computer
Exit-pssession
sleep(10)
#endregion

#region Connect to Nano
Enter-PSSession -VMName $MyNewVMName -Credential "$MyNewVMName\Administrator"
hostname
#endregion

#region Install Docker Provider
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Get-PackageSource
Install-Package -Name DockerMsftProvider 
Restart-Computer -Force
sleep(10)
#endregion

#region Install Docker on Nano  You could also do this with container service
Invoke-WebRequest https://get.docker.com/builds/Windows/x86_64/docker-1.13.0.zip -UseBasicParsing -OutFile docker.zip
Expand-Archive docker.zip -DestinationPath $Env:ProgramFiles
Remove-Item -Force docker.zip
cd $Env:ProgramFiles\docker
$DockerPath = Get-Location
dir
Get-Service -Name docker
.\dockerd.exe --register-service
Start-Service docker
Get-Service -Name docker
#endregion

#region Set Path to include Docker
# For quick use, does not require shell to be restarted.
$env:path += ";$DockerPath"
# For persistent use, will apply even after a reboot. 
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $env:path
docker info
#endregion

#region Connect to Nano
#Connect to Nano
Enter-PSSession -VMName $MyNewVMName -Credential "$MyNewVMName\Administrator"
hostname

#endregion

#region Confirm Docker is running
#Now we can access the remote docker machine even after a reboot
docker info
#endregion

#region Install (pull) Base Container Images
# Nano
docker pull microsoft/nanoserver
# Server Core
# docker pull microsoft/windowsservercore  
docker images
"we can start a -dt background container but NOT -it Interactive"
docker run -dt microsoft/nanoserver
docker ps
#endregion

#region List Local Machine IP Addresses
# 
"List Local Machine IP Addresses"
$AdminIpAddresses = get-NetIpAddress -AddressFamily IPv4 | format-table interfacealias, IPAddress, AddressState 
$AdminIpAddresses
# Grab the IP Address you will use to connect to NanoServer
Write-Host "From the list above, you can type in a response or copy and paste..." -ForegroundColor Yellow
Write-Host " What IP Address would you like to use to connect to your Nano server? " -ForegroundColor Yellow
$AdminIp = Read-Host "Current Machine IP? " 
"Selected: $AdminIp"
#> #List Local Machine IP Addresses
#endregion 

#region Prepare Host for container connectivity (Firewall And Config)
#Create a firewall rule on the container host for the Docker connection. This will be port 2375 for an unsecure connection
netsh advfirewall firewall add rule name="Docker daemon " dir=in action=allow protocol=TCP localport=2375                 # Allow Docker
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow  # Allow Ping
"You need to make sure that you have both machines on the same network for connectivity;)"
Write-Host "See https://docs.docker.com/engine/security/https/ for securing connection" -foregroundcolor Red
new-item -Type File c:\ProgramData\docker\config\daemon.json
Add-Content 'c:\programdata\docker\config\daemon.json' '{ "hosts": ["tcp://0.0.0.0:2375", "npipe://"] }'
type "c:\ProgramData\docker\config\daemon.json"
Restart-Service docker
Sleep(10)
#endregion

#region show Docker containers and IP addresses
docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $( docker ps -aq) 
#endregion

#region Start Container and Show the new container Name and IP
$CID = (docker run  -dt --restart=always microsoft/nanoserver)  # Run docker with --restart
# You could also expose a port when you run with ... docker run -p 80:80 mycontainer
$ContainerIP = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CID
$ContainerIP  # Display the IP address of the container
$ContainerName = docker inspect -f '{{.Name}}' $CID
$ContainerName # Display the name of the container
Restart-Service docker   # Restart docker which will stop all containers

docker ps -a          # microsoft/nanoserver will always start when docker starts
"Notice that the container automatically started with restart of docker service"
docker container ls
#docker stop af910f8d8741   # Stop a container
#docker rm af910f8d8741     # Delete a container
#endregion

#region Exit Nano
"exiting out of nano"
Exit-pssession
hostname   # you should now be back on your administrative workstation
#endregion

#region Prepare admin workstation 
<#
#Prepare for docker remote connection on the machine you will be connecting from (full GUI, not Nano)
# From your Laptop or server you will be using to connect to nano...
#Download Docker Engine
Invoke-WebRequest "https://download.docker.com/components/engine/windows-server/cs-1.12/docker.zip" -OutFile "$env:TEMP\docker.zip" -UseBasicParsing
Expand-Archive -Path "$env:TEMP\docker.zip" -DestinationPath $env:ProgramFiles
Remove-Item "$env:TEMP\docker.zip"

#region Set Path to include Docker
# For quick use, does not require shell to be restarted.
$env:path += ";$DockerPath"
# For persistent use, will apply even after a reboot. 
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH –Value $env:path
docker info
#endregion
#> 
#endregion

#region Remote Connect to Nano Host Docker
"Connecting to Nano Host Docker"
$DockerPort = ":2375"
$NanoHost = "tcp://$MyVmIP$DockerPort" 
#$NanoHost = "tcp://192.168.250.58:2375"
[Environment]::SetEnvironmentVariable("DOCKER_HOST",$null,"User")
[Environment]::SetEnvironmentVariable("DOCKER_HOST",$NanoHost,"User")
"DOCKER_HOST: "
[Environment]::GetEnvironmentVariable("DOCKER_HOST","User")
"List Images on Nano"
docker images
"List Containers on Nano"
docker ps -a
#endregion 
#region Ping Host from Nano
Ping $AdminIP
#endregion

#region Connect to Local Machine Docker
"Connected to Local Admin Host Docker"
[Environment]::SetEnvironmentVariable("DOCKER_HOST","localhost:2375","User")
[Environment]::GetEnvironmentVariable("DOCKER_HOST","User")
"List Images on Admin"
docker images
"List Containers on Admin"
docker ps -a
#endregion

#region List Environment Variables.
  #"List Environment Variables"
  #Get-ChildItem Env:
#endregion

<#
"Pull images down locally"
docker pull microsoft/windowsservercore
docker pull microsoft/windowsservercore 
docker images -a
#> #Pull images down locally





# working with nano...

<# Could not get NanoServerPackage working...

OLD WAY OF DOING THINGS???

#https://github.com/OneGet/NanoServerPackage
Install-PackageProvider NanoServerPackage
Import-PackageProvider NanoServerPackage
Save-Module -Path "$env:programfiles\WindowsPowerShell\Modules\" -Name NanoServerPackage -minimumVersion 1.0.1.0
Import-PackageProvider NanoServerPackage

#Note: If you install an optional Nano Server package from media or online repository, it won't have recent security fixes included. So you should install the latest cumulative update after installing any optional packages.
Exit-pssession

# Apply the servicing stack update first and then restart
$s = New-PSSession -ComputerName $MyVmIp -Credential "$MyNewVMName\Administrator"
Copy-Item -ToSession $s -Path C:\ServicingPackages_cabs -Destination C:\ServicingPackages_cabs -Recurse
Enter-PSSession $s

 Add-WindowsPackage -Online -PackagePath C:\ServicingPackages_cabs\Windows10.0-KB3176936-x64.cab
 Restart-Computer




#Install Package Management 
#  https://blogs.msdn.microsoft.com/powershell/2016/09/29/powershellget-and-packagemanagement-in-powershell-gallery-and-github/

##Before updating PowerShellGet or PackageManagement, you should always install the latest Nuget provider . To do that, run the following in an elevated PowerShell prompt:
# These steps are for non-nano OS
   # Powershell version 5 or greater
#     Install-Module –Name PowerShellGet –Force –Verbose
#   # Powershell Version Less than 5: 


#For Nano Server, and systems running PowerShell 3 or PowerShell 4, that have installed the PackageManagement MSI, open a new PS Console and use the below PowerShellGet cmdlet to save the modules to a local directory:
md c:\scripts 
Save-Module PowerShellGet -Path C:\Scripts
dir c:\scripts
dir C:\scripts\PackageManagement
dir C:\scripts\PowerShellGet

#Restart the session
shutdown /r /f /t 0
Exit-PSSession
Enter-PSSession -VMName $MyNewVMName -Credential "$MyNewVMName\Administrator"

#After Re-Opening the PS Console run the following commands:
Copy-Item “C:\Scripts\PowerShellGet\*” “$env:ProgramFiles\WindowsPowerShell\Modules\PowerShellGet\” -Recurse -Force
Copy-Item “C:\Scripts\PackageManagement\*” “$env:ProgramFiles\WindowsPowerShell\Modules\PackageManagement\” -Recurse -Force
# Important note: This version of PowerShellGet includes new security enhancements that validate a module author using catalog signing. Once you install this version, the first time you install either PSReadline or Pester from the Gallery you may receive an error that starts with: “The version ‘(some version)’ of the module ‘(ModuleName)’ being installed is not catalog signed. …” This is a one-time impact for these two modules. You can bypass this error for these modules by specifying –SkipPublisherCheck.  That is not a general best practice, we will be providing additional details in the coming days.


# Configure our machine to work with PowerShell Packets
# Install Package Provider
Find-Package Nuget -Verbose
Find-Packageprovider Nuget -force -verbose

Install-PackageProvider Nuget –force –verbose
Install-Module –Name PowerShellGet –Force –Verbose
# Display the PackageManagement package
find-module packagemanagement
Install-Module -Name PackageManagement -Repository PSGallery -Force
Import-Module PackageManagement
Get-Command -Module PackageManagement

find-package -provider nuget -source http://nuget.org/api/v2 zlib 

# We need OneGet (https://github.com/oneget/oneget) provider PowerShell module to install docker 
Get-PSRepository
Find-Module DockerMsftProvider 
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force 
Import-Module DockerMsftProvider


#Critical Updates are required before installing containers
$sess = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
Invoke-CimMethod -InputObject $sess -MethodName ApplyApplicableUpdates
Restart-Computer
#Reconnect to Nano
Enter-PSSession -VMName $MyNewVMName -Credential "$MyNewVMName\Administrator"
hostname



#docker install 


Import-Module DockerMsftProvider
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

Install-PackageProvider NanoServerPackage  # Install Nano PowerShell commands
Import-PackageProvider NanoServerPackage   # Import/Activate Nano PowerShell Commands

# Display all available packages

Find-Package –AllVersions -Name "*Nano*" 
Find-Package –AllVersions -Name "Microsoft.Powershell.Nano*" 
Find-Package –AllVersions -Name "NanoServerPackage" 

Find-

#inspect package
Save-Script -Name "NanoServerPackage" -Path "C:\Users\Administrator\Documents" -RequiredVersion 1.0.1

# Requires Nano...
Install-NanoServerPackage -Name Microsoft-NanoServer-Containers-Package
# Generic Version 
#Install-Package -Name Microsoft-NanoServer-Containers-Package

Exit-PSSession

#>
