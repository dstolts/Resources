<#   
========= Get-PWFromCredFile.ps1 ======================================= 
 Name: Get-PWFromCredFile.ps1 
 Purpose: Open and Read XML file with Secure Password stored.  
           Converts Text Version of Secure String to Plain Text
 # Partner function of Get-PWCreateCredFile.ps1
     
 Author: Dan Stolts - dstolts&microsoft.com - http://ITProGuru.com
         Script Home: http://ITProGuru.com/Scripts 
 Syntax/Execution: 
      Copy portion of script you want to use and paste into PowerShell (or ISE)  
      .OR.
      $myVar = Get-PWFromCredFile(".\FB_AppSecret.credential")
      .OR.
      Write-host $(Get-PWFromCredFile ".\FB_AppSecret.credential")
      .OR.
         # Sample Uses: Read in Cred File to populate app settings array ...
        $AppSettings = @{	
          "FB_AppSecret"     = $(Get-PWfromCredFile ".\FB_AppSecret.credential");
          "GoogClientSecret" = $(Get-PWfromCredFile ".\GoogClientSecret.credential");
          "TwitterSecret"    = $(Get-PWfromCredFile ".\TwitterSecret.credential");
        }
        $AppSettings
        # Push settings up to Azure
        Set-AzureWebsite -Name $WebSiteName -AppSettings $AppSettings
    
 Disclaimer: Use at your own Risk!  See details at http://ITProGuru.com/privacy  
 Limitations:  
        * Must Run PowerShell (or ISE)  
# Leveraged: https://docs.microsoft.com/en-us/aspnet/identity/overview/features-api/best-practices-for-deploying-passwords-and-other-sensitive-data-to-aspnet-and-azure

 ================================================================================ 
#># 

Function Get-PWfromCredFile { Param( [String]$CredFile )
    #Debug $CredFile=".\FB_AppSecret.credential"
    [xml]$CredFileContent = Get-Content -Path $CredFile
    #Username=$CredName captured just to show you how
    $CredName = $CredFileContent.Objs.Obj.Props.S.'#text'
    $CredPassSecTxt = $CredFileContent.Objs.Obj.Props.SS.'#text'  
    # $CredPassSecTxt This is the String representation of the Secure Password
    # Still need to convert it to SecureString
    $SecurePassword = ConvertTo-SecureString $CredPassSecTxt
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
    $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
 
    <# The following is how you could create a credential out of the inforamtion
    $UserName="Domain\User"
    $Credentials=New-Object System.Management.Automation.PSCredential`
        -ArgumentList $CredName, $SecurePassword 
    #>#Create Credential out of information.
    Return $UnsecurePassword
}	




