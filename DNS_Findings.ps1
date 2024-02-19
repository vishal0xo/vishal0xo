$serverListFile = "C:\Users\vm\Desktop\Scripts\list.txt"
$outputFile = "C:\Users\vm\Desktop\Scripts\output.txt"

$compnames = Get-Content $serverListFile

foreach($comp in $compnames){
    try{
     $Compnames = write-output "Retrive DNS for the servers $comp"
     $Dnsname= Resolve-DnsName -Name $comp -ErrorAction stop


     $compnames | Out-File -FilePath $outputFile -Append
     $Dnsname | Out-File -FilePath $outputFile -Append
} catch {
     $Compnames = write-output "Failed to retrieve DNs info for $comp"
     $compnames | Out-File -FilePath $outputFile -Append
}
}