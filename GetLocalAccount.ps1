$computers = Get-ADComputer -Filter *

foreach ($computer in $computers) {

    $computername = $computer.Name
    write-host "Local account of $computername :"
    write-host
    Get-WmiObject -ComputerName $computer.name -Class Win32_UserAccount -Filter "LocalAccount=True AND Disabled=False" | select Fullname
    write-host "--------------------------"
}
