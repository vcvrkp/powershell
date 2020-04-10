$names = import-csv .\original.csv
$names = $names | sort -Property pcthispanic
$names[$names.Length - 1] 