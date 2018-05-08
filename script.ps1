<#Lets design a bit more for automation. This takes a static variable for name and can write to a log what the status of that service
is without needing any user intervention. This means that it could be run from Task Scheduler or triggered otherwise
#>


$log = "C:\TTL\log.txt"
$name = "BITS"

$service = Get-Service $name 
        
    If ($service.status -eq "Running") {
        
        Write-Output "The service $name is running" | Out-File $log -Append }
        
    Else {
        
        Write-Host "The service $name is not running" | Out-File $log }

Invoke-item $log