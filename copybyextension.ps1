#udemy doesn't allow .ps1 extensions so I saved this as a .txt file. Make sure you save it as a ps1


#Parameters
param([string]$source="c:\temp\source",[string]$destination="c:\temp\destination")
#The script should take 2 arguments $source and $destination (for the source and destination folders).

#Functions
#2)	Functions

#Create a function named CheckFolder that checks for the existence of a specific directory/folder that is passed 
#to it as a parameter. Also, include a switch parameter named create. If the directory/folder does not exist and 
#the create switch is specified, a new folder should be created using the name of the folder/directory that was 
#passed to the function.

function Check-Folder([string]$path,[switch]$create) {
    $exists = Test-Path $path

    if (!$exists -and $create) {
        New-Item $path -ItemType directory | out-null
        $exists = Test-Path $path
    }

    return $exists
}

#Create a function named DisplayFolderStatistics to display folder statistics for a directory/path that is passed 
#to it. Output should include the name of the folder, number of files in the folder, and total size of all files in 
#that directory.

function DisplayFolderStats([string]$path) {

    $files = dir $path  -Recurse | where {!$_.PSIsContainer}
    $totals = $files | Measure-Object -property length -sum
    $stats = "" | select path,count,size
    $stats.path = $path
    $stats.count = $totals.Count
    $stats.size = [math]::Round($totals.Sum/1MB,5)
    return $stats

}




#3)	Main processing
#a) Test for existence of the source folder (using the CheckFolder function).
$sourceExists = Check-Folder $source
if (!$sourceExists) {
    Write-Host "The source folder doesnt exist, cant contiue."
    exit
}

#b) Test for the existence of the destination folder; create it if it is not found (using the CheckFolder function 
#with the –create switch).Write-Host "Testing Destination Directory - $destination"
$destinationExists = Check-Folder $destination
if (!$destinationExists) {
    Write-Host "The destination folder doesnt exist, so creating one"
    Check-Folder $destination -create
}

#DisplayFolderStats $source


#c) Copy each file to the appropriate destination.
#get all the files that need to be copied

$files = dir $source -Recurse | where{!$_.PSIsContainer}


foreach($file in $files ) {
    $extensionOfFile = $file.extension.replace(".","")
    $destinationDir = "$destination\$extensionOfFile"
    $extendedDestDir = Check-Folder $destinationDir -create
    Write-Host "$path $file.PSPath getting copied to $destinationDir"
    Copy-Item $file.PSPath $destinationDir -Force
}

#c-i) Display a message when copying a file. The message should list where the file is being
#moved from and where it is being moved to.

#d) Display each target folder name with the file count and byte count for each folder.

$dirs = dir $destination | where {$_.PSIsContainer}

$allStats = @()
foreach($dir in $dirs) {
   $allStats += DisplayFolderStats $dir.FullName
}

$allStats