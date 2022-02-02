# This is the summary of GIAC document about Hunting and Gathering with Powershell
# you can access to the full version of the document by this link: https://www.giac.org/paper/gsec/23549/hunting-gathering-powershell/121279

<# Following are some important tips to consider when working with PowerShell scripts:
    1. Prior to writing a script, use the interactive shell to learn and explore which
    cmdlets are to be used.
    2. For each cmdlet used, understand the input parameters and how outputted results
    are to be handled.
    3. Consider error and exception handling in your scripts.
    4. Never put login credentials in a script! This also applies to any readable file the
    script may reference.
    5. Test the script against a handful of machines prior to running against an entire
    enterprise.
    6. Execution of PowerShell scripts are blocked by default.
#>

<# Below is a listing of all current settings supported by this policy with a brief description (“Set-ExecutionPolicy”, 2018).
    ● Restricted - Does not load configuration files or run scripts. Restricted is the
    default execution policy.
    ● AllSigned - Requires that all scripts and configuration files be signed by a trusted
    publisher, including scripts that you write on the local computer.
    ● RemoteSigned - Requires that all scripts and configuration files downloaded
    from the Internet be signed by a trusted publisher.
    ● Unrestricted - Loads all configuration files and runs all scripts. If you run an
    unsigned script that was downloaded from the Internet, you are prompted for
    permission before it runs.
    ● Bypass - Nothing is blocked and there are no warnings or prompts.
    ● Undefined - Removes the currently assigned execution policy from the current
    scope. This parameter will not remove an execution policy that is set in a Group
    Policy scope
    
#>

<# ----------------------Getting started with Powershell--------------------------#>

# To view the current state of this policy

    Get-ExecutionPolicy

# To change an execution policy

    Set-ExecutionPolicy Unrestricted

# Determining the PowerShell Version

    $PSVersionTable
 
<# ----------------------Gathering with Powershell-------------------------------- #>

# To get a listing of local users on a given system

    Get-LocalUser

# To get a listing of local users on a given system s that are currently “enabled”

    Get-LocalUser | where Enabled -eq $True
    
# To get a listing a local groups on a given system

    Get-LocalGroup
    
# To get members of a given group

    Get-LocalGroupMember Administrators
    
# To obtain a list of all users that are marked as “enabled” in AD

    Get-ADUser -Filter 'Name -Like "*"' | where Enabled -eq $True
    
# To btain a list of accounts from a group in AD which are categorized as “user”    

    Get-ADGroupMember Administrators | where objectClass -eq 'user' 

# To get a listing of all “enabled” computers with their associated operating system

    Get-ADComputer -Filter "Name -Like '*'" -Properties * | where Enabled -eq $True | Select-Object Name, OperatingSystem, Enabled
    
# To represents products as they are installed by Windows Installer

    Get-CimInstance -ClassName win32_product
    
# The Select-Object cmdlet can be used for a more refined output

    Get-CimInstance -ClassName win32_product | Select-Object Name,Version,Vendor, InstallDate, InstallSource, PackageName, LocalPackage
    
# If the program installed as a 64-bit application, the listing will be found under

    Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\" | Where DisplayName -Like "google"
    
# To get the OS release version on the current system

    Get-ItemProperty "HKLM:\software\Microsoft\Windows NT\CurrentVersion\"
    
# Gathering a list of hotfixes

    Get-HotFix
    
# To get the services on the local computer

    Get-Service
    
# To get the services running on the local computer with selected objects in table format

    Get-Service| where Status -eq Running | Select-Object Name,DisplayName,Dependentservices,status,startType | Format-Table -AutoSize -wrap -GroupBy status
    
# To get more information about services rather than Get-service

    Get-CimInstance -ClassName Win32_Service | Select-Object Name, DisplayName, startmode, State, Pathname, Startname, ServiceType
    
# Understanding local and domain policies

    Get-ADDefaultDomainPasswordPolicy

    Get-ADDefaultDomainPasswordPolicy -Current LoggedOnUser

    Get-ADDefaultDomainPasswordPolicy -Current LocalComputer

    Get-gpo -all | Format-Table -AutoSize

    Get-GPOReport -Name "password policy" -ReportType html > "C:\temp\export.html"

    Get-GPOReport -Name "password policy" -ReportType html -Path "C:\temp\export.html"

    Get-GPResultantSetOfPolicy -user <user> -computer <computer> -Reportype html -path "C:\temp\rsop.html"
    
<# ----------------------PowerShell for the Hunter and Responder-------------------------------- #>

# Logged-On User

     Get-CimInstance –ClassName Win32_ComputerSystem | Select-Object Name, UserName, PrimaryOwnerName, Domain, TotalPhysicalMemory, Model, Manufacturer
     
# Network Activity
  
     Get-NetTCPConnection -RemoteAddress 52.46.157.11 -RemotePort 8080
     
# Running processes

    Get-Process | Select-Object StartTime, ProcessName, ID, Path | where id -eq 9320
    
    Get-CimInstance -ClassName Win32_Process | Select-Object CreationDate, ProcessName, ProcessID, CommandLine, ParentProcessid | where processid -eq 9320
    
# Scheduled Tasks and Scheduled Jobs

     Get-ScheduledTask | Select-Object TaskName, TaskPath, Date, Author, Actions, Triggers, Description, State | where Author -NotLike 'Microsoft*' | where Author -ne $null | where Author -NotLike '*@%SystemRoot%\*'
     
     Export-ScheduledTask -TaskName updater1
    
# File Hashing

     Get-FileHash .\notes.txt -Algorithm MD5
        
# File Analysis, and Alternate Data Streams

     Get-Item .\note.txt -Stream *
        
     Get-Item .\note.txt -Stream * | where Stream -ne ':$DATA'
         
     Get-Content .\notes.txt -Stream SoupDuJour
          
# Raw File Analysis

      Get-Content .\ps.txt –Encoding Byte | Format-Hex
      
      $magicBytes = '{0:X2}' -f (Get-Content .\ps.txt -Encoding Byte -ReadCount 4)

# Regular Expressions

      Get-Content .\file.bin | Select-String '[A-Za-z0-9\/\+]{1024,}[=]{0,2}'
  
      $filecontent = Get-Content .\file.bin   
      $filecontent -cmatch '[A-Za-z0-9\+\/]{1024,}[=]{0,2}'
      
# Encoded Data - Base64

      $encoded = "R2V0LUZpbGVIYXNoIC5cbm90ZXMudHh0IC1BbGdvcml0aG0gTUQ1"
      [System.Text.Encoding]::ascii.GetString([System.Convert]::FromBase64String($encoded))
      ([System.Convert]::FromBase64String($encoded)) | Format-Hex

<# --------------------------------------Conclusion---------------------------------- #>

<# Data collection is at the heart of every digital investigation to include an incident
    response. Both hunting and gathering can serve as extremely useful techniques that
    ultimately aid the incident responder. Although efforts should be made to automate and
    centralize this effort, some system artifacts will remain on a given host. Handlers can use
    these datasets to build baselines or normalize environmental variables. Additionally, the
    output of a threat hunting engagement can be used to create rules or become building
    blocks for signature development.
    Performing targeted collections with tools like PowerShell, responders can collect
    granular objects that relate to a given event or series of events. The latest in
    PowerShell’s framework is shown to have a treasure trove of capabilities for incident
    response team members. Incident handlers and threat hunters alike can leverage this
    resource to further enrich the information needed to solve complex or compounded
    problems within their computer networks. Finally, tried and tested techniques can be
    encapsulated into scripts that teams can use for repetitive data collection and analysis.

#>
