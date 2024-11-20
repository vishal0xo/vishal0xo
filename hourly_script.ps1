Get-WinEvent -FilterHashtable @{LogName='Security';ID=4624;StartTime=(Get-Date).AddHours(-1)} | ForEach-Object {
    $_.Properties[5].Value
}
