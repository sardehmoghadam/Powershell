$Groups = Get-ADGroup -Filter * -Properties cn
 

foreach ($Group in $Groups) { 
         
        $Groupname = $Group.cn
        Write-host "Members of $Groupname :" 
        write-host
        Get-ADGroupMember -identity $Group.cn | select name  
        write-host  
        write-host "---------------------------------------"  
} 
