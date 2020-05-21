$vendor=(Get-WmiObject -Class win32_computersystem | foreach{$_.Manufacturer})
Return $vendor