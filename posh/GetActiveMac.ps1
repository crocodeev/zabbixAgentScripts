$mac = (Get-NetAdapter | Where-Object {$_.Status -match "up" -and $_.Name -notmatch "Loopback"} | forEach{$_.MacAddress})

Return $mac