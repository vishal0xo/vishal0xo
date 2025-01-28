#ServerName,DriveLetter
#Server1,C:
#Server2,D:
#Server3,E:

# Read the CSV file containing server names and drive letters
$driveServerList = Import-Csv -Path "C:\path\to\drive_server_list.csv" # Replace with the actual path to your CSV file

# Define the number of top largest items to list
$topN = 10

# Define the script block to run on the remote host
$scriptBlock = {
    param ($driveLetter, $topN)

    # Get the top N largest files
    $topLargestFiles = Get-ChildItem -Path "$driveLetter\" -Recurse -File -ErrorAction SilentlyContinue | Sort-Object -Property Length -Descending | Select-Object -First $topN

    # Convert the results to a string for output
    $output = "Top $topN Largest Files (in MB):`n"
    $topLargestFiles | ForEach-Object { $output += "$($_.FullName) - $([math]::Round($_.Length / 1MB, 2)) MB`n" }
    return $output
}

# Loop through each entry in the CSV file and run the script block
foreach ($entry in $driveServerList) {
    $driveLetter = $entry.DriveLetter
    $server = $entry.ServerName

    # Define the output file path for each server
    $outputFilePath = "C:\scripts\TopLargestFiles_$server.txt"

    # Run the script block on the remote host
    $output = Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -ArgumentList $driveLetter, $topN

    # Write the output to the individual text file
    Add-Content -Path $outputFilePath -Value $output

    # Confirm that the output has been written for each server
    Write-Output "The output has been written to $outputFilePath for server $server"
}




