$isactivate=((Get-Service -Name WinDefend | foreach {$_.status}) -and (Get-MpComputerStatus | foreach{$_.RealTimeProtectionEnabled}))

if($isactivate){

Return 1

}else{

Return 0

}
