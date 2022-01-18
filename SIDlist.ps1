Get-ADUser -Filter {Enabled -EQ $True} -Properties * | Select-Object -Property SID, SamAccountName, displayName | Export-Csv -Path C:\ADUser -NoTypeInformation -Force
Get-ADUser -Identity User -Properties * | FL SID, SamAccountName
