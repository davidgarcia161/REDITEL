TITLE -- SUPER-SCRIPT --
COLOR 1F

:: -- Cuenta de usuario --

net user Reditel reditel /ADD
robocopy C:\REDITEL\magia-borras\Desktop C:\Users\Default\Desktop /MIR
net user Admin	Overtel$10

:: -- Accesos directos --
robocopy C:\REDITEL\magia-borras\Desktop C:\Users\Default\Desktop
DIR C:\ReditelScan
DIR C:\ControlNet

:: -- Tareas programadas --
schtasks.exe /Create /XML "C:\scripts\Tarea Paco.xml" /tn "Tarea Paco"
schtasks.exe /Create /XML "C:\scripts\Actualizaciones Chocolatey.xml" /tn "Actualizaciones Chocolatey"
schtasks.exe /Create /XML "C:\scripts\GitHub.xml" /tn "GitHub"

:: -- Plan de energía --
powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

:: -- Certificados --
CERTUTIL -f -p icppdv -importpfx "C:\REDITEL\magia-borras\ClientePDV.pfx"
CERTUTIL -p icppdv -importpfx C:\REDITEL\magia-borras\CA_ICP.pfx 
certutil -addstore -enterprise -f "CA" C:\REDITEL\magia-borras\ThawteCSG2.cer

:: -- Instalacion bginfo --
robocopy C:\REDITEL\magia-borras\Bginfo C:\Bginfo /e
copy C:\REDITEL\magia-borras\Bginfo\bginforeditel.lnk "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\bginforeditel.lnk"
c:\bginfo\Bginfo.exe C:\Bginfo\confreditel.bgi /timer:0 /silent /NOLICPROMPT

:: -- Instalacion zabbix --
robocopy C:\REDITEL\magia-borras\zabbix c:\zabbix /e
c:\zabbix\bin\win64\zabbix_agentd.exe -i -c c:\zabbix\conf\zabbix_agentd.win.conf 
c:\zabbix\bin\win64\zabbix_agentd.exe -s

:: -- Java --
C:\REDITEL\magia-borras\Java1_6.exe /s /L C:\logsetup.log

:: -- Chocolatey con todos los programas necesarios --
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco install 7zip -y
choco install libreoffice-fresh -y
choco install pdfcreator -y
choco install googlechrome -y
choco install ammyy-admin -y
choco install lightshot.install -y
choco install flashplayerplugin -y
choco install firefox -y
choco install adobereader -y
choco install owncloud-client -y
choco install tightvnc -y
::choco install avastfreeantivirus -y
ninja-setup-3.2.1.exe /silent /NOLICPROMPT

:: -- Conf ThightVNC --
REGEDIT /S C:\REDITEL\magia-borras\tigh_vnc.reg


:: -- Java noact --
DEL "C:\Program Files (x86)\Common Files\Java\Java Update\jucheck.exe"
DEL "C:\Program Files (x86)\Common Files\Java\Java Update\jusched.exe"

:: -- OneDrive fuera --

set x86="%SYSTEMROOT%\System32\OneDriveSetup.exe"
set x64="%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe"

echo Cerrando OneDrive.
echo.
taskkill /f /im OneDrive.exe > NUL 2>&1
ping 127.0.0.1 -n 5 > NUL 2>&1

echo Desinstalando OneDrive...
echo.
if exist %x64% (
%x64% /uninstall
) else (
%x86% /uninstall
)
ping 127.0.0.1 -n 5 > NUL 2>&1

echo Eliminando archivos residuales...
echo.
rd "%USERPROFILE%\OneDrive" /Q /S > NUL 2>&1
rd "C:\OneDriveTemp" /Q /S > NUL 2>&1
rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S > NUL 2>&1
rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S > NUL 2>&1

echo Eliminando OneDrive del explorador de archivos...
echo.
REG DELETE "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > NUL 2>&1
REG DELETE "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > NUL 2>&1

:: -- Vista de compatibilidad de IE --
SETLOCAL

SET REG="%WINDIR%\system32\reg.exe"
SET TRUSTED_DOMAINS=orange.com
SET TRUSTED_DOMAINS=orange.es
SET TRUSTED_DOMAINS=controlgo.es
SET TRUSTED_DOMAINS=stores.recommerce.com

IF EXIST "%USERPROFILE%\..\Default User\NTUSER.DAT" SET NTUSER="%USERPROFILE%\..\Default User\NTUSER.DAT"
IF EXIST "%USERPROFILE%\..\Default\NTUSER.DAT" SET NTUSER="%USERPROFILE%\..\Default\NTUSER.DAT"
IF DEFINED PROGRAMFILES(x86) SET X64=TRUE

ECHO Adding domains to Intranet Zone for HKEY_LOCAL_MACHINE
FOR %%D IN (%INTRANET_DOMAINS%) DO (
 ECHO -^> %%D
 %REG% add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 1 /f
 %REG% add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 1 /f
 IF DEFINED X64 %REG% add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 1 /f
 IF DEFINED X64 %REG% add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 1 /f 
)

ECHO Adding domains to Trusted Zone for HKEY_LOCAL_MACHINE
FOR %%D IN (%TRUSTED_DOMAINS%) DO (
 ECHO -^> %%D
 %REG% add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 2 /f
 %REG% add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 2 /f
)

IF DEFINED NTUSER ECHO Loading registry defaults for new user from %NTUSER%
IF DEFINED NTUSER %REG% load HKU\.NTUSER %NTUSER%

FOR /f "usebackq tokens=1,2 delims=_" %%A IN (`%REG% query HKU`) DO (
 ECHO Adding domains to Intranet Zone for %%A_%%B
 FOR %%D IN (%INTRANET_DOMAINS%) DO (
  ECHO -^> %%D
  %REG% add "%%A_%%B\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 1 /f
  %REG% add "%%A_%%B\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 1 /f
  IF DEFINED X64 %REG% add "%%A_%%B\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 1 /f
  IF DEFINED X64 %REG% add "%%A_%%B\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 1 /f
 )
 ECHO Adding domains to Trusted Zone for %%A_%%B
 FOR %%D IN (%TRUSTED_DOMAINS%) DO (
  ECHO -^> %%D
  %REG% add "%%A_%%B\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 2 /f
  %REG% add "%%A_%%B\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 2 /f
  IF DEFINED X64 %REG% add "%%A_%%B\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 2 /f
  IF DEFINED X64 %REG% add "%%A_%%B\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 2 /f
 )
)

IF DEFINED NTUSER ECHO Unloading new user registry defaults
IF DEFINED NTUSER %REG% unload HKU\.NTUSER

ENDLOCAL

:: -- Sitios de confianza --

@ECHO OFF
SETLOCAL

SET REG="%WINDIR%\system32\reg.exe"
SET TRUSTED_DOMAINS=https://*.controlgo.es
SET TRUSTED_DOMAINS=http://*.controlgo.es
SET TRUSTED_DOMAINS=https://*.orange.es
SET TRUSTED_DOMAINS=http://*.orange.es
SET TRUSTED_DOMAINS=https://*.orange.com
SET TRUSTED_DOMAINS=http://*.orange.com

IF EXIST "%USERPROFILE%\..\Default User\NTUSER.DAT" SET NTUSER="%USERPROFILE%\..\Default User\NTUSER.DAT"
IF EXIST "%USERPROFILE%\..\Default\NTUSER.DAT" SET NTUSER="%USERPROFILE%\..\Default\NTUSER.DAT"
IF DEFINED PROGRAMFILES(x86) SET X64=TRUE

ECHO Adding domains to Intranet Zone for HKEY_LOCAL_MACHINE
FOR %%D IN (%INTRANET_DOMAINS%) DO (
 ECHO -^> %%D
 %REG% add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 1 /f
 %REG% add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 1 /f
 IF DEFINED X64 %REG% add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 1 /f
 IF DEFINED X64 %REG% add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 1 /f 
)

ECHO Adding domains to Trusted Zone for HKEY_LOCAL_MACHINE
FOR %%D IN (%TRUSTED_DOMAINS%) DO (
 ECHO -^> %%D
 %REG% add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 2 /f
 %REG% add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 2 /f
)

IF DEFINED NTUSER ECHO Loading registry defaults for new user from %NTUSER%
IF DEFINED NTUSER %REG% load HKU\.NTUSER %NTUSER%

FOR /f "usebackq tokens=1,2 delims=_" %%A IN (`%REG% query HKU`) DO (
 ECHO Adding domains to Intranet Zone for %%A_%%B
 FOR %%D IN (%INTRANET_DOMAINS%) DO (
  ECHO -^> %%D
  %REG% add "%%A_%%B\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 1 /f
  %REG% add "%%A_%%B\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 1 /f
  IF DEFINED X64 %REG% add "%%A_%%B\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 1 /f
  IF DEFINED X64 %REG% add "%%A_%%B\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 1 /f
 )
 ECHO Adding domains to Trusted Zone for %%A_%%B
 FOR %%D IN (%TRUSTED_DOMAINS%) DO (
  ECHO -^> %%D
  %REG% add "%%A_%%B\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 2 /f
  %REG% add "%%A_%%B\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 2 /f
  IF DEFINED X64 %REG% add "%%A_%%B\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\%%D" /v * /t REG_DWORD /d 2 /f
  IF DEFINED X64 %REG% add "%%A_%%B\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\EscDomains\%%D" /v * /t REG_DWORD /d 2 /f
 )
)

IF DEFINED NTUSER ECHO Unloading new user registry defaults
IF DEFINED NTUSER %REG% unload HKU\.NTUSER

ENDLOCAL

	REM *** SCHEDULED TASKS tweaks ***
	REM schtasks /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable
	schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
	schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
	schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable
	schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
	schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable
	schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
	schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Uploader" /Disable
	schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyUpload" /Disable
	schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
	schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
	schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable
	
	rem # Eliminar telemetría y recolección de datos
	@echo Eliminando telemetría ...
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v PreventDeviceMetadataFromNetwork /t REG_DWORD /d 1 /f
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontOfferThroughWUAU /t REG_DWORD /d 1 /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f
	@REM Settings -> Privacy -> General -> Let apps use my advertising ID...
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
	REM - SmartScreen Filter for Store Apps: Disable
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v EnableWebContentEvaluation /t REG_DWORD /d 0 /f
	REM - Let websites provide locally...
	reg add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f
	@REM WiFi Sense: HotSpot Sharing: Disable
	reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v value /t REG_DWORD /d 0 /f
	@REM WiFi Sense: Shared HotSpot Auto-Connect: Disable
	reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v value /t REG_DWORD /d 0 /f
	@REM Change Windows Updates to "Notify to schedule restart"
	reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v UxOption /t REG_DWORD /d 1 /f
	@REM Disable P2P Update downlods outside of local network
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f
	@REM *** Disable Cortana & Telemetry ***
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0
	REM *** Hide the search box from taskbar. You can still search by pressing the Win key and start typing what you're looking for ***
	REM 0 = hide completely, 1 = show only icon, 2 = show long search box
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f
	REM *** Disable MRU lists (jump lists) of XAML apps in Start Menu ***
	reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f
	REM *** Set Windows Explorer to start on This PC instead of Quick Access ***
	REM 1 = This PC, 2 = Quick access
	REM reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f
	@echo.
	@echo Hecho!
	@echo.
	
	rem # Mejoras en el Explorador de Windows
	@echo Habilitando opciones avanzadas en el Explorador de Windows ...
	rem * Mostrar archivos ocultos
	reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f
	rem * Mostrar archivos ocultos de sistema
	reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 1 /f
	rem * Mostrar extensión de los archivos
	reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t  REG_DWORD /d 0 /f
	@echo.
	@echo Hecho!
	@echo.
	
	rem # Deshabilitar Cortana
	@echo Deshabilitando completamente cortana ...
	taskkill /F /IM SearchUI.exe
	move "%windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy" "%windir%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy.bak"
	@echo.
	@echo Hecho!
	@echo.

:: -- WINCRAP --
C:\REDITEL\magia-borras\win10-crapp-uninstaller.bat

:: -- KitInstalacionOrange --
C:\REDITEL\magia-borras\KitInstalacionOrange.exe

echo "David Garcia Martinez +34686813377"
PAUSE