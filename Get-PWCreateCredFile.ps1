<#   
========= Get-PWCreateCredFile.ps1 ======================================= 
 Name: Get-PWFromCredFile.ps1 
 Purpose: Create XML file with username and Secure Password stored.  
           Converts Text Version of Secure String to Plain Text
 Partner function: Get-PWCreateCredFile.ps1
 
 Description: grab username/password from parameter or console; convert password to SecureString; save to XML file

 Author: Dan Stolts - dstolts&microsoft.com - http://ITProGuru.com
         Script Home: http://ITProGuru.com/Scripts 
 Syntax/Execution: 
      Copy portion of script you want to use and paste into PowerShell (or ISE) 
      .OR.
        .\Get-PWCreateCredFile.ps1  -Name "FB_AppSecret"  -Password "MyFaceBookPassword"
        .\Get-PWCreateCredFile.ps1  "GoogClientSecret";         #Password will be requested at the console
        .\Get-PWCreateCredFile.ps1  -Name "TwitterSecret";      #Password will be requested at the console
      
 Disclaimer: Use at your own Risk!  See details at http://ITProGuru.com/privacy  
 Limitations:  
        * Must Run PowerShell (or ISE)  
# Leveraged: https://docs.microsoft.com/en-us/aspnet/identity/overview/features-api/best-practices-for-deploying-passwords-and-other-sensitive-data-to-aspnet-and-azure

 ================================================================================ 
#># 


param(
  [Parameter(Mandatory=$true)] 
  [String]$Name,
  [Parameter(Mandatory=$true)]
  [String]$Password)
#$Name, $Password
$credPath = $PSScriptRoot + '\' + $Name + ".credential"
$PWord = ConvertTo-SecureString -String $Password -AsPlainText -Force 
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Name, $PWord
$Credential | Export-CliXml $credPath



