# Prompt the user to enter the drive letter to scan
$driveLetter = Read-Host -Prompt "Enter the drive letter you want to scan (e.g., C:)"

# Define the output file path
$outputFilePath = "C:\scripts\TopLargestItems.txt"

# Define the number of top largest items to list
$topN = 10

# Get the top N largest files
$topLargestFiles = Get-ChildItem -Path "$driveLetter\" -Recurse -File -ErrorAction SilentlyContinue | Sort-Object -Property Length -Descending | Select-Object -First $topN

# Get the top N largest folders
$topLargestFolders = Get-ChildItem -Path "$driveLetter\" -Recurse -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $folderSize = (Get-ChildItem -Path $_.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB
    [PSCustomObject]@{
        Name = $_.FullName
        Size = $folderSize
    }
} | Sort-Object -Property Size -Descending | Select-Object -First $topN

# Write the output to the text file
Add-Content -Path $outputFilePath -Value "Top $topN Largest Files (in MB):`n"
$topLargestFiles | ForEach-Object { Add-Content -Path $outputFilePath -Value "$($_.FullName) - $([math]::Round($_.Length / 1MB, 2)) MB" }

Add-Content -Path $outputFilePath -Value "`nTop $topN Largest Folders (in MB):`n"
$topLargestFolders | ForEach-Object { Add-Content -Path $outputFilePath -Value "$($_.Name) - $([math]::Round($_.Size, 2)) MB" }

# Confirm that the output has been written
Write-Output "The output has been written to $outputFilePath"
