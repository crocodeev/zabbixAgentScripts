
try{


$isactivate=((Get-Service -Name WinDefend -ErrorAction SilentlyContinue | foreach {$_.status}) -and (Get-MpComputerStatus | foreach{$_.RealTimeProtectionEnabled}))

if($isactivate){

Return 1

}else{

Return 0

}

}catch{

Return 0

}



