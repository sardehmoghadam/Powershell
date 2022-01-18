$Groups = Get-Content "E:\powershell\Group.txt"  
  
foreach ($Group in $Groups) {  
	write-output {

}
$Group
  	write-output {

}
        Get-ADGroupMember -identity $Group |select name    
          
} 