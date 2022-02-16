$Servers = Get-ADComputer -Filter * 

$users = @(
    'guest'
    'administrator'
    )

$Groups = @(
    'administrators'
    'Remote Desktop Users'
    )  

foreach ($Server in $Servers) {  
  	$Computer = [ADSI]("WinNT://$Server.name,computer")
	foreach ($Group in $Groups) {

        $LocalGroup = $Computer.PSBase.Children.Find($Group)
	    ForEach ($User in $users)
		    {   $LocalGroup.Remove("WinNT://$User")
		    }     
     }     
} 


