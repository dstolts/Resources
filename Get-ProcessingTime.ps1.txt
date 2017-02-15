<#   
========= Get-ProcessingTime.ps1 ======================================= 
 Name: Get-ProcessingTime 
 Purpose: Demonstrate how to track and show how long a task takes to complete
     
 Author: Dan Stolts - dstolts&microsoft.com - http://ITProGuru.com
         Script Home: http://ITProGuru.com/Scripts 
 Syntax/Execution: 
      Copy portion of script you want to use and paste into PowerShell (or ISE)  
      ./Show-ProcessingTime.ps1  
       
 Disclaimer: Use at your own Risk!  See details at http://ITProGuru.com/privacy  
 Limitations:  
        * If you do not already have an Azure connection, unremark the line below Add-AzureAccount
        * Must Run PowerShell (or ISE)  
        * UAC may get in the way depending on your settings (See: http://ITProGuru.com/PS-UAC) 

 ================================================================================ 
#># 
$StartTime = Get-Date -format HH:mm:ss   # Start Time (Save current time)
Write-Host "Starting Processing: $StartTime" -ForegroundColor Green 

#  ----- Tasks entered here are the ones that are clocked :)
Get-Process     # run something ....
sleep -s 2
#  ----- 

$FinishTime = Get-Date -format HH:mm:ss   # Stop Clock (Save current time)
$TimeDiff = New-TimeSpan $StartTime $FinishTime      # calculate the difference between start and stop
    $Days = $TimeDiff.Days                           # Days
    $Hrs = $TimeDiff.Hours                           # hours
    $Mins = $TimeDiff.Minutes                        # minutes
    $Secs = $TimeDiff.Seconds                        # Seconds
    $MilliSecs = $TimeDiff.Milliseconds              # Milliseconds (in case you care)
$Difference = '{0:00}:{1:00}:{2:00}' -f $Hrs,$Mins,$Secs   # Set formatting 
Write-host "Total Duration hh:mm:sec $Difference"          # display the duration
Write-Host " Total Milliseconds:" ($TimeDiff.TotalMilliseconds).ToString()
Write-Host " Script Home: http://ITProGuru.com/Scripts" -ForegroundColor Red
