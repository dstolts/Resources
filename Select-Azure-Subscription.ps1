<#   
========= Open-AzureRmSubscription.ps1 ======================================= 
 Name: Open-AzureRmSubscription 
 Purpose: Select Azure Subscription - if multiple, pops a box to allow user to select 
    Also shows... 
       Using parameters and evaluating parameters
       Populating a GridView and allowing a user to select a subscription from list of available subs
       How to get various property values from the Azure subscription
     
 Author: Dan Stolts - dstolts&microsoft.com - http://ITProGuru.com
         Script Home: http://ITProGuru.com/Scripts 
 Syntax/Execution: 
      Copy portion of script you want to use and paste into PowerShell (or ISE)  
      ./Open-AzureRmSubscription.ps1  
      ./Open-AzureRmSubscription.ps1  -SubscriptionID 12345-6789...
       
 Disclaimer: Use at your own Risk!  See details at http://ITProGuru.com/privacy  
 Limitations:  
        * If you do not already have an Azure connection, unremark the line below Add-AzureAccount
        * Must Run PowerShell (or ISE)  
        * UAC may get in the way depending on your settings (See: http://ITProGuru.com/PS-UAC) 
 ================================================================================ 
#># 


Param (
    [Parameter(Mandatory=$false)][string]$SubscriptionID        # Subscription to create storage in
    ) 
# Sign-in with Azure account credentials
Login-AzureRmAccount

If ($SubscriptionID -eq "") {
  # See how many subscriptions are available... 
  $mySubscriptions = Get-AzureRmSubscription
  $SubscriptionID = $mySubscriptions[0]  # just grab the first one for now...
  If ($mySubscriptions.Count -gt 1) { 
    Write-Host "Select SubscriptionID from the popup list." -ForegroundColor Yellow
    $subscriptionId = 
        (Get-AzureRmSubscription |
         Out-GridView `
            -Title "Select an Azure Subscription …" `
            -PassThru).SubscriptionId
  }
}
$mySubscription=Select-AzureRmSubscription -SubscriptionId $subscriptionId
$SubscriptionName = $mySubscription.Subscription.SubscriptionName
Write-Host "Subscription: $SubscriptionName $subscriptionId " -ForegroundColor Green
$mySubscription
