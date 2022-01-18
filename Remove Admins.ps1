$ServerName = Get-Content "e:\powershell\servers.txt"
$users = Get-Content "E:\powershell\users.txt"
  

foreach ($Server in $ServerName) {  
  	$Computer = [ADSI]("WinNT://$Server,computer")
	$Group = $Computer.PSBase.Children.Find("Administrators")
	ForEach ($User in $users)
		{   $Group.Remove("WinNT://$User")
		}     
          
} 


