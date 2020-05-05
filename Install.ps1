

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$main                            = New-Object system.Windows.Forms.Form
$main.ClientSize                 = '400,300'
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

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $true
$TextBox1.width                  = 375
$TextBox1.height                 = 162
$TextBox1.location               = New-Object System.Drawing.Point(14,125)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$main.controls.AddRange(@($Label1,$pcName,$button1,$button2,$TextBox1))

$name = $env:COMPUTERNAME

$pcName.Text = $name


$button1.Add_Click({

try {

$path = "C:\Zabbix\zabbix_agentd.conf"
 
$content = Get-Content $path

$content[6]=$name.Text

Set-Content -Value $content -Path $path

}
catch 
{

$TextBox1.AppendText($error[0].Exception)

}

try {

Set-ExecutionPolicy RemoteSigned -Force

}

catch{

  $TextBox1.AppendText($error[0].Exception)
}

try {

  New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers\" -PropertyType String -Name "C:\Zabbix\OpenHardwareMonitor\OpenHardwareMonitorReport.exe" -Value "~ RUNASADMIN" -Force

}
catch {

 $TextBox1.AppendText($error[0].Exception)

}


try {

 $exe = "C:\Zabbix\zabbix_agentd.exe"
 $config = "C:\Zabbix\zabbix_agentd.conf"

 & "$exe -c $config -i"

} 
catch {

  $TextBox1.AppendText($error[0].Exception)  

}


try{

$isRunning = (Get-Service -Name "Zabbix Agent" | foreach {$_.status})

if($isRunning -eq "Running"){

$TextBox1.AppendText("Service successfully started") 

} else {


try{

Start-Service -Name "Zabbix Agent"

}
catch{

$TextBox1.AppendText("Service successfully started") 

}


}


}
catch{

$TextBox1.AppendText("Service successfully started") 

}




})


$main.ShowDialog()


