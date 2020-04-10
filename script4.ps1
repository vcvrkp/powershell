#parameters
param([string]$dir="c:\temp")

#function
function Get-DirInfo($dir) {

    $item = Get-ChildItem $dir -Recurse | Measure-Object -Property length -Sum
    return [math]::Round($item.sum/1GB,4)

}

#main-processing
Get-DirInfo $dir