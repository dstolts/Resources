Param(
[string]$RGName,
[string]$vmName
)

# Sign-in with Azure account credentials
Login-AzureRmAccount

### usage ./captureimage.ps1 ResourceGroupName VMName
#$RGName = ResourceGroupName
#$vmName = VMName
$RGName =  "IQSS-PoC-App"  
$vmName = "IQSSDocker01"
$SubscriptionID = ""
$Location = ""
$srcContainer = "system"

$destStorageAcct = "publicstore" # Destination Storage Account
$uniqueId = Get-Date -format yyyyMMddHHmmss  # make a sudo unique storage name  (could also use Get-Random)
$destStorageAcct += $uniqueId            
$destStorageAcct = "iqssdocker"    # Destination Storage Account
$destContainerName = "images"  # Destination Container Name

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
Set-AzureRmContext -SubscriptionID $subscriptionId
Write-Host "Subscription: $SubscriptionName $subscriptionId " -ForegroundColor Green

If ($RGName -eq "") {
    # have user select RG
    $myRG = (Get-AzureRmResourceGroup |
         Out-GridView `
            -Title "Select an Azure Resource Group …" `
            -PassThru)
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
    $RGName = Read-Host -Prompt 'What Name would you like to give your new Resource Group?'
} 
Else 
{  # Need to grab the location from the RG
    $RGName = $RGExists.ResourceGroupName  # Grab the ResourceGroupName
    $Location = $RGExists.Location       # Grab the ResourceGroupLocation (region)
    Write-Host "ResourceGroup $RGName in $Location on Account $SubscriptionID" -ForegroundColor Green}

If ($Location -eq "") {
    Write-Host "Select Region from the list to use for Resource Group" -ForegroundColor Yellow
    # Select Azure regions
    $regions = Get-AzureRmLocation  
    $Location =  ($regions | 
            Out-GridView `
            -Title "Select Azure Datacenter Region …" `
            -PassThru).location
            Write-Host "Location: $Location " -ForegroundColor Green
} 


# Capture VM and RG data in variables
$vm = Get-AzureRmVm $RGName $vmName 
$osvhduri = $vm.StorageProfile.OsDisk.Vhd.Uri
$pip = ".$Location.cloudapp.azure.com"

# Capture sorage account name, nic, FQDN and vm Image Name
$VM_STOR_ACCT_NAME = Get-AzureRmStorageAccount $RGName -Name $osvhduri.split('/')[2].split('.')[0] | Select-Object -ExpandProperty StorageAccountName
$get_vm_nic = $vm.NetworkInterfaceIDs.split('/')[8] -replace("nic","pip")
$get_vm_fqdn = $get_vm_nic + $pip
$get_vm_image_name = $vm.StorageProfile.OsDisk.Name

### Begin Azure Capture

azure vm deallocate -g $RGName -n $vmName
azure vm generalize -g $RGName -n $vmName
azure vm capture $RGName $vmName Ubuntu16Gen -t General_Image.json

### End Azure Capture

### Begin Storage Account Copy ###
# Get Source Storage account key
$sourceKey = Get-AzureRmStorageAccountKey $RGName $VM_STOR_ACCT_NAME 
$srcStorageKey = ($sourceKey.value -split '\n')[0] 

# Create source context for authenticating the copy
$srcCtx = New-AzureStorageContext -StorageAccountName $VM_STOR_ACCT_NAME `
                                  -StorageAccountKey $srcStorageKey

# Source VHD, Container and Blob info
#$srcContainer = "system" 
$srcContainer = ([System.Uri]$osvhduri).segments[1] # Get the folder name
$srcContainer = $srcContainer.Substring(0,$srcContainer.Length-1) # Strip the trailing slash /
$srcContainer
Write-Output "Basevm storage account name: $VM_STOR_ACCT_NAME"
$blobURI = $osvhduri.split("/")[0, 1, 2] -join '/'
$captureDisk = Get-AzureStorageBlob -Container $srcContainer -Context $srcCtx

$srcBlob = $captureDisk.Name

# Create Destination Storage account
# Need to make sure it does not already exist adn create if it does not.

Write-Host "Checking Storage Accounts" 
$StorageAccount = Get-AzureRmStorageAccount | Where {$_.StorageAccountName -eq $destStorageAcct } # Get the Storage Account

If ($StorageAccount -eq "") {  # Account does not exist
  # In a future version, may want to add error checking.  Will crash if no storage accounts in current $rgName
   New-AzureRmStorageAccount $RGName -SkuName Standard_LRS -Location $Location -Kind Storage $destStorageAcct
}


# Get Destination storage account key
$destKey = Get-AzureRmStorageAccountKey $RGName $destStorageAcct
$destStorageKey = ($destKey.value -split '\n')[0]

# Create destination context for authenticating the copy
$destContext = New-AzureStorageContext -StorageAccountName $destStorageAcct `
                                       -StorageAccountKey $destStorageKey
# Create the target container in storage
New-AzureStorageContainer -Name $destContainerName -Context $destContext -Permission blob

# Start Asynchronus Copy #
$blob1 = Start-AzureStorageBlobCopy -SrcBlob $srcBlob `
                                    -SrcContainer $srcContainer `
                                    -DestContainer $destContainerName `
                                    -Context $srcCtx `
                                    -DestContext $destContext

### Check Status of Blob Copy ###
$status = $blob1 | Get-AzureStorageBlobCopyState

## Print status of Blob copy state ##
$status

### Loop until complete
While($status.Status -eq "Pending"){
    $status = $blob1 | Get-AzureStorageBlobCopyState
    Start-Sleep 10
    ### Print out status ###
    $status
}

#Image FQDN
$ImageURI = (Get-AzureStorageBlob -Context $destContext -blob $srcBlob -Container $destContainerName).ICloudBlob.uri.AbsoluteUri
Write-Output "`n"
Write-Output "Your Image URI is: $ImageURI"
