$serverListFile = "C:\Scripts\Test_script\list.txt"
$serverNames = Get-Content $serverListFile

foreach ($server in $serverNames) {
    Write-Output "Server Name: $server `n" 

    Invoke-Command -ComputerName $server -ScriptBlock {
        Get-WinEvent -FilterHashtable @{LogName='Security';ID=4624;StartTime=(Get-Date).AddHours(-1)} | ForEach-Object {
            $_.Properties[5].Value
        }
    }
}
