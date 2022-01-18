$ServerName = Get-Content "d:\powershell\IP.txt"  
  
foreach ($Server in $ServerName) {  
  [System.Net.Dns]::GetHostbyAddress($Server)   
          
}

 