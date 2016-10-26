# Select Azure Subscription - if multiple, pops a box to allow user to select 
# Sign-in with Azure account credentials
Add-AzureAccount
Login-AzureRmAccount

Param (
    [Parameter(Mandatory=$false)][string]$SubscriptionID        # Subscription to create storage in
    ) 
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
