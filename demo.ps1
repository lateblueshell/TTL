Return "This is a demo script, please don't just run me"

#region Help

#Help info for the Get-Help command. A bit meta
Get-Help

#Update help on a fresh build for most recent changes. Note, run this later when you have time to let it finish
Update-Help

#Find a list of commands to get help for
Get-Help *log*

#You can see the Verb-Noun setup of commands. This tells us what the command will do, and what it will be doing that action to. Examples:
#Get-EventLog
#Clear-EventLog

#Get help for a specific command. We can see a description of what the command does, Syntax including required parameters and related commands
Get-Help Get-Eventlog

#View additional help including examples of command. This is very similar to the online help
Get-Help Get-Eventlog -Full

#Online help
Start-Process -Path https://docs.microsoft.com/en-us/powershell/module/

#endregion

#region Learn about commands

#Learn more about Get-Command
Get-Help Get-Command

#Find commands related to an action
Get-Command *log*

#Narrow down the search
Get-Command *eventlog*

#If interested, here is the list of approved verbs that should be used by commands https://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx

#Get information about the Get-EventLog command
Get-Command Get-EventLog

#View list of additional information about Get-EventLog. Note that only LogName parameter is required
Get-Command Get-EventLog | Format-List

#Test required parameter
Get-EventLog

#Run with that parameter already specified
Get-EventLog -LogName "Application"

#Use additional parameters to narrow down what you get back
Get-EventLog -LogName "Application" -Newest 10 

#Use parameters to narrow down the event you are looking for
Get-EventLog -LogName "System" -Newest 10 -InstanceId "1500"

#By default, not all properties are shown. We can see all by piping this to Format-List, or fl. More on this later
Get-EventLog -LogName "Application" -Newest 1 | Format-List

#Powershell isn't just used for your local computer. Reaching out to another server to get the event log
Get-EventLog -LogName "System" -ComputerName server1

#Get-eventlog allows for multiple values for the ComputerName parameter
Get-EventLog -LogName "System" -ComputerName server1,server2 

#Switches do not require a value, by specifying the switch it is used
Get-EventLog -LogName "System" -ComputerName server1,server2 -Verbose


#endregion

#region Working with files

#Create a new empty directory
New-Item -Path C:\ -Name "TTL" -ItemType "directory"

#Check directory properties
Get-Item -Path "C:\TTL"

#Create a couple files for example
New-Item -Path "C:\TTL\" -Name "TTL.csv"

New-Item -Path "C:\TTL\" -Name "TTL2.csv"

New-Item -Path "C:\TTL\" -Name "TTL3.csv"

New-Item -Path "C:\TTL\" -Name "TTL.txt"

New-Item -Path "C:\TTL\" -Name "TTL.docx"

New-Item -Path "C:\TTL\" -Name "TTL.xlsx"

#Check items in our directory
Get-ChildItem -Path "C:\TTL"

#Get only csv files in our directory
Get-ChildItem -Path "C:\TTL" -Filter "*.csv"

#Create second directory
New-Item -Path "C:\" -Name "TTL2" -ItemType "directory"

#Get all csv files in first directory and move them to the second directory
Get-ChildItem -Path "C:\TTL" -Filter "*.csv" | Move-Item -Destination "C:\TTL2\"

#Check first directory
Get-ChildItem -Path "C:\TTL"

#Check second directory
Get-ChildItem -Path "C:\TTL2"

#Cleanup our second directory including all files and do not prompt about removal
Remove-Item -Path "C:\TTL2" -Recurse -Confirm:$false
#endregion

#region pipeline service

#Check all services on this computer (or other computer using -ComputerName)
Get-Service

#Check properties of a service
Get-Service -Name BITS

#Use pipeline to check extended properties of a service
Get-Service -Name BITS | Format-List

#Use pipeline to sort all services by the Status property of that service
Get-Service | Sort-Object -Property Status

#Find all services that are currently running
Get-Service  | Where-Object {$_.Status -eq "Running"} 

#Find all services that are stopped, then start those services
Get-Service | Where-Object {$_.Status -eq "Stopped"} | Start-Service

#Real world example - specific service that I know should be running is stopped on boot. Automatically start that service

Get-Service -Name MBAMAgent | Stop-Service

Get-Service -Name MBAMAgent

Get-Service -Name MBAMAgent | Where-Object {$_.Status -eq "Stopped"} | Start-Service

Get-Service -Name MBAMAgent | Stop-Service

#endregion

#region Pipeline export

#Get all security log events after yesterday
Get-EventLog -LogName Security -After (Get-date).AddDays(-1)

#Get events after yesterday and export to csv file
Get-EventLog -LogName Security -After (Get-date).AddDays(-1) | Export-Csv c:\TTL\SecurityLog.csv

#Open default program for csv files (Excel/Notepad) to examine the csv file
Invoke-Item C:\TTL\SecurityLog.csv

#Import Security logs from csv file to work with
Import-Csv C:\TTL\SecurityLog.csv
#endregion

#region Objects

#Visually show the object returned from Get-Process. This is a great way to understand the object rows and property columns
get-process | Out-GridView

#Look at the objects and methods available for Get-Process
Get-Process | Get-Member

#Narrow down the properties returned from the original object
Get-Process | Select-Object ProcessName, VM

#Since the output we get is processed from right to left, we can get processes, 
#select two properties of them, then sort by one of those properties
Get-Process | Select-Object ProcessName, VM | Sort-Object VM -Descending

#Looking at the object in the pipeline we can see that we have narrowed down the methods and properties that are available
Get-Process | Select-Object ProcessName, VM | Sort-Object VM -Descending | Get-Member

#Export or Out commands should always come last. The object we have in the pipeline is now exported to text and stored. No methods left
Get-Process | Select-Object ProcessName, VM | Sort-Object VM -Descending | Export-Csv C:\TTL\ProcessName.csv

#endregion

#region Filter

#filter left, filter early
Get-CimInstance -class Win32_NetworkAdapterConfiguration -Filter "IpEnabled = 'True' " 

#filter, then filter out of the pipeline
Get-CimInstance -class Win32_NetworkAdapterConfiguration -Filter "IpEnabled = 'True' " | Where-Object {$_.Description -like "*ThinkPad*" }

#comparisons
5 -eq 5

"Name" -eq "Name"

"Name" -eq "Number"

"Name" -ne "Number"

"This is a bunch of text" -like "*tex*"

#comparing multiple statements
5 -lt 7

(5 -lt 7) -and (7 -lt 10)

(5 -lt 7) -and (7 -lt 5)

#endregion

#region More filtering

#Going to connect to resources out of this presentation for a more practical example. You can't run these, but can reference later
#Import AD module to run AD commands locally
Import-Module ActiveDirectory

#Can get help for imported commands from module
Get-Help Get-ADUser -Full

#Filter left, filter early again. We can use filter in a useful AD scenario, like finding all my SCCM service accounts
Get-ADUser -Filter 'Name -like "*_sccm*"'

#Filter out my SCCM service accounts, then present in a easy to read format with just the properties I'm looking for
Get-ADUser -Filter 'Name -like "*_sccm*"' | Format-Table Name,Samaccountname

#Make a group for example
New-ADGroup -Name "SCCM Service Accounts" -SamAccountName SCCMServiceAccounts -GroupCategory Security -GroupScope Global -DisplayName "SCCM Service Accounts" -Path "OU=TTL,DC=hq,DC=iu13,DC=local"

#Find all SCCM service accounts, then add each one to the new group
Get-ADUser -Filter 'Name -like "*_sccm*"' | Add-ADPrincipalGroupMembership -MemberOf "SCCM Service Accounts"

#Filter early for job title. We could use this on any property that user accounts have, then perform a bulk action on those accounts
Get-ADUser -Filter {Title -like "Test Student"}

#Alternate way we could filter. This grabs all users and properties and then checks the title. This doesn't work though, why?
Get-ADUser -Filter * | Where-Object {$_.Title -like "Test Student"}

#This correctly runs
Get-ADUser -Filter * -Properties Title | Where-Object {$_.Title -like "Test Student"}

#Why do we filter early? Speed. Measure the time it takes to run this command
Measure-Command {Get-ADUser -Filter {Title -like "Test Student"}}

#Measure time for filtering after all objects are returned
Measure-Command {Get-ADUser -Filter * -Properties Title | Where-Object {$_.Title -like "Test Student"}}

#Narrow down what you are looking for then find
Get-ADUser -SearchBase "OU=TTL,DC=hq,DC=iu13,DC=local" -Filter *
#endregion

#region Variables

#Everything is an object. Note the different methods available to a string
"string of text" | Get-Member

#Variables are easily assignable. That variable then has methods and properties available
$text = "string of text"

#Now we can apply methods to the object directly. We could save the variable in its new state by doing $text = $text.ToUpper()
$text.ToUpper()

#Another method test
$text.Substring(3)

#This uses the Windows environmental variable for your computer name. 
#Not much to do with powershell, but I don't have to worry about hardcoding a value for you to run
$env:COMPUTERNAME

#We can assign the variable so that we can use $computer whenever computer name is needed
$Computer = $env:COMPUTERNAME

#Now we can run commands using the variable instead of typing name every time. This gets more important with multiple values or loops
Get-CimInstance win32_computersystem -ComputerName $computer

#Assigning a numerical value to a variable
$number = 7

#What type is the variable?
$number | Get-Member

#Clear out the variable
$number = $null

#Declaring it as an integer and assigning a value
[int]$number = 7

#Now it is showing as System.Int32 and we can perform math if we wanted
$number | Get-Member

#Math
$number * 8

#We can assign multiple values to a variable. Just need to separate the values with commas. 
$computers = 'server1', 'server2', 'server3'

#Multiple values!
$computers

#Loop through and change all computer names to upper case
$computers | ForEach-Object {$_.ToUpper()}

#Again, methods can be performed directly on the variable since it is an object
$computers.ToUpper()

#We can store entire result sets in a variable. Think like a table that we can access
$services = Get-Service

#This allows us to check all "rows" int eh table for a service with Name of BITS. Then we can pipe those results into disabling that service
$services | Where-Object {$_.Name -eq "BITS"} | Set-Service -StartupType "Disabled"

#Ok let's not screw up your computer, revert that change.
$services | Where-Object {$_.Name -eq "BITS"} | Set-Service -StartupType "Automatic"
    
#Clear out variable
$services = $null

<#Remember how we import data from a spreadsheet earlier? Previously we could really just look at it. Now we can work with that data
Here is the service name and Virtual Memory all stored in an object we can work with. 
#>

$services = Import-Csv "C:\TTL\ProcessName.csv"

#endregion

#region Output/Logging

#Set a variable for a log file
$log = "C:\TTL\log.txt"

#Lets use variables for a reusable script. This prompts a user to enter a computer name and spits back out the name. Run both lines together
$name = Read-Host "Enter a computer name"
Write-Host $name

<#Ok, that works but Write-Host is not a great way to display text. As Don Jones famously said, it kills puppies. 
Further reading on that one https://blogs.technet.microsoft.com/heyscriptingguy/2015/07/04/weekend-scripter-welcome-to-the-powershell-information-stream/
Instead, we can use Write-Output
#>

$name = Read-Host "Enter a computer name"
Write-Output $name

#Lets explore what happens. 

$name_output = $name + "_output"
$name_host = $name + "_host"

$name_output
$name_host

#Take those same commands and drop them to a log file as a script would do. What's the difference?
Write-Output $name_output | Out-File $log -Append
Write-Host $name_host | Out-File $log -Append

#Open the log to check
Invoke-Item $log


#endregion

#region Building a script

<#So how would you use something like this? Here is a script that you could save as a ps1. Then a user could run it, answer the service name
 and then get the status of that service
#>

 $name = Read-Host "Enter a service name"
$service = Get-Service $name 

     If ($service.status -eq "Running") {

         Write-Host "The service is running"} 

    Else {

        Write-Output "The service is not running"}

<#Lets design a bit more for automation. This takes a static variable for name and can write to a log what the status of that service
is without needing any user intervention. This means that it could be run from Task Scheduler or triggered otherwise
#>

$name = "BITS"
$service = Get-Service $name 
        
    If ($service.status -eq "Running") {
        
        Write-Output "The service $name is running" | Out-File $log -Append }
        
    Else {
        
        Write-Output "The service $name is not running" | Out-File $log }

Invoke-item $log

<#Parameterize the script. So we have a script that can perform an action on a hard coded variable. How could we expand this to do more?
We can add parameters to accept input without needing Read-Host. We'll take the variable and turn it into a parameter
#>


Param(
        [string] $servicename
)

$log = "C:\TTL\log.txt"
$service = Get-Service $servicename 
        
    If ($service.status -eq "Running") {
        
        Write-Output "The service $servicename is running" | Out-File $log -Append }
        
    Else {
        
        Write-Output "The service $servicename is not running" | Out-File $log }

Invoke-item $log

<#Great. Now we have a powershell script that we can save somewhere and run to get the status of any service we would like. What's next?
Well, what if we have a list of services? What if we want to run this more than once in a script? Lets make it resuable
We can do that using a function. A function is saved in memory while the script executes and can be reused as many times as we'd like
Functions are assigned a name using the same Verb-Noun nomenclature that we've seen from standard powershell commands. 
Warning, scope
#>

Function Get-ServiceStatus {
Param(
        [string] $servicename
)

$log = "C:\TTL\log.txt"
$service = Get-Service $servicename 
        
    If ($service.status -eq "Running") {
        
        Write-Output "The service $servicename is running" | Out-File $log -Append }
        
    Else {
        
        Write-Output "The service $servicename is not running" | Out-File $log }



    }

    Get-ServiceStatus -servicename BITS
    Invoke-item $log

<#Ok, lets refine that function a bit. Currently its running against the local computer with the service we supply
However, if we run it without a service then it the function will fail. We can require a parameter
to be entered so that it doesn't fail. Also, we add a parameter for computer name so that this
could be run against another computer.
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
        
        
            
        
    Get-ServiceStatus -servicename BITS -computername $env:COMPUTERNAME


#endregion

#region Converting to Module
<#So, now we have a function that can be used repeatedly within a script. Let's take that one step further
We want to be able to reuse this function across multiple scripts. This way, we could check the status
of a service before we change something. We don't want to have to copy and paste the function into
every script. Plus, if we make an update the function, then it needs to be updated in every script.
Instead, we can save the function as a module by saving as a psm1 instead of ps1. We can then use
Import-Module (modulepath\name) to import the module into our script when the script is run. The module
can also be located in default locations where you don't need to define the path. Now, any updates to
the function will be applied to that script every time it is run #>

Import-Module C:\git\TTL\GetServiceStatus.psm1

Get-ServiceStatus -servicename BITS 

#endregion

#region Cleanup

#It's rude to make people create files and folders and not clean them up

Remove-Item -Path "C:\TTL" -Recurse -Force
Remove-Item -Path "C:\TTL2" -Recurse -Force

#endregion