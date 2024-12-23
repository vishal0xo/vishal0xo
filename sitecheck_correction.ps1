$websites = @(
    @{url="https://www.google.com/"; content="Google"}
)
 
foreach ($site in $websites) {
    try {
        $response = Invoke-WebRequest -Uri $site.url -UseBasicParsing
        if ($response.StatusCode -eq 200 -and $response.Content -match $site.content) {
            Write-Output "$($site.url) is up and content matches."
        } else {
            Write-Output "$($site.url) is down or content does not match."
            #Get-Service "WlanSvc" | Sort-Object status
            #Send-MailMessage -From "your-email@example.com" -To "recipient@example.com" -Subject "Site Check Failed" -Body "$($site.url) is down or content does not match." -SmtpServer "smtp.example.com"
        }
        
    }catch {
        Write-Output "$($site.url) is down. Error: $_"
        if(Get-Service -Name "WLAN AutoConfig" | Where-Object { $_.Status -eq "stopped" }) {
                Start-Service -Name "WLAN AutoConfig"
                Write-Output "WLAN AutoConfig service started."
            } else {
                Stop-Service -Name "WLAN AutoConfig" -Force
                Start-Service -Name "WLAN AutoConfig"
                Write-Output "WLAN AutoConfig service restarted."
            }
     }
    }


else {
Stop-Process -Name "WLAN AutoConfig" -Force 
Get-Service -Name "WLAN AutoConfig" | Restart-Service 
Write-Output "WLAN AutoConfig service restarted."
}
