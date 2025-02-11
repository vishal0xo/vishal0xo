$serverListFile = "C:\scripts\list.txt"
$outputFile = "C:\scripts\output.txt"

# Read the server names from the file
$servers = Get-Content -Path $serverListFile

# Initialize a variable to hold the combined output
$combinedOutput = @()

# Loop through each server
foreach ($server in $servers) {
    # Initialize output for each server
    $output = "Server: $server |"
    
    # Check if Splunk is installed by checking the version file
    $splunkVersion = Invoke-Command -ComputerName $server -ScriptBlock {
        if (Test-Path "C:\Program Files\SplunkUniversalForwarder\etc\splunk.version") {
            Get-Content "C:\Program Files\SplunkUniversalForwarder\etc\splunk.version"
        } else {
            $null
        }
    }
    if ($splunkVersion) {
        $output += " Splunk is installed (Version: $splunkVersion) |"
    } else {
        $output += " Splunk is not installed |"
    }

    # Check if Splunk process is running
    $splunkProcessRunning = Invoke-Command -ComputerName $server -ScriptBlock {
        Get-Process -Name splunkd -ErrorAction SilentlyContinue
    }
    if ($splunkProcessRunning) {
        $output += " Splunk process is running."
    } else {
        $output += " Splunk process is not running."
    }

    # Append the output for the current server to the combined output
    $combinedOutput += $output
}

# Write the combined output to the file, each entry on a new line
$combinedOutput | Out-File -FilePath $outputFile -Append
