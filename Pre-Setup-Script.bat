@echo off
::BatchHasAdmin
:...........................................................
REM Check for administrative privileges
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM If errorlevel 1, we do not have admin rights
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

REM If we have admin rights, continue with the script
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
    
REM If we get here, we have admin rights
:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:...........................................................   
REM formattedTime function (for showing the current time in 12-hour format and AM/PM)
setlocal enabledelayedexpansion

REM Get current time components (and strip leading space if any)
set "rawHour=%TIME:~0,2%"
set "minute=%TIME:~3,2%"
set "second=%TIME:~6,2%"

REM Trim leading space in hour if it exists
if "!rawHour:~0,1!"==" " (
    set "rawHour=0!rawHour:~1,1!"
)

REM Force numeric interpretation of hour
set /a hour=1%rawHour% - 100

REM Convert to 12-hour format
set "ampm=AM"
if !hour! GEQ 12 (
    set "ampm=PM"
)
if !hour! GTR 12 (
    set /a hour=hour - 12
)
if !hour! EQU 0 (
    set "hour=12"
    set "ampm=AM"
)

REM Pad hour with leading 0 if < 10
if !hour! LSS 10 set "hour=0!hour!"

REM Final formatted time variable
set "formattedTime=!hour!:!minute!:!second! !ampm!"
   
REM Main Menu 
@echo off
title C4P Pre-Setup Diagnostics Toolkit
=======
color F
cls

:MENU
cls
color 0a
=======
echo ======================================================================================================================
echo                                     Hello. Welcome to the C4P Diagnostics Tool.
echo                                                  PRE-SETUP V1.3
echo                                The date is %DATE%, and the time is %formattedTime%.
echo ======================================================================================================================
echo.
echo ======================================================================================================================
echo                                      #1 - Check Battery Health w/ BatteryInfoView
echo ======================================================================================================================
echo                                                 #2 - Test Keyboard
echo ======================================================================================================================
echo                                             #3 - Test WiFi and Bluetooth
echo ======================================================================================================================
echo                                            #4 - Verify Windows Activation
echo ======================================================================================================================
echo                                               #5 - System Information
echo ======================================================================================================================
echo                                           Enter r to Restart or s to Shutdown
echo ======================================================================================================================
echo                                               Enter c to Close the Tool
echo ======================================================================================================================
echo.
:...........................................................

REM Prompting the user for input
:MainMenuInput
SET /P A=Enter: 
IF "%A%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO MainMenuInput
)
IF %A%==1 GOTO bHealth
IF %A%==2 GOTO tKeyboard
IF %A%==3 GOTO tWiFiBTMenu
IF %A%==4 GOTO tWinAct
IF %A%==5 GOTO GenSysInfo
IF /I "%A%"=="R" GOTO RESTART
IF /I "%A%"=="S" GOTO SHUTDOWN
IF /I "%A%"=="C" GOTO CLOSE

echo  Invalid option, please try again.
echo.
GOTO MainMenuInput

REM Redirecting to the Battery Health Report Menu
:bHealth
cls
color 0A
echo  Launching BatteryInfoView...
echo.
%HOMEDRIVE%\Diagnostics\BatteryInfoView\BatteryInfoView.exe
pause
cls
color 0A
echo.
echo   Is the Battery Health above 60%?
echo   1. Yes - Continue Diagnostics
echo   2. No - Shutdown
echo.

:bHealthInput
SET /P B=Select an Option ( 1 / 2 ): 
IF "%B%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO bHealthInput
)
IF "%B%"=="1" GOTO MENU
IF "%B%"=="2" GOTO SHUTDOWN

echo  Invalid option, please try again.
echo.
GOTO bHealthInput

REM Redirecting to the Keyboard Tester
:tKeyboard
cls
color 0A
%HOMEDRIVE%\Diagnostics\KeyboardTest\KeyboardTest.exe
echo.
echo   Options:
echo   1. Main Menu
echo.

:tKeyboardInput
SET /P H=Select an Option ( 1 ): 
IF "%H%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO tKeyboardInput
)
IF "%H%"=="1" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO tKeyboardInput

REM Redirecting to the WiFi and Bluetooth Menu
:tWiFiBTMenu
cls
color 0A
echo   Options:
echo   1. Check WiFi Status
echo   2. View Local WiFi Networks
echo   3. Check Bluetooth Status
echo   4. View Local Bluetooth Networks
echo   5. Main Menu
echo.

:tWiFiBTInput
SET /P LL=Select an Option ( 1 / 2 / 3 / 4 / 5 ): 
IF "%LL%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tWiFiBTInput
)
IF "%LL%"=="1" GOTO cWiFi
IF "%LL%"=="2" GOTO tWiFi
IF "%LL%"=="3" GOTO cBT
IF "%LL%"=="4" GOTO tBT
IF "%LL%"=="5" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO tWiFiBTInput

REM Redirecting to the WiFi Viewer
:tWiFi
cls
color 0A
%HOMEDRIVE%\Diagnostics\WiFiView\WiFiView.exe
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.

:tWiFiInput
SET /P M=Select an Option ( 1 / 2 ): 
IF "%M%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO tWiFiInput
)
IF "%M%"=="1" GOTO tWiFiBTMenu
IF "%M%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO tWiFiInput

:cWiFi
cls
color 0A
echo Checking WiFi status...
echo.

REM Check if WiFi is connected
powershell -Command "Test-Connection -ComputerName google.com -Count 1 -Quiet" >nul 2>&1
IF ERRORLEVEL 1 (
    echo WiFi is not connected. Please connect to a WiFi network and try again.
    echo.
    pause
    GOTO tWiFiBTMenu
)

echo WiFi is connected.
echo Testing internet connectivity by pinging google.com...
ping -n 4 google.com >nul 2>&1
IF ERRORLEVEL 1 (
    echo Unable to reach google.com. There may be an issue with the internet connection.
    echo.
    pause
    GOTO tWiFiBTMenu
)

echo WiFi is connected and internet is accessible.
echo.
pause
GOTO tWiFiBTMenu

REM Redirecting to the Bluetooth Viewer
:tBT
cls
color 0A
%HOMEDRIVE%\Diagnostics\BTView\BTView.exe
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.

:tBTInput
SET /P N=Select an Option ( 1 / 2 ): 
IF "%N%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO tBTInput
)
IF "%N%"=="1" GOTO tWiFiBTMenu
IF "%N%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO tBTInput

:cBT
cls
color 0A
echo Checking Bluetooth status...
echo.

REM Check if Bluetooth drivers are installed
powershell -Command "Get-PnpDevice -Class Bluetooth | Where-Object { $_.Status -eq 'OK' }" >nul 2>&1
IF ERRORLEVEL 1 (
    echo Bluetooth drivers are not installed or not functioning properly.
    echo.
    pause
    GOTO tWiFiBTMenu
)

REM Check if Bluetooth is turned on
powershell -Command "(Get-Service -Name bthserv).Status" | findstr /i "Running" >nul 2>&1
IF ERRORLEVEL 1 (
    echo Bluetooth is not turned on. Please enable Bluetooth and try again.
    echo.
    pause
    GOTO tWiFiBTMenu
)

echo Bluetooth is installed and turned on.
echo.
pause
GOTO tWiFiBTMenu

REM Redirecting to the Windows Activation Checker
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

:tWinActInput
SET /P P=Select an Option ( 1 ): 
IF "%P%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO tWinActInput
)
IF "%P%"=="1" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO tWinActInput

REM Redirecting to General System Information Menu
:GenSysInfo
cls
color 0A
echo  Gathering CPU, GPU and RAM Information...
cls
powershell -NoProfile -ExecutionPolicy Bypass -File "%HOMEDRIVE%\Diagnostics\BasicSysInfo.ps1"
echo.
echo   Options:
echo   1. View Detailed System Info Report
echo   2. Main Menu
echo.

:GenSysInfoInput
SET /P Q=Select an Option ( 1 / 2 ): 
IF "%Q%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO GenSysInfoInput
)
IF "%Q%"=="1" GOTO SYSINFO
IF "%Q%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO GenSysInfoInput

REM Redirecting to the Detailed System Information Report Menu
:SYSINFO
cls
color 0A
systeminfo
echo.
echo   Options:
echo   1. Main Menu
echo.

:SysInfoInput
SET /P R=Select an Option ( 1 ): 
IF "%R%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO SysInfoInput
)
IF "%R%"=="1" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO SysInfoInput

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
endlocal
