$isactivate=(Get-WmiObject -Class SoftwareLicensingProduct | where PartialProductkey | Where-Object -Property Name -Match "Windows" | foreach {$_.LicenseStatus})

$file="C:\Zabbix\posh\data.txt"

$content=(Get-Content $file)

if($content -eq $null){

 Add-Content -Path $file -Value "0"
 Add-Content -Path $file -Value $content

}else{

 if($content[1] -eq $null){

    Add-Content -Path $file -Value $isactivate

 }else{
    
    $content[1] = $isactivate
    Set-Content -Value $content -Path $file
 }   

}

