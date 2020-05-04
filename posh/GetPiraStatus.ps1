$isexist=( Get-Process | Where-Object -Property ProcessName -Match "piraside")

if($isexist -ne $null){
 Return 1
}else{
 Return 0   
}

