$osversion=(Get-WmiObject -Class Win32_OperatingSystem | foreach {$_.Version.remove(2)})

Return $osversion