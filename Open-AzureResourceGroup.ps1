<#   
========= Open-AzureResourceGroup.ps1 ======================================= 
 Name: Open-AzureResourceGroup 
 Purpose: Select Azure Account, Select Resource group or optionally create new resource group
          Select Azure Resource Group - if multiple, pops a box to allow user to select.
          If user cancels from popup box creates resource group.  Prompts for any values that are not passed in as parameters
    Also shows... 
       Using parameters and evaluating parameters
       Populating a GridView and allowing a user to select an option from list of available 
       How to get various property values from the Azure subscription
       How to get input from user (for the ResourceGroup Name)
       Includes checking for multiple subscriptions before offering to select subscription.  If only one, then uses it.
     
 Author: Dan Stolts - dstolts&microsoft.com - http://ITProGuru.com
         Script Home: http://ITProGuru.com/Scripts 
 
 Syntax/Execution: 
      Copy portion of script you want to use and paste into PowerShell (or ISE)  
      ./Open-AzureResourceGroup.ps1  
      ./Open-AzureResourceGroup.ps1  -SubscriptionID "12345-6789..." -rgName "myResourceGroupName" -Location eastus
       
 Disclaimer: Use at your own Risk!  See details at http://ITProGuru.com/privacy  
 
 Limitations:  
        * If you do not already have an Azure connection, unremark the line below Add-AzureAccount
        * Must Run PowerShell (or ISE)  
        * UAC may get in the way depending on your settings (See: http://ITProGuru.com/PS-UAC) 

See Also http://itproguru.com/expert/2016/04/powershell-working-with-azure-resource-manager-rm-step-by-step-changing-rm-subscriptions/

 ================================================================================ 
#># # 
# 

Param (
    [Parameter(Mandatory=$false)][string]$Location,               # Defaults to Location of Resource Group
    [Parameter(Mandatory=$false)][string]$RGName,                 # Pops List to select default
    [Parameter(Mandatory=$false)][string]$SubscriptionID          # Subscription to create RG in
) 

# Sign-in with Azure account credentials
Login-AzureRmAccount
#Add-AzureAccount   # Not needed becase we are only using RM portal commands :)

# See how many subscriptions are available... 
$mySubscriptions = Get-AzureRmSubscription
$Subscription = $mySubscriptions[0]  # just grab the first one for now...

#Check if parameters supplied  
If ($SubscriptionID -eq "") {  # SubscriptionID was NOT passed in as a parameter
  If ($mySubscriptions.Count -gt 1) { # More than one subscription available to logged in user
    Write-Host "Select SubscriptionID from the popup list." -ForegroundColor Yellow
    $Subscription = (Get-AzureRmSubscription |
         Out-GridView `
            -Title "Select an Azure Subscription …" `
            -PassThru)
    $SubscriptionID = $Subscription.SubscriptionID  # Grab the selected ID
    $SubscriptionName = $Subscription.SubscriptionName  # Grab the selected Name
  }
}
$mySubscription=Select-AzureRmSubscription -SubscriptionId $SubscriptionID #Open the subscription
$SubscriptionName = $mySubscription.Subscription.SubscriptionName  # Grab the name 
Set-AzureRmContext -SubscriptionID $SubscriptionID  # Set the Default Subscription
Write-Host "Subscription: $SubscriptionName $subscriptionId " -ForegroundColor Green


If ($RGName -eq "") {
    # have user select RG
    Write-Host "Select Resource Group from the list.  If you cancel, you will be given the option to create a new one" -ForegroundColor Yellow
    $myRG = (Get-AzureRmResourceGroup |
         Out-GridView `
            -Title "Select an Azure Resource Group; Press <ESC> <Cancel> to create new…" `
            -PassThru)
    If (!($myRG -eq $null)) {
        $RGName = $myRG.ResourceGroupName  # Grab the ResourceGroupName
        $Location = $myRG.Location       # Grab the ResourceGroupLocation (region)
    }  #else user pressed escape
}
# make sure the RG exists, if not, we need to create it
$RgExists = Get-AzureRmResourceGroup | Where {$_.ResourceGroupName -eq $RGName }  # See if the RG exists.  If user pressed escape on drop box or passed a name that does not exist

# Make sure the RG Exists.  Create it if it does not (user pressed cancel above)
If (!($RgExists)) {

} 

If ($Location -eq "") {
    Write-Host "Select Region from the list to use for Resource Group" -ForegroundColor Yellow
    # Select Azure regions
    $regions = Get-AzureRmLocation  
    $Location =  ($regions | 
            Out-GridView `
            -Title "Select Azure Datacenter Region …" `
            -PassThru).location
}
Write-Host "Location: $Location " -ForegroundColor Green

#Create ResourceGroup 
If (!($RgExists)) {
    write-host "Need to create New Resource Group " -ForegroundColor Yellow
    If ($RGName -eq "") {
       $RGName = Read-Host -Prompt 'What Name would you like to give your new Resource Group?'
    }
    # All the above just confirmed or obtained the values to use in the create resource group.  
    # Below is all you need if you know your values are correct for the creation.
    Write-Host "Creating ResourceGroup $RGName in $Location on Account $SubscriptionID" -ForegroundColor Green
    $Result = New-AzureRmResourceGroup -Name $RGName -location $Location 
    Start-Sleep -Seconds 10
    Write-Host "Finished Creating ResourceGroup $RGName in $Location on Account $SubscriptionID" -ForegroundColor Green
    $Result
}
$myResourceGroup = Get-AzureRmResourceGroup | Where {$_.ResourceGroupName -eq $RGName } 
$myResourceGroup
Write-Host "ResourceGroup $RGName in $Location on Account $SubscriptionID" -ForegroundColor Green
Write-Host "Your Resource Group is stored in the variable `$myResourceGroup"
