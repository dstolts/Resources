<#   
========= Open-AzureRmStorage.ps1 ======================================= 
 Name: Open-AzureRmStorage 
 Purpose: Demonstrate how to Open Azure Storage using Azure Resource Manager commands
    Also shows... 
       Using parameters and evaluating parameters
       Populating a GridView and allowing a user to select a storage account from list of available accounts
       How to get various property values from the Azure Storage account
     
 Author: Dan Stolts - dstolts&microsoft.com - http://ITProGuru.com
         Script Home: http://ITProGuru.com/Scripts 
 Syntax/Execution: 
      Copy portion of script you want to use and paste into PowerShell (or ISE)  
      ./Open-AzureRmStorage.ps1  -StorageAccountName myStorageAccountName -RGName myRGName
       
 Disclaimer: Use at your own Risk!  See details at http://ITProGuru.com/privacy  
 Limitations:  
        * If you do not already have an Azure connection, unremark the line below Add-AzureAccount
        * Must Run PowerShell (or ISE)  
        * UAC may get in the way depending on your settings (See: http://ITProGuru.com/PS-UAC) 
 ================================================================================ 
#> 

Param (
    [Parameter(Mandatory=$false)][string]$StorageAccountName,     # Defaults to prompt user
    [Parameter(Mandatory=$false)][string]$RGName                 # Pops List to select default
)
# Sign-in with Azure account credentials
Login-AzureRmAccount
# Now Let's do the storage
Write-Host "Checking Storage Accounts" 
If ($StorageAccountName -eq "") {  # we do not know what storage account they want to open so let's pop a list
  # See how many storage accounts are available... 
  $myStorage = Get-AzureRmStorageAccount  # Get the Storage Account List
  $StorageAccount = $myStorage[0]  # just grab the first one for now...
  # In a future version, may want to add error checking.  Will crash if no storage accounts in current $rgName
  If ($myStorage.Count -gt 1) { 
    Write-Host "Select Storage Account from the popup list." -ForegroundColor Yellow
    $StorageAccount = 
        ($myStorage |
         Out-GridView `
            -Title "Select an Azure Storage Account …" `
            -PassThru)
    If (!($StorageAccount -eq $null)) {
        $RGName = $StorageAccount.ResourceGroupName  # Grab the ResourceGroupName from the storage account
        $Location = $StorageAccount.Location       # Grab the ResourceGroupLocation (region) from the storage account
        $StorageAccountName = $StorageAccount.StorageAccountName # Grab the StorageAccountName 
    }  #else user pressed escape
  }
}

Write-Host "Checking Resource Group"  
If ($RGName -eq "") {  # StorageAccountName was passed in as a parameter but the RGName was not.
    # have user select RG
    Write-Host "Select Resource Group from the list." -ForegroundColor Yellow
    $myRG = (Get-AzureRmResourceGroup |
         Out-GridView `
            -Title "Select an Azure Resource Group" `
            -PassThru)
    If (!($myRG -eq $null)) {
        $RGName = $myRG.ResourceGroupName  # Grab the ResourceGroupName
        $Location = $myRG.Location       # Grab the ResourceGroupLocation (region)
    }  #else user pressed escape
}
Write-Host "ResourceGroup $RGName in $Location" -ForegroundColor Green

# All of the above was just collecting the names of the storage account and the resourcegroup.  
# All of the storage stuff is below
# we have the name and RG, lets open the Storage account
# If you already have the names, you can just skip down to here.  
#   Populate variables for StorageAccountName and $rgName which are both required to open storage 

#$StorageAccount = (Get-AzureRmStorageAccount |Where-Object ResourceGroupName -eq $rgName|  Out-GridView -Title "Select Azure Storage Account …" -PassThru).StorageAccountName
$StorageAccount = Get-AzureRmStorageAccount -StorageAccountName $StorageAccountName  -ResourceGroupName $rgName # Get the Storage Account 
$StorageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $rgName -StorageAccountName $StorageAccountName).Value[0] # Get the primary Key 
$StorageAccountContext = New-AzureStorageContext -StorageAccountKey $StorageAccountKey -StorageAccountName $StorageAccountName # Get the Context 
$StorageAccount
$UriEndpoint = $StorageAccountContext.BlobEndPoint
Write-Host "The storage Account $StorageAccountName is now stored in the variable `$StorageAccount" -ForegroundColor Green
Write-Host "Public endpoint of $UriEndpoint" -ForegroundColor Green
Write-Host "  The storage Key is stored in `$StorageAccountKey and the context is stored in `$StorageAccountContext" -ForegroundColor Green
Write-Host "  You now have everything you need to work with this storage account" -ForegroundColor Green
Write-Host " Key: $StorageAccountKey" -ForegroundColor Green
Write-Host " Context: $StorageAccountContext "-ForegroundColor Green
Write-Host " Script Home: http://ITProGuru.com/Scripts" -ForegroundColor Red
