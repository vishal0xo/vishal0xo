# Retrieve a single event for inspection
$event = Get-WinEvent -FilterHashtable @{LogName='Security';ID=4624} -MaxEvents 1

# Examine the properties
$event.Properties | ForEach-Object {
    $_.Value
}
