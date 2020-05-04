$isactivate=(Get-WmiObject -Class SoftwareLicensingProduct | where PartialProductkey | Where-Object -Property Name -Match "Windows" | foreach {$_.LicenseStatus})

$file="C:\Zabbix\posh\data.txt"

$content=(Get-Content $file)

$content[1]=$isactivate

Set-Content -Value $content -Path $file
