#MIM Prereqs + Plus a few extras

import-module ServerManager
Install-WindowsFeature Web-WebServer,Net-Framework-Features,Web-Mgmt-Tools,Windows-Identity-Foundation,Server-Media-Foundation,Xps-Viewer,Telnet-Client,RSAT-Clustering,RSAT-AD-Tools,rsat-ad-powershell,RSAT-ADCS-Mgmt,RSAT-DNS-Server,RSAT-ADCS-Mgmt -includeallsubfeature 

iisreset /STOP
C:\Windows\System32\inetsrv\appcmd.exe unlock config /section:windowsAuthentication -commit:apphost
iisreset /START

