$temperature=(C:\Zabbix\OpenHardwareMonitor\OpenHardwareMonitorReport.exe | Select-String -Pattern "temperature/0");
$file="C:\Zabbix\posh\data.txt"

$content=(Get-Content $file)

if($temperature -eq $null ){

    $content[0]="0"
    Set-Content -Value $content -Path $file

}else{

    $content[0]=$temperature[0].Line.Substring(29,2)
    Set-Content -Value $content -Path $file

}
