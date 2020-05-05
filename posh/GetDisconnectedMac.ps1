$mac=(Get-NetAdapter | Where-Object {$_.Status -match "Disconnected" -and $_.Name -notmatch "Loopback" -and $_.Name -notmatch "Blue"} | forEach{$_.MacAddress})
Return $mac