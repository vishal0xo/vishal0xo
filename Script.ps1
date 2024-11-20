Get-WinEvent -FilterHashtable @{LogName='Security';ID=4624;StartTime=(Get-Date).AddMonths(-3)} | ForEach-Object {
        $_.Properties[5].Value
    }