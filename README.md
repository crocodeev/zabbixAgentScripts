# zabbixAgentScripts

scripts that I use with active zabbix agent v1 to get some values from windows machines

## project structure

folder **C:\Zabbix** which contain

* /bin - addition .exe files
* /conf - addition config files, which can be included in main config file
* /OpenHardwareMonitor - Open Hardware Monitor files, which included cli  * OpenHardwareMonitorReport.exe
* /posh - custom powershell scripts
* Install.ps1 - main script for simple agent install
* runAs.reg - add "run as admin" for .ps1 in context menu
* setExecutionPolicy.bat - script that allow to start .ps1 scripts
* zabbix_agentd.conf - main config file
* zabbix_agentd.conf.back - template config template
* zabbix_agentd.exe - zabbix agent service


## Installation Guide

* edit config file, e.g. change **ServerActive=xxx.xxx.xxx**
* run **setExecutionPolicy.bat** as admin
* merge runAs.reg it's enable "run as admin" in context menu for powershell scripts
* right click on "Install.ps1" "run as admin"
* ![Install script window](https://github.com/crocodeev/zabbixAgentScripts/blob/master/img/img.txt)
 

