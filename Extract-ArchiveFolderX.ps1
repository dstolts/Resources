function finditem($items, $itemname)
{
  foreach($item In $items)
  {
    if ($item.GetFolder -ne $Null)
    {
      finditem $item.GetFolder.items() $itemname
    }
    if ($item.name -Like $itemname)
    {
        return $item
    } 
  } 
} 
#Del C:\Temp\output\*.* -force
Del C:\Temp\wwwroot\*.* -force
$source = 'c:\temp\SampleFile.zip'
$target = 'c:\temp\wwwroot\'

$shell = new-object -com Shell.Application

# find script folder e.g. c:\temp\test.zip\test\etc\script
$test = $shell.NameSpace($source)

#Search for a folder named "Out" set it to our $item variable
$item = finditem $shell.NameSpace($source).Items() "Out"

# output folder is c:\temp\output\test\etc
New-Item $target -ItemType directory -ErrorAction Ignore

#Display directory before extract
Get-ChildItem C:\temp\wwwroot
Get-ChildItem c:\temp\wwwroot\out

#unzip c:\tmp\test.zip\test\etc\script to c:\tmp\output\test\etc
$shell.NameSpace($target).CopyHere($item) 

#Display directory After extract
Get-ChildItem C:\temp\wwwroot
Get-ChildItem c:\temp\wwwroot\out
