::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJG6N+kY/PwhofwGWKXuGJeEspuH44Io=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDpQQQ2MNXiuFLQI5/rHy++UqVkSRN4IcYHf1aOdYMkgxQXCfJooxUZql9gYQShdage7UixgmSNypGHIBMKIph+sbkGI4QU1A2AU
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
::BatchHasAdmin
:-------------------------------------
REM --> Check if this file has administrator rights.
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If no rights, we don't have setted the flag for it.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    
:: MainCode
@echo off
title C4P Pre-Setup Diagnostic Tool 
=======
color F
cls

:MENU
cls
color 0a
=======
echo.
echo Welcome to the C4P Pre-Setup Diagnostic Tool. This tool will help assess laptop specifications and
echo run diagnostics tests before logon.
echo.
echo The date is %DATE% and the time is %TIME%.
echo.
echo ...........................................................
echo #1 - Test Battery Health w/ BatteryInfoView
echo ...........................................................
echo #2 - Test Keyboard
echo ...........................................................
echo #3 - Test WiFi Connection
echo ...........................................................
echo #4 - Verify Windows Activation
echo ...........................................................
echo #5 - System Information
echo ...........................................................
echo #6 - Basic System Information (CPU, GPU, RAM)
echo ...........................................................
echo Enter r to Restart or s to Shutdown
echo ...........................................................
echo Enter c to Close the Tool
echo ...........................................................
echo.

SET /P A=Enter: 

IF %A%==1 GOTO bHealth
IF %A%==2 GOTO tKeyboard
IF %A%==3 GOTO tWiFi
IF %A%==4 GOTO tWinAct
IF %A%==5 GOTO SYSINFO
IF %A%==6 GOTO GENSYSINFO
IF %A%==R GOTO RESTART
IF %A%==S GOTO SHUTDOWN
IF %A%==C GOTO CLOSE
IF %A%==r GOTO RESTART
IF %A%==s GOTO SHUTDOWN
IF %A%==c GOTO CLOSE

:bHealth
cls
color 0A
echo Generating Battery Report w/ BatteryInfoView...
echo.
%HOMEDRIVE%\Diagnostics\BatteryInfoView\BatteryInfoView.exe /stext %HOMEDRIVE%\Diagnostics\BatteryInfoView\batteryhealth.txt
echo   Options:
echo   1. Display Battery Health
echo   2. Display Generated Report
echo   3. Main Menu
echo.
set /p B=Select an Option ( 1 / 2 / 3 ): 
if "%B%"=="1" goto dbHealth
if "%B%"=="2" goto obReport2
if "%B%"=="3" goto MENU

:bHealth2
cls
color 0A
echo.
echo   Options:
echo   1. Display Battery Health
echo   2. Display Generated Report
echo   3. Main Menu
echo.
set /p B=Select an Option ( 1 / 2 / 3 ): 
if "%B%"=="1" goto dbHealth
if "%B%"=="2" goto obReport2
if "%B%"=="3" goto MENU

:dbHealth
cls
color 0A
powershell -NoProfile -ExecutionPolicy Bypass -File "%HOMEDRIVE%\Diagnostics\bHealth.ps1"
echo.
echo   Options:
echo   1. Battery Level Above 60%: Continue Diagnostics - Main Menu
echo   2. Battery Level Below 60%: End Diagnostics - Shutdown
echo.
set /p C=Select an Option ( 1 / 2 ): 
if "%C%"=="1" goto MENU
if "%C%"=="2" goto SHUTDOWN


:obReport2
cls
color 0A
type %HOMEDRIVE%\Diagnostics\BatteryInfoView\batteryhealth.txt
echo.
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.
set /p D=Select an Option ( 1 / 2 ):
if "%D%"=="1" goto bHealth2
if "%D%"=="1" goto MENU

:tKeyboard
cls
color 0A
%HOMEDRIVE%\Diagnostics\KeyboardTest.exe
echo.
echo   Options:
echo   1. Main Menu
echo.
SET /P E=Select an Option ( 1 ):
IF %E%==1 GOTO MENU

:tWiFi
cls
color 0A
echo.
ping 8.8.8.8 
echo.
echo   Options:
echo   1. Main Menu
echo.
SET /P J=Select an Option ( 1 ):
IF %J%==1 GOTO MENU

:tWinAct
cls
color 0A
echo.
echo Retrieving Windows Activation Key and Activation Status...
cscript //nologo "%HOMEDRIVE%\Diagnostics\WinAct.vbs"
color 0A
echo.
echo   Options:
echo   1. Main Menu
echo.
SET /P K=Select an Option ( 1 ):
IF %K%==1 GOTO MENU

:GENSYSINFO
cls
color 0A
echo Gathering CPU, GPU and RAM Information...
powershell -NoProfile -ExecutionPolicy Bypass -File "%HOMEDRIVE%\Diagnostics\BasicSysInfo.ps1"
echo.
echo   Options:
echo   1. Main Menu
echo.
SET /P M=Select an Option ( 1 ):
IF %M%==1 GOTO MENU

:SYSINFO
cls
color 0A
systeminfo
echo.
echo   Options:
echo   1. Main Menu
echo.
SET /P N=Select an Option ( 1 ):
IF %N%==1 GOTO MENU

:RESTART
cls
color 0A 
shutdown.exe /f /r
EXIT /B

:SHUTDOWN
cls
color 0A
shutdown /s /f
EXIT /B

:CLOSE
cls
color 0A
EXIT /B