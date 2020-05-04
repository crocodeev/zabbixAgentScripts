$firewall=Get-NetFirewallProfile 
$firewallServiceStatus=get-service -Name MpsSvc | foreach {$_.status}

$counter


forEach($fire in $firewall ){

    if($fire.Enabled){
   
        $counter++
    }

}




if($counter -ge 3 -and $firewallServiceStatus -eq "Running"){

Return 1

}else{

Return 0

}