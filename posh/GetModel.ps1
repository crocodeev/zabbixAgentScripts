﻿$model=(Get-WmiObject -Class win32_computersystem | foreach{$_.Model})
Return $model