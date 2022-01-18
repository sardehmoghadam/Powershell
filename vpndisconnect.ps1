$state = $true  
While ($state) {
    $vpnName = "VPS";
    $vpn = Get-VpnConnection -Name $vpnName;
    if($vpn.ConnectionStatus -eq "Disconnected"){
    <# $wshell = New-Object -ComObject Wscript.Shell
    $wshell.Popup("VPN Disconnected",0,"Done",0x1) #>
    Disable-NetAdapter -Name "Wi-Fi" -Confirm:$false
    $state = $false
    }       
}
