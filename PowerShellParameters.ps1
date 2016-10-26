# Working with PowerShell Parameters

 Param (
    [Parameter(Mandatory=$false)][string]$myString1,              # Defaults to Location of Resource Group
    [Parameter(Mandatory=$false)][string]$myString2,              # another string
    [Parameter(Mandatory=$false)][switch]$help                    # switch... If it is there, the value will be $true
)  

Write-host "Evaluate parameters"
If ($myString1 -eq "") {
    # do something
    Write-Host "Parameter myString1 is empty"
    }
Write-Host "myString1 is: $myString1"

If ($myString2 -eq "") {    # do something    
Write-Host "Parameter myString2 is empty"    }
Write-Host "myString2 is: $myString2"

# Display help... coming soon.
If ($help) { 
Write-Host "Display help and Examples here..."
        Write-Host "... 
        [Parameter(Mandatory=$false)][string]$myString1,              `# A string value    
        [Parameter(Mandatory=$false)][string]$myString2,              `# another string    
        [Parameter(Mandatory=$false)][switch]$help                    `# switch... If it is there, the value will be $true
    " -ForegroundColor Green
} 
