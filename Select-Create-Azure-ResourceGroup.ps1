# Select Azure Account, Select Resource group or optionally create new resource group
# Includes checking for multiple subscriptions before offering to select subscription.  If only one, then uses it.


Param (
    [Parameter(Mandatory=$false)][string]$Location,               # Defaults to Location of Resource Group
    [Parameter(Mandatory=$false)][string]$RGName,                 # Pops List to select default
    [Parameter(Mandatory=$false)][string]$SubscriptionID          # Subscription to create RG in
) 
# Sign-in with Azure account credentials
#Add-AzureAccount
#Login-AzureRmAccount
#region Evaluate Parameters; Create Defaults Values

#Check if parameters supplied  
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

If ($RGName -eq "") {
    # have user select RG
    Write-Host "Select Resource Group from the list.  If you cancel, you will be given the option to create a new one" -ForegroundColor Yellow
    $myRG = (Get-AzureRmResourceGroup |
         Out-GridView `
            -Title "Select an Azure Resource Group; Press <ESC> <Cancel> to create new…" `
            -PassThru).subscriptionID
    If (!($myRG -eq $null)) {
        $RGName = $myRG.ResourceGroupName  # Grab the ResourceGroupName
        $Location = $myRG.Location       # Grab the ResourceGroupLocation (region)
    }  #else user pressed escape, will need to create RG 
}
# make sure the RG exists
$RgExists = Get-AzureRmResourceGroup | Where {$_.ResourceGroupName -eq $RGName }  # See if the RG exists.  If user pressed escape on drop box or passed a name that does not exist

# Make sure the RG Exists.  Create it if it does not (user pressed cancel above)
If (!($RgExists)) {
   write-host "Need to create New Resource Group " -ForegroundColor Yellow
   Write-Host "Select Region from the list to use for Resource Group" -ForegroundColor Yellow
   If ($Location -eq "") {
        # Select Azure regions
        $regions = Get-AzureLocation  
        $Location =  $regions.Name | 
             Out-GridView `
                -Title "Select Azure Datacenter Region …" `
                -PassThru
    }
    Write-Host "Location: $Location " -ForegroundColor Green
    If ($RGName -eq "") {
        $RGName = Read-Host -Prompt 'What Name would you like to give your new Resource Group?'
    }
} 
Write-Host "ResourceGroup $RGName in $Location on Account $SubscriptionID" -ForegroundColor Green
