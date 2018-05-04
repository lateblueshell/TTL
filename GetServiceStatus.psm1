<#So, now we have a function that can be used repeatedly within a script. Let's take that one step further
We want to be able to reuse this function across multiple scripts. This way, we could check the status
of a service before we change something. We don't want to have to copy and paste the function into
every script. Plus, if we make an update the function, then it needs to be updated in every script.
Instead, we can save the function as a module by saving as a psm1 instead of ps1. We can then use
Import-Module (modulepath\name) to import the module into our script when the script is run. The module
can also be located in default locations where you don't need to define the path. Now, any updates to
the function will be applied to that script every time it is run

#>
Function Get-ServiceStatus {
    Param(
            [Parameter(Mandatory=$true)]
            [string] $servicename,

            [string] $computername = $env:COMPUTERNAME
        )
        

    $service = Get-Service $servicename -ComputerName $computername
                
    If ($service.status -eq "Running") {
                
        Write-Output "The service $servicename on computer $computername is running"}
                
    Else {
                
        Write-Output "The service $servicename on computer $computername is not running"}
        
    }
        
        
            
        