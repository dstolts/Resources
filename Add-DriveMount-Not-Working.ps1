https://technet.microsoft.com/en-us/library/ee176915.aspx 
New-PSDrive -name t -psprovider FileSystem -root "c:\scripts"
cd  
$ProfilePath = (Get-Variable profile | select value).value.tostring()
$ProfilePath
Notepad.exe $ProfilePath 
