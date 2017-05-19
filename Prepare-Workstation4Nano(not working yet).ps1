
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
