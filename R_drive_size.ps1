# Prompt the user to enter the drive letter to scan
$driveLetter = Read-Host -Prompt "Enter the drive letter you want to scan (e.g., C:)"

# Define the number of top largest items to list
$topN = 10

# Read the server names from the variable file
$servers = Get-Content -Path "C:\path\to\servers.txt" # Replace with the actual path to the variable file

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

# Loop through each server and run the script block
foreach ($server in $servers) {
    # Define the output file path for each server
    $outputFilePath = "C:\scripts\TopLargestFiles_$server.txt"

    # Run the script block on the remote host
    $output = Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -ArgumentList $driveLetter, $topN

    # Write the output to the individual text file
    Add-Content -Path $outputFilePath -Value $output

    # Confirm that the output has been written for each server
    Write-Output "The output has been written to $outputFilePath for server $server"
}
