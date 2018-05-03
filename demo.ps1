Return "This is a demo script, please don't just run me"

#region Help

#Help info for the Get-Help command. A bit meta
Get-Help

#Update help on a fresh build for most recent changes
Update-Help

#Find a list of commands to get help for
Get-Help *log*

Get-EventLog

Clear-EventLog

##Verbage shows what the command should do

#Get help for a specific command
Get-Help Get-Eventlog

#View additional help including examples
Get-Help Get-Eventlog -Full

#Online help
https://docs.microsoft.com/en-us/powershell/module/

#endregion

#region Learn about commands

#Learn more about Get-Command
Get-Help Get-Command

#Find commands related to an action
Get-Command *log*

#Narrow down the search
Get-Command *eventlog*

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

#Cleanup our first directory including all files within
Remove-Item -Path "C:\TTL\*" -Recurse

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
Get-Service -Name MBAMAgent | Where-Object {$_.Status -eq "Stopped"} | Start-Service

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

#region Import modules?

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

#Going to connect to resources out of this presentation for a more practical example
Import-Module ActiveDirectory

Get-Help Get-ADUser -Full

Get-ADUser -Filter 'Name -like "*_sccm*"'

Get-ADUser -Filter 'Name -like "*_sccm*"' | Format-Table Name,Samaccountname

New-ADGroup -Name "SCCM Service Accounts" -SamAccountName SCCMServiceAccounts -GroupCategory Security -GroupScope Global -DisplayName "SCCM Service Accounts" -Path "OU=TTL,DC=hq,DC=iu13,DC=local"

Get-ADUser -Filter 'Name -like "*_sccm*"' | Add-ADPrincipalGroupMembership -MemberOf "SCCM Service Accounts"

Get-ADUser -Identity joe_student


#endregion
