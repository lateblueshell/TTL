#Parameterize the script. So we have a script that can perform an action on a hard coded variable. How could we expand this to do more?
#We can add parameters to accept input without needing Read-Host. We'll take the variable and turn it into a parameter

Param(
        [string] $servicename
)

$log = "C:\TTL\log.txt"
$service = Get-Service $servicename 
        
    If ($service.status -eq "Running") {
        
        Write-Output "The service $servicename is running" | Out-File $log -Append }
        
    Else {
        
        Write-Host "The service $servicename is not running" | Out-File $log }

Invoke-item $log