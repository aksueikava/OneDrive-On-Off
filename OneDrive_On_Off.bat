::   Made with ❤️ by Watashi o yūwaku suru 
@echo off
title OneDrive On Off
Call :First


:MenuOneDrive
setlocal
set OneDrKey="HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive"
for /f "tokens=1" %%I in (' 2^>nul reg query %OneDrKey% ') do set "OneDrVal=%%I"
if "%OneDrVal%"=="" ( set "OneDr={0a}Отключен{#}" ) else ( set "OneDr={0e}Included{#}" )
if not exist "%USERPROFILE%\AppData\Local\Microsoft\OneDrive\OneDrive.exe" set "OneDr={0a}Deleted{#}"
cls
echo.
%ch% {08}    ============================================================ {\n #}
%ch%         Manage {0e}OneDrive {08}[Sync files with the cloud] {\n #}
%ch% {08}    ============================================================ {\n #}
echo.
%ch%         Your Windows:{0a} %xOS% {\n #}
echo.
echo.            At the moment:
%ch%                    OneDrive: %OneDr% {\n #}
echo.
echo.        Options for action:
echo.
%ch% {0b}    [1]{#} = Disable OneDrive {\n #}
%ch% {0b}    [2]{#} = Enable {0e}by default {\n #}
echo.
%ch% {0b}    [No input]{#} = Quit {\n #}
%ch%                                                {08} ^| Версия 1.0 {\n #}
echo.
set "input="
set /p input=*   Your choice: 
if not defined input ( echo.&%ch%     {0e} - Exit - {\n #}&echo.
			TIMEOUT /T 2 >nul & endlocal & goto :SelfStat )
if "%input%"=="1" ( goto :OneDriveOFF )
if "%input%"=="2" ( goto :OneDriveON
) else (
 echo.&%ch%     {0e} Incorrect choice {\n #}&echo.
 endlocal & TIMEOUT /T 1 >nul & goto :MenuOneDrive
)

:OneDriveOFF
echo.
%ch% {0b} --- Disable OneDrive completely --- {\n #}
TASKKILL /F /IM OneDrive.exe /T
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f
reg add "HKLM\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 0xf090004d /f
reg add "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 0xf090004d /f
if "%xOS%"=="x64" (
 echo.
 %ch% {0b} --- Additionally for x64 via OneDrive --- {\n #}
 reg add "HKLM\Software\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
 reg add "HKLM\Software\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 0xf090004d /f
 reg add "HKCU\Software\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
 reg add "HKCU\Software\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 0xf090004d /f
)
echo.
set "OneDriveTaskNo=1"
for /f "tokens=2 delims=\" %%I in ('
 reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks" /s /f "OneDrive" /d ^| find /i "Path" ^| find /i "OneDrive"
') do ( for /f "tokens=3 delims=," %%J in (' SCHTASKS /Query /FO CSV /NH /TN "%%I" ') do (
 if not "%%~J"=="Disabled" ( schtasks /Change /TN "%%~I" /Disable & set "OneDriveTaskNo=0" ) else ( echo.       Task: "%%~I" is already disabled & set "OneDriveTaskNo=0" )))
if "%OneDriveTaskNo%"=="1" %ch%        OneDrive tasks {0a}No{\n #}
echo.
echo.
%ch% {0b} --- Don't use OneDrive --- {\n #}
:: Комп\Адм. Шабл\Компоненты Windows\OneDrive "Запретить использование OneDrive для хранения файлов" (включена)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f
:: Комп\Адм. Шабл\Компоненты Windows\OneDrive "Запретить синхронизацию файлов OneDrive через лимитные подключения" (включена)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableMeteredNetworkFileSync" /t REG_DWORD /d 0 /f
echo.
%ch% {0b} --- Turn off sync provider notifications [Advertising in Explorer by OneDrive] --- {\n #}
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d 0 /f
echo.&%ch%      {2f} Everything is done {00}.{\n #}& echo.
TIMEOUT /T -1 & endlocal & goto :MenuOneDrive


:OneDriveON
echo.
if not exist "%USERPROFILE%\AppData\Local\Microsoft\OneDrive\OneDrive.exe" (
 %ch%        {0e}OneDrive Removed, unenabled {\n #}
 TIMEOUT /T -1 & endlocal & goto :MenuOneDrive
)
%ch% {0b} --- Enable OneDrive --- {\n #}
reg add "HKLM\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 0xf080004d /f
reg add "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 0xf080004d /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /t REG_SZ /d "\"%USERPROFILE%\AppData\Local\Microsoft\OneDrive\OneDrive.exe\" /background" /f
if "%xOS%"=="x64" (
 echo.
 %ch% {0b} --- Enabling additional x64 keys for OneDrive by default --- {\n #}
 reg add "HKLM\Software\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 1 /f
 reg add "HKLM\Software\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 0xf080004d /f
 reg add "HKCU\Software\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 1 /f
 reg add "HKCU\Software\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "Attributes" /t REG_DWORD /d 0xf080004d /f
)
echo.
set "OneDriveTaskNo=1"
for /f "tokens=2 delims=\" %%I in ('
 reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks" /s /f "OneDrive" /d ^| find /i "Path" ^| find /i "OneDrive"
') do ( for /f "tokens=3 delims=," %%J in (' SCHTASKS /Query /FO CSV /NH /TN "%%I" ') do (
 if "%%~J"=="Disabled" ( schtasks /Change /TN "%%~I" /Enable & set "OneDriveTaskNo=0" ) else ( echo.       Task: "%%~I" is already enabled & set "OneDriveTaskNo=0" )))
if "%OneDriveTaskNo%"=="1" %ch%        OneDrive tasks {0a}No{\n #}
echo.
echo.
%ch% {0b} --- Unblock OneDrive --- {\n #}
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableMeteredNetworkFileSync" /f
echo.
%ch% {0b} --- Enable sync provider notifications [advertising in Explorer from OneDrive, default] --- {\n #}
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /f
echo.&%ch%      {2f} Everything is done {00}.{\n #}& echo.
TIMEOUT /T -1 & endlocal & goto :MenuOneDrive



:SelfStat
exit


:First
chcp 65001 >nul
cd /d "%~dps0"
set xOS=x64& (If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86)
set ch="%~dps0Files\Tools\cecho.exe"
if not exist %ch% ( echo.&echo.        There is no file "cecho.exe" in the folder "\Files\Tools" & echo.
		    echo.        Cancel, exit & TIMEOUT /T 5 >nul & exit )


:: Сценарий вывода запроса UAC на получение админских прав, если батник запущен без привилегий.
reg query "HKU\S-1-5-19\Environment" >nul 2>&1 & cls
if "%Errorlevel%" NEQ "0" ( cmd /u /c echo. CreateObject^("Shell.Application"^).ShellExecute "%~f0", "", "", "RunAs", 1 > "%Temp%\GetAdmin.vbs"
"%Temp%\GetAdmin.vbs" & del "%temp%\GetAdmin.vbs" & cls & exit )
exit /b
