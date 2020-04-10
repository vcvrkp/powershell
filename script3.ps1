function Get-DirInfo($dir) {

    $item = Get-ChildItem $dir -Recurse | Measure-Object -Property length -Sum
    return [math]::Round($item.sum/1GB,4)

}

Get-DirInfo c:\temp