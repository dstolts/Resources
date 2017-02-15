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

.vscode
app
bin
server
setup
.bowerrc
.gitignore
.jshintrc
bower.json
compute.json
Create-AzureResearch.ps1
Create-AzureRmLinuxVM.ps1
docker-compose.yml
Dockerfile
gulpfile.js
jsdoc.json
karma.conf.js
LICENSE
package.json
README.md
README2.md
web.config
.vscode\settings.json
app\css
app\js
app\partials
app\index.html
app\css\main.css
app\css\newage.css
app\js\controllers
app\js\services
app\js\main.js
app\js\controllers\Admin
app\js\controllers\Auth
app\js\controllers\Batch
app\js\controllers\Home
app\js\controllers\Interactive
app\js\controllers\Layout
app\js\controllers\Admin\adminCtrl.js
app\js\controllers\Auth\AuthCallbackController.js
app\js\controllers\Auth\AuthController.js
app\js\controllers\Auth\AuthControllerSpec.js
app\js\controllers\Batch\createBatchCtrl.js
app\js\controllers\Batch\viewBatchCtrl.js
app\js\controllers\Home\HomeController.js
app\js\controllers\Home\HomeControllerSpec.js
app\js\controllers\Interactive\dashboardCtrl.js
app\js\controllers\Interactive\taskCtrl2.js
app\js\controllers\Interactive\vmCtrl.js
app\js\controllers\Interactive\vmDetailCtrl.js
app\js\controllers\Interactive\vmHistoryCtrl.js
app\js\controllers\Interactive\vmSelectDedicatedCtrl.js
app\js\controllers\Interactive\vmSelectPoolCtrl.js
app\js\controllers\Layout\layoutCtrl.js
app\js\services\authService.js
app\js\services\azureService.js
app\js\services\dataService.js
app\js\services\mockDataService.js
app\js\services\userService.js
app\partials\admin.html
app\partials\batchDetails.html
app\partials\createBatch.html
app\partials\dashboard.html
app\partials\home.html
app\partials\invite.html
app\partials\notAuthorized.html
app\partials\queueTask.html
app\partials\selectVMDedicated.html
app\partials\selectVMPool.html
app\partials\signin.html
app\partials\vmDetail.html
app\partials\vmLimit.html
bin\ChangeConfig.ps1
bin\download.ps1
bin\My interactive jobs
bin\node.cmd
bin\setup_web.cmd
server\api
server\config
server\server.js
server\api\authService.js
server\api\batchService.js
server\api\dedicatedService.js
server\api\sshService.js
server\api\storageService.js
server\api\userService.js
server\api\vmSetService.js
server\config\arm_templates
server\config\models
server\config\helpers.js
server\config\middleware.js
server\config\routes.js
server\config\sdkClients.js
server\config\arm_templates\RStudio Server on CentOS 7.0
server\config\arm_templates\RStudio Server on Ubuntu Linux 14.04
server\config\arm_templates\Ubuntu Linux 16.04
server\config\arm_templates\RStudio Server on CentOS 7.0\azuredeploy.json
server\config\arm_templates\RStudio Server on CentOS 7.0\azuredeploy.parameters.json
server\config\arm_templates\RStudio Server on CentOS 7.0\existingvnet.json
server\config\arm_templates\RStudio Server on CentOS 7.0\metadata.json
server\config\arm_templates\RStudio Server on CentOS 7.0\newvnet.json
server\config\arm_templates\RStudio Server on CentOS 7.0\README.md
server\config\arm_templates\RStudio Server on Ubuntu Linux 14.04\azuredeploy.json
server\config\arm_templates\RStudio Server on Ubuntu Linux 14.04\azuredeploy.parameters.json
server\config\arm_templates\RStudio Server on Ubuntu Linux 14.04\existingvnet.json
server\config\arm_templates\RStudio Server on Ubuntu Linux 14.04\metadata.json
server\config\arm_templates\RStudio Server on Ubuntu Linux 14.04\mount.sh
server\config\arm_templates\RStudio Server on Ubuntu Linux 14.04\newvnet.json
server\config\arm_templates\RStudio Server on Ubuntu Linux 14.04\README.md
server\config\arm_templates\RStudio Server on Ubuntu Linux 14.04\rstudio.desktop
server\config\arm_templates\RStudio Server on Ubuntu Linux 14.04\rstudioApp.sh
server\config\arm_templates\Ubuntu Linux 16.04\azuredeploy.json
server\config\arm_templates\Ubuntu Linux 16.04\azuredeploy.parameters.json
server\config\arm_templates\Ubuntu Linux 16.04\existingvnet.json
server\config\arm_templates\Ubuntu Linux 16.04\metadata.json
server\config\arm_templates\Ubuntu Linux 16.04\newvnet.json
server\config\arm_templates\Ubuntu Linux 16.04\README.md
server\config\models\batchJobInfo.js
server\config\models\docdbUtils.js
server\config\models\userController.js
server\config\models\userDao.js
server\config\models\vmdController.js
server\config\models\vmdDao.js
server\config\models\vmScalesetInfo.js
setup\setup.sh

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
