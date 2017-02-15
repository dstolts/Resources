# https://docs.microsoft.com/en-us/azure/resource-group-template-deploy
Login-AzureRmAccount
Set-AzureRmContext -SubscriptionID "1942a221-7d86-4e10-9e4b-d5af2688651c"
New-AzureRmResourceGroup -Name GuruDemoExampleRG -Location "West US"
#Validate Deployment...
Test-AzureRmResourceGroupDeployment -ResourceGroupName ExampleResourceGroup -TemplateFile <PathToTemplate>
New-AzureRmResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName ExampleResourceGroup -TemplateFile <PathToTemplate>


