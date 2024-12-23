$websites = @(
    @{url="http://xxxxxxxxxxx/mobiledoc/jsp/webemr/login/newLogin.jsp"; content="Enter username to continue"},
    @{url="http://xxxxxxxxxxx/mobiledoc/jsp/webemr/login/newLogin.jsp"; content="Enter username to continue"},
    @{url="http://xxxxxxxxxxx/mobiledoc/jsp/webemr/login/newLogin.jsp"; content="Enter username to continue"},
    @{url="http://xxxxxxxxxxx/mobiledoc/jsp/webemr/login/newLogin.jsp"; content="Enter username to continue"},
    @{url="http://xxxxxxxxxxx/mobiledoc/jsp/webemr/login/newLogin.jsp"; content="Enter username to continue"},
    @{url="http://xxxxxxxxxxx/mobiledoc/jsp/webemr/login/newLogin.jsp"; content="Enter username to continue"}
)
 
foreach ($site in $websites) {
    try {
        $response = Invoke-WebRequest -Uri $site.url -UseBasicParsing
        if ($response.StatusCode -eq 200 -and $response.Content -match $site.content) {
            Write-Output "$($site.url) is up and content matches."
        } else {
            Write-Output "$($site.url) is down or content does not match."
            #Send-MailMessage -From "your-email@example.com" -To "recipient@example.com" -Subject "Site Check Failed" -Body "$($site.url) is down or content does not match." -SmtpServer "smtp.example.com"
        }
    } catch {
        Write-Output "$($site.url) is down. Error: $_"
        #Send-MailMessage -From "your-email@example.com" -To "recipient@example.com" -Subject "Site Check Failed" -Body "$($site.url) is down. Error: $_" -SmtpServer "smtp.example.com"
    }
}
