$serverListFile = "C:\scripts\list.txt"
$outputFile = "C:\scripts\output.txt"


# Read the server names from the file
$servers = Get-Content -Path $serverListFile

# Loop through each server
foreach ($server in $servers) {
    # Check if Splunk is installed
    $splunkInstalled = Invoke-Command -ComputerName $server -ScriptBlock {
        Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "Splunk*" }
    }

    # Check if Splunk process is running
    $splunkProcessRunning = Invoke-Command -ComputerName $server -ScriptBlock {
        Get-Process -Name splunkd -ErrorAction SilentlyContinue
    }

    # Output the results
    Write-Host "Server: $server" | Out-File -FilePath $outputFile -Append
    if ($splunkInstalled) {
        Write-Host "  Splunk is installed." | Out-File -FilePath $outputFile -Append
    } else {
        Write-Host "  Splunk is not installed." | Out-File -FilePath $outputFile -Append
    }

    if ($splunkProcessRunning) {
        Write-Host "  Splunk process is running." | Out-File -FilePath $outputFile -Append
    } else {
        Write-Host "  Splunk process is not running." | Out-File -FilePath $outputFile -Append
    }
    Write-Host "" | Out-File -FilePath $outputFile -Append
}

