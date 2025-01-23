# Check  installed
$splunkInstalled = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "Splunk*" }

# Check process is running
$splunkProcessRunning = Get-Process -Name splunkd -ErrorAction SilentlyContinue

# Output the results
Write-Host "Server: $env:COMPUTERNAME"
if ($splunkInstalled) {
  Write-Host "  Splunk is installed."
} else {
  Write-Host "  Splunk is not installed."
}

if ($splunkProcessRunning) {
  Write-Host "  Splunk process is running."
} else {
  Write-Host "  Splunk process is not running."
}
