$serverListFile = "C:\scripts\list.txt"
$outputFile = "C:\scripts\output.txt"

# Read the server names from the file
$servers = Get-Content -Path $serverListFile

# Loop through each server
foreach ($server in $servers) {
    # output for each server
    $output = "Server: $server`n"
    
    # Check installed
    $splunkInstalled = Invoke-Command -ComputerName $server -ScriptBlock {
        Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "Splunk*" }
    }
    if ($splunkInstalled) {
        $output += "  Splunk is installed.`n"
    } else {
        $output += "  Splunk is not installed.`n"
    }

    # Check process is running
    $splunkProcessRunning = Invoke-Command -ComputerName $server -ScriptBlock {
        Get-Process -Name splunkd -ErrorAction SilentlyContinue
    }
    if ($splunkProcessRunning) {
        $output += "  Splunk process is running.`n"
    } else {
        $output += "  Splunk process is not running.`n"
    }

    # Append output to file
    $output | Out-File -FilePath $outputFile -Append
}
