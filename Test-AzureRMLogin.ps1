<#   
========= Test-AzureRMLogin.ps1 ======================================= 
 Name: Test-AzureRMLogin 
 Purpose: Check to see if the current PowerShell session is logged into Azure. if it is not, login via a popup
            Feature Request, Supply parameters for username and password to authenticate
     
 Author: Dan Stolts - dstolts&microsoft.com - http://ITProGuru.com
         Script Home: http://ITProGuru.com/Scripts 
 
 Syntax/Execution: 
      Copy portion of script you want to use and paste into PowerShell (or ISE)  
      ./Test-AzureRMLogin.ps1  
     Coming soon...     ./Test-AzureRMLogin.ps1  -UserName "MyAzureAdmin" -Password "MyAzurePassw0rd!" -SubscriptionID "12345..."
       
 Disclaimer: Use at your own Risk!  See details at http://ITProGuru.com/privacy  
 
 Limitations:  
        * Must Run PowerShell (or ISE)  
        * UAC may get in the way depending on your settings (See: http://ITProGuru.com/PS-UAC) 

See Also

 ================================================================================ 
#> 
#Test-AzureRmLogin
# Check Azure Login
Try
{   # Probably want to change this to certificate auth
    Write-Host "Checking Azure Login"
    $TestSubscription = Get-AzureRmSubscription
    #Get-WMIObject Win32_Service -ComputerName localhost -Credential (Get-Credential) -ErrorAction "Stop"
}
Catch [Exception]
{  Write-Host "Need to Login" -ForeGroundColor Yellow
   # Sign-in with Azure account credentials
   $AzureLogin = Login-AzureRmAccount -ErrorAction Stop
}
Catch
{   exit 
}
Write-Host "Logged into Azure $TestSubscription" -ForegroundColor Green
$AzureLogin
