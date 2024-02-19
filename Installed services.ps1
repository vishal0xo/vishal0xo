$serverListFile = "C:\Scripts\Test_script\list.txt"
$serverNames = Get-Content $serverListFile

foreach ($server in $serverNames){

Write-output "Server Name: $server `n" 



Invoke-Command -ComputerName  $server -ScriptBlock {


Write-output "`nServices running using Domain Service Account "
Write-output "______________________________________________ "

Get-WmiObject -Class Win32_Service | Where-Object {$_.StartName -notlike '*localsystem*' -and $_.StartName -notlike '*NetworkService*' -and $_.StartName -notlike '*LocalService*' } | Select-Object -Property  Name, StartName | Format-Table

Write-output "`nRoles Installed "
Write-output "______________________________________________ "

Get-WindowsFeature | Where-Object { $_.Installed -eq $true -and $_.FeatureType -eq "Role" } | Select-Object -ExpandProperty DisplayName

Write-output "`n`nWebsites hosted on IIS "
Write-output "______________________________________________ `n"

$features = Get-WindowsFeature
$installed = $features | Where-Object { $_.Name -eq 'Web-Server' -and $_.Installed }

if ($installed) {
#Write-Output "IIS is installed."

$Sites = Get-Website
foreach ($Site in $Sites) {
Write-output "Website: $($Site.Name)"
#Write-output "Physical Path: $($Site.PhysicalPath)"
#Write-output "Bindings: $($Site.Bindings.Collection)"
Write-output " "
}
} else {
#Write-Output "IIS is not installed."
}

Write-output "`nSMB Shares"
Write-output "______________________________________________ "

$features1 = Get-WindowsFeature
$installed1 = $features1 | Where-Object { $_.Name -eq 'FileAndStorage-Services' -and $_.Installed }

if ($installed1) {

Get-SmbShare | Select-Object Name, Path | Format-Table

}

Write-output "`nUsers who have Administrator access"
Write-output "______________________________________________ "

$adminGroup = [ADSI]"WinNT://./Administrators,group"
$members = $adminGroup.Invoke("Members") | foreach {
$user = [ADSI]$_.GetType().InvokeMember("Adspath", 'GetProperty', $null, $_, $null)

 

#$user.FullName
$u = $user.FullName
$u.replace("over","")
 
}
Write-output "-----------------------------------------------`n"
return $members


 

$members 



}}