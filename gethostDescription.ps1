$ServerName = Get-Content "e:\powershell\Servers.txt"  
  
foreach ($Server in $ServerName) {  
  Get-ADComputer -Identity $Server -Properties * | FT Name,Description   
          
}

 