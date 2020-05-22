

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$main                            = New-Object system.Windows.Forms.Form
$main.ClientSize                 = '400,390'
$main.text                       = "zabbixAgentServiceInstaller"
$main.TopMost                    = $false

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "PC NAME"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(14,16)
$Label1.Font                     = 'Microsoft Sans Serif,10'

$pcName                          = New-Object system.Windows.Forms.TextBox
$pcName.multiline                = $false
$pcName.width                    = 302
$pcName.height                   = 20
$pcName.location                 = New-Object System.Drawing.Point(88,12)
$pcName.Font                     = 'Microsoft Sans Serif,10'

$button1                         = New-Object system.Windows.Forms.Button
$button1.text                    = "INSTALL"
$button1.width                   = 375
$button1.height                  = 30
$button1.location                = New-Object System.Drawing.Point(14,46)
$button1.Font                    = 'Microsoft Sans Serif,10'

$button2                         = New-Object system.Windows.Forms.Button
$button2.text                    = "RUN"
$button2.width                   = 375
$button2.height                  = 30
$button2.location                = New-Object System.Drawing.Point(14,86)
$button2.Font                    = 'Microsoft Sans Serif,10'

$button3                         = New-Object system.Windows.Forms.Button
$button3.text                    = "SETUP TASKS"
$button3.width                   = 375
$button3.height                  = 30
$button3.location                = New-Object System.Drawing.Point(14,126)
$button3.Font                    = 'Microsoft Sans Serif,10'

$button4                         = New-Object system.Windows.Forms.Button
$button4.text                    = "UPDATE"
$button4.width                   = 375
$button4.height                  = 30
$button4.location                = New-Object System.Drawing.Point(14,166)
$button4.Font                    = 'Microsoft Sans Serif,10'

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $true
$TextBox1.width                  = 375
$TextBox1.height                 = 162
$TextBox1.location               = New-Object System.Drawing.Point(14,205)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$main.controls.AddRange(@($Label1,$pcName,$button1,$button2,$button3,$button4, $TextBox1))

$name = $env:COMPUTERNAME

$pcName.Text = $name


$button1.Add_Click({

#change config file

try {

$path = "C:\Zabbix\zabbix_agentd.conf"
 
$content = Get-Content $path

$content[5]= "Hostname=" + $pcName.Text


Set-Content -Value $content -Path $path
$TextBox1.AppendText("CONFIG FILE SUCCESSFULLY CHANGED ")

}

catch 
{

$TextBox1.AppendText("CONFIG FILE PROBLEM ")
$TextBox1.AppendText($error[0].Exception)

}


# allow start Open Hardware Monitor as admin 

try {

  $isPathExist = Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\"
  
  if($isPathExist -eq $true){

  New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\" -PropertyType String -Name "C:\Zabbix\OpenHardwareMonitor\OpenHardwareMonitorReport.exe" -Value "~ RUNASADMIN" -Force
  $TextBox1.AppendText("SET POLICY FOR OHM IS OK ") 

  }else{

  New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\"
  New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\" -PropertyType String -Name "C:\Zabbix\OpenHardwareMonitor\OpenHardwareMonitorReport.exe" -Value "~ RUNASADMIN" -Force
  $TextBox1.AppendText("SET POLICY FOR OHM IS OK ") 


  }  

  

}
catch {

 $TextBox1.AppendText("SETTING ADMIN RIGHTS FOR OPEN HARDWARE MONITOR PROBLEM ")   
 $TextBox1.AppendText($error[0].Exception)

}


#install service


try {

$osArchitecture = (Get-WmiObject  win32_operatingsystem).OSArchitecture

    if($osArchitecture -eq "64-bit"){

    C:\Zabbix\64\zabbix_agentd.exe -i -c "C:\Zabbix\zabbix_agentd.conf"

    }else{
    
    C:\Zabbix\32\zabbix_agentd.exe -i -c "C:\Zabbix\zabbix_agentd.conf"

    }



} 
catch {

  $TextBox1.AppendText("INSTALL ZBX SERVICE PROBLEM ") 
  $TextBox1.AppendText($error[0].Exception)  

}


})


#run service

$button2.Add_Click({

try{

$isRunning = (Get-Service -Name "Zabbix Agent" | foreach {$_.status})

if($isRunning -eq "Running"){

$TextBox1.AppendText("Service already started") 

} else {

try{

Start-Service -Name "Zabbix Agent"
$TextBox1.AppendText("Service successfully started") 

}
catch{

$TextBox1.AppendText("ERROR WITH SERVICE START") 

}

}


}
catch{

$TextBox1.AppendText("Service didn't install") 

}

})


$button3.Add_Click({

# getActivationStatus


$taskUser = $env:COMPUTERNAME + "\" + $env:USERNAME

try{

#task properties

$timeSpan = New-TimeSpan -Minutes 15
$time = New-ScheduledTaskTrigger -RepetitionInterval $timeSpan -Once -At 00:02
$act = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoLogo -WindowStyle hidden -File C:\Zabbix\posh\GetActivationStatusToDataTXT.ps1"

#registerTask 
Register-ScheduledTask -TaskName "getActivationStatus" -Action $act -Trigger $time -User $taskUser -RunLevel Highest

$TextBox1.AppendText("TASK getActivationStatus SUCCEFULLY REGISTERED...")
}

catch{

$TextBox1.AppendText("CANNOT IMPORT TASK getActivationStatus") 
$TextBox1.AppendText($error[0].Exception)  

} 

# getCPUTemperature

try{
#task properties

$timeSpan = New-TimeSpan -Minutes 5
$time = New-ScheduledTaskTrigger -RepetitionInterval $timeSpan -Once -At 00:05
$act = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoLogo -WindowStyle hidden -File C:\Zabbix\posh\GetCpuTemperatureToDataTXT.ps1"

#registerTask 
Register-ScheduledTask -TaskName "getCPUtemperature" -Action $act -Trigger $time -User $taskUser -RunLevel Highest

$TextBox1.AppendText("TASK getCPUTemperature SUCCEFULLY REGISTERED...")
}

catch{

$TextBox1.AppendText("CANNOT IMPORT TASK getCPUTemperature") 
$TextBox1.AppendText($error[0].Exception)  

}

})


$button4.Add_Click({

$urlNewScripts = "https://nc.inplay.space/index.php/s/PYp55oLD2rSoo4s/download"
$urlUpdateConfig = "https://nc.inplay.space/index.php/s/3JpWbXXJW8JCB8E/download"

try{

    Invoke-WebRequest -Uri $urlNewScripts -OutFile "C:\Zabbix\posh.zip"
    Invoke-WebRequest -Uri $urlUpdateConfig -OutFile "C:\Zabbix\updateStrings.txt"

    Expand-Archive -Path "C:\Zabbix\posh.zip" -DestinationPath "C:\Zabbix\posh" -Force
    Move-Item -Path "C:\Zabbix\posh\posh\*" -Destination "C:\Zabbix\posh" -Force
    Remove-Item -Path "C:\Zabbix\posh\posh"
    

    $configUpdates = Get-Content -Path "C:\Zabbix\updateStrings.txt"
    Add-Content -Path "C:\Zabbix\zabbix_agentd.conf" -Value $configUpdates
  


    Stop-Service -Name "Zabbix Agent"
    Start-Service -Name "Zabbix Agent"

    $TextBox1.AppendText("SUCCESSFULLY UPGRADED")

}catch{

    $TextBox1.AppendText($error[0].Exception)

}


})

$main.ShowDialog()


