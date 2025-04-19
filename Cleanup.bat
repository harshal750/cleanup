@echo off
color 0A
echo ===================================================
echo     DEEP CLEANUP - AUTO SELECT DISKCLEAN OPTIONS   
echo ===================================================
echo.

:: Check for Admin Privileges
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Please run this script as Administrator!
    pause
    exit
)

:: Stop SysMain (Superfetch)
sc stop SysMain >nul 2>&1

:: Clean Temp, Prefetch, etc.
echo Cleaning Prefetch folder...
del /s /f /q C:\Windows\Prefetch\*.*

echo Cleaning C:\Windows\Temp...
del /s /f /q C:\Windows\Temp\*.*

echo Cleaning %temp%...
del /s /f /q "%temp%\*.*"

echo Emptying Recycle Bin...
rd /s /q %systemdrive%\$Recycle.Bin >nul 2>&1

:: Delete non-system .bak and .dmp files
echo Deleting .bak and .dmp files from safe locations...
for /r C:\Users %%G in (*.bak *.dmp) do del /f /q "%%G"
for /r C:\ProgramData %%G in (*.bak *.dmp) do del /f /q "%%G"

:: Windows Update leftover
echo Cleaning SoftwareDistribution\Download folder...
net stop wuauserv >nul
rd /s /q %windir%\SoftwareDistribution\Download
net start wuauserv >nul

:: Auto-select Disk Cleanup options via registry
echo Configuring Disk Cleanup (auto-select all options)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v StateFlags0099 /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Delivery Optimization Files" /v StateFlags0099 /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0099 /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" /v StateFlags0099 /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v StateFlags0099 /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v StateFlags0099 /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" /v StateFlags0099 /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files" /v StateFlags0099 /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Files" /v StateFlags0099 /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" /v StateFlags0099 /t REG_DWORD /d 2 /f

:: Run Disk Cleanup with auto settings
echo Running Disk Cleanup silently...
cleanmgr /sagerun:99

echo.
echo ===================================================
echo        DEEP CLEANUP COMPLETED SUCCESSFULLY        
echo ===================================================
pause
exit
