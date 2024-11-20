$server = Read-Host "Is this for a single server? (yes/no)"
if ($singleServer -eq "yes") {
    $serverInput = Read-Host "Enter server name"
    $serverNames = $serverInput -split ','
} else {
    $serverListFile = "C:\Scripts\Test_script\list.txt"
    $serverNames = Get-Content $serverListFile
}
foreach ($server in $serverNames) {
    Write-Output "Server Name: $server `n" 

    Invoke-Command -ComputerName $server -ScriptBlock {
        Get-WinEvent -FilterHashtable @{LogName='Security';ID=4624;StartTime=(Get-Date).AddHours(-1)} | ForEach-Object {
            $_.Properties[5].Value
        }
    }
}
