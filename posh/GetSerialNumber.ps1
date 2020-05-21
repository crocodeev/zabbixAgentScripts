$serialNumber = (Get-WmiObject -Class win32_bios | foreach {$_.SerialNumber})
Return $serialNumber