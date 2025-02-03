# Read the CSV file containing server names and drive letters
$driveServerList = Import-Csv -Path "C:\path\drive_server_list.csv" 

# Define the number of top largest items to list
$topN = 10

# Define the script block to run on the remote host
$scriptBlock = {
    param ($driveLetter, $topN)

    try {
        # Get the top N largest files
        $topLargestFiles = Get-ChildItem -Path "$driveLetter\" -Recurse -File -ErrorAction SilentlyContinue | Sort-Object -Property Length -Descending | Select-Object -First $topN

        # Convert the results to a string for output
        $output = $topLargestFiles | Select-Object FullName, @{Name="Size(GB)";Expression={"$([math]::Round($_.Length / 1GB, 2)) GB"}} | Format-List | Out-String
        return $output
    } catch {
        return "Error retrieving files from ${driveLetter}: $($_.Exception.Message)"
    }
}

# Define the output CSV file path
$outputCsvFilePath = "C:\path\TopLargestFiles.csv"

# Initialize the CSV file with headers
"ServerName,TopLargestFile,FileSize(GB),Status" | Out-File -FilePath $outputCsvFilePath -Encoding utf8

# Loop through each entry in the CSV file and run the script block
$counter = 0
$totalServers = $driveServerList.Count

foreach ($entry in $driveServerList) {
    $driveLetter = $entry.DriveLetter
    $server = $entry.ServerName

    try {
        # Run the script block on the remote host
        $output = Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -ArgumentList $driveLetter, $topN

        # Split the output into individual lines
        $outputLines = $output -split "`n"

        # Write the server name in a separate row
        $csvLine = "$server,,,"
        $csvLine | Out-File -FilePath $outputCsvFilePath -Append -Encoding utf8

        # Write each file as a separate row in the CSV file
        foreach ($line in $outputLines) {
            if ($line -match "FullName\s+:\s+(.*)") {
                $fileName = $matches[1]
            }
            if ($line -match "Size\(GB\)\s+:\s+(.*)") {
                $fileSize = $matches[1]
                $csvLine = ",$fileName,$fileSize,"
                $csvLine | Out-File -FilePath $outputCsvFilePath -Append -Encoding utf8
            }
        }

        # Add a blank line after each server's output
        "`n" | Out-File -FilePath $outputCsvFilePath -Append -Encoding utf8

        # Confirm that the output has been written for each server
        Write-Output "The output has been written to ${outputCsvFilePath} for server ${server}"
    } catch {
        Write-Output "Error processing server ${server}: $($_.Exception.Message)"
    }

    # Update and display progress in real-time
    $counter++
    Write-Progress -Activity "Processing Servers" -Status "Processing $server" -PercentComplete (($counter / $totalServers) * 100)
}
#.csv
#ServerName,DriveLetter
#server_name,c:
#server_name,d:
