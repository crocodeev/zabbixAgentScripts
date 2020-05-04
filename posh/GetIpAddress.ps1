$ipaddress = (Get-NetIPAddress -AddressFamily IpV4 | Where-Object {$_.AddressState -eq "Preferred" -and $_.PrefixOrigin -ne "WellKnown" } | foreach {$_.IpAddress})
Return $ipaddress