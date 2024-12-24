# Define server-to-website mapping
$serverWebsiteMap = @{
    "Server1" = @(@{url="https://www.google.com/"; content="Google"}),
    "Server2" = @(@{url="https://www.zaubacorp.com/company/PINGSERV-SOLUTIONS-LLP/AAG-6493"; content="PINGSERV SOLUTIONS LLP"}),
    "Server3" = @(@{url="https://www.yahoo.com/"; content="yahoo!"})
}

$scriptBlock = {
    param($site)
    try {
        if (Get-Service -Name "WLAN AutoConfig" | Where-Object { $_.Status -eq "stopped" }) {
            Start-Service -Name "WLAN AutoConfig"
            Write-Output "WLAN AutoConfig service started on $using:server."
        } else {
            Stop-Service -Name "WLAN AutoConfig" -Force
            Start-Service -Name "WLAN AutoConfig"
            Write-Output "WLAN AutoConfig service restarted on $using:server."
        }
    } catch {
        Write-Output "Failed to manage WLAN AutoConfig service on $using:server. Error: $_"
    }
}

foreach ($server in $serverWebsiteMap.Keys) {
    foreach ($site in $serverWebsiteMap[$server]) {
        try {
            $response = Invoke-WebRequest -Uri $site.url -UseBasicParsing
            if ($response.StatusCode -eq 200 -and $response.Content -match $site.content) {
                Write-Output "$($site.url) is up and content matches."
            } else {
                Write-Output "$($site.url) is down or content does not match."
                Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -ArgumentList $site
            }
        } catch {
            Write-Output "$($site.url) is down. Error: $_"
            Invoke-Command -ComputerName $server -ScriptBlock $scriptBlock -ArgumentList $site
        }
    }
}
