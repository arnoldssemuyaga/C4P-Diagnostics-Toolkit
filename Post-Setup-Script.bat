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
:: Main Menu 
@echo off
title C4P Post-Setup Diagnostic Tool
=======
color F
cls

:MENU
cls
color 0a
=======
echo.
echo Welcome to the C4P Post-Setup Diagnostics Tool. This tool will help assess laptops specifications and
echo run diagnostics tests after logon.
echo.
echo The date is %DATE% and the time is %TIME%.
echo.
echo #0 - Finalize Refurbishment and Start C4P Clean-Up
echo ===========================================================
echo #1 - Check Battery Health w/ BatteryInfoView
echo ===========================================================
echo #2 - Test Keyboard
echo ===========================================================
echo #3 - Test Camera and Microphone
echo ===========================================================
echo #4 - Test WiFi and Bluetooth
echo ===========================================================
echo #5 - Verify Windows Activation
echo ===========================================================
echo #6 - System Information
echo ===========================================================
echo #7 - Generate Built-in Windows Battery Report
echo ===========================================================
echo #8 - Open Generated Windows Battery Report
echo ===========================================================
echo Enter r to Restart or s to Shutdown
echo ===========================================================
echo Enter c to Close the Tool
echo.


:: Prompting the user for input
SET /P A=Enter: 

IF %A%==0 GOTO refurbConfirm
IF %A%==1 GOTO bHealth
IF %A%==2 GOTO tKeyboard
IF %A%==3 GOTO tCamMic
IF %A%==4 GOTO tWiFiBTMenu
IF %A%==5 GOTO tWinAct
IF %A%==6 GOTO GENSYSINFO
IF %A%==7 GOTO bReport
IF %A%==8 GOTO obReport
IF %A%==R GOTO RESTART
IF %A%==S GOTO SHUTDOWN
IF %A%==C GOTO CLOSE
IF %A%==r GOTO RESTART
IF %A%==s GOTO SHUTDOWN
IF %A%==c GOTO CLOSE

:: Redirecting to the Battery Health Report Menu
:bHealth
cls
color 0A
echo Generating Battery Report w/ BatteryInfoView...
echo.
%HOMEDRIVE%\Diagnostics\BatteryInfoView\BatteryInfoView.exe /stext %HOMEDRIVE%\Diagnostics\BatteryInfoView\batteryhealth.txt
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

:: Redirecting to the Second Battery Health Report Menu (doesn't generate a second battery health report w/ batteryinfoview)
:bHealth2
cls
color 0A
echo.
echo   Options:
echo   1. Display Battery Health
echo   2. Display Generated Report
echo   3. Main Menu
echo.
set /p C=Select an Option ( 1 / 2 / 3 ): 
if "%C%"=="1" goto dbHealth
if "%C%"=="2" goto obReport2
if "%C%"=="3" goto MENU

:: Redirecting to the Battery Health Report through PowerShell
:dbHealth
cls
color 0A
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%HOMEDRIVE%\Diagnostics\bHealth.ps1"
echo.
echo   Options:
echo   1. Battery Level Above 60%: Continue Diagnostics - Main Menu
echo   2. Battery Level Below 60%: End Diagnostics - Shutdown
echo.
set /p D=Select an Option ( 1 / 2 ): 
if "%D%"=="1" goto MENU
if "%D%"=="2" goto SHUTDOWN

:: Redirecting to the Generated BatteryInfoView Report
:obReport2
cls
color 0A
type %HOMEDRIVE%\Diagnostics\BatteryInfoView\batteryhealth.txt
echo.
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.
set /p E=Select an Option ( 1 / 2 ): 
if "%E%"=="1" goto bHealth2
if "%E%"=="1" goto MENU

:: Redirecting to the Built-in Windows Battery Report
:bReport
cls
color 0A
echo Generating Windows Battery Report...
echo.
powercfg /batteryreport
echo.
echo   Options:
echo   1. Open Generated Report
echo   2. Main Menu
echo.
set /p F=Select an Option ( 1 / 2 ):
if "%F%"=="1" goto obReport
if "%F%"=="2" goto MENU

:: Redirecting to the Generated Report
:: This will open the report in the default browser
:obReport
cls
color 0A
start %WINDIR%\explorer.exe "C:\battery-report.html"
pause
echo.
echo   Options:
echo   1. Re-Open Generated Report
echo   2. Main Menu
echo.
SET /P G=Select an Option ( 1 / 2 ):
IF %G%==1 GOTO obReport
IF %G%==2 GOTO MENU

:: Redirecting to the Keyboard Tester
:tKeyboard
cls
color 0A
%HOMEDRIVE%\Diagnostics\KeyboardTest\KeyboardTest.exe
echo.
echo   Options:
echo   1. Main Menu
echo.
SET /P H=Select an Option ( 1 ):
IF %H%==1 GOTO MENU

:: Redirecting to the Camera and Microphone Menu
:tCamMic
cls
color 0A
echo.
echo   Options:
echo   1. Open Windows Camera
echo   2. Open Microphone Settings
echo   3. Main Menu

echo.
SET /P I=Select an Option ( 1 / 2 / 3 ): 
IF %I%==1 GOTO wCam
IF %I%==2 GOTO wSound
IF %I%==3 GOTO MENU

:: Redirecting to the Camera App
:wCam
cls
color 0A
start microsoft.windows.camera:
echo.
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.
SET /P J=Select an Option ( 1 / 2 ):
IF %J%==1 GOTO tCamMic
IF %J%==2 GOTO MENU

:: Redirecting to the Sound Settings
:wSound
cls
color 0A
start ms-settings:sound
echo.
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.
SET /P K=Select an Option ( 1 / 2 ):
IF %K%==1 GOTO tCamMic
IF %K%==2 GOTO MENU

:: Redirecting to the WiFi and Bluetooth Menu
:tWiFiBTMenu
cls
color 0A
echo   Options:
echo   1. View Local WiFi Networks
echo   2. View Local Bluetooth Networks
echo   3. Ping 8.8.8.8
echo   4. Main Menu
echo.
SET /P L=Select an Option ( 1 / 2 / 3 / 4 ): 
IF %L%==1 GOTO tWiFi
IF %L%==2 GOTO tBT
IF %L%==3 GOTO tWiFiPing
IF %L%==4 GOTO MENU

:: Redirecting to the WiFi Viewer
:tWiFi
cls
color 0A
%HOMEDRIVE%\Diagnostics\WiFiView\WiFiView.exe
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.
SET /P M=Select an Option ( 1 / 2 ):
IF %M%==1 GOTO tWiFiBTMenu
IF %M%==2 GOTO MENU

:: Redirecting to the Bluetooth Viewer
:tBT
cls
color 0A
%HOMEDRIVE%\Diagnostics\BTView\BTView.exe
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.
SET /P N=Select an Option ( 1 / 2 ):
IF %N%==1 GOTO tWiFiBTMenu
IF %N%==2 GOTO MENU

:: Redirecting to the WiFiPing function
:tWiFiPing
cls
color 0A
ping 8.8.8.8 
echo.
echo   1. Previous Menu
echo   2. Main Menu
echo.
SET /P O=Select an Option ( 1 / 2 ):
IF %O%==1 GOTO tWiFiBTMenu
IF %O%==2 GOTO MENU

:: Redirecting to the Windows Activation Checker
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
SET /P P=Select an Option ( 1 ):
IF %P%==1 GOTO MENU

:: Redirecting to General System Information Menu
:GENSYSINFO
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
SET /P Q=Select an Option ( 1 / 2 ):
IF %Q%==1 GOTO SYSINFO
IF %Q%==2 GOTO MENU

:: Redirecting to the Detailed System Information Report Menu
:SYSINFO
cls
color 0A
systeminfo
echo.
echo   Options:
echo   1. Main Menu
echo.
SET /P R=Select an Option ( 1 ): 
IF %R%==1 GOTO MENU

:: Redirecting to the Refurbishment Confirmation Menu
:refurbConfirm
cls
color 0A
echo  Are you sure you would like to complete the refurbishment process by cleaning up all C4P-related files
echo  and finalize the computer for donation?
echo.
SET /P S=Select an Option ( Y / N ): 
IF %S%==Y GOTO C4PBarcode
IF %S%==y GOTO C4PBarcode
IF %S%==N GOTO MENU
IF %S%==n GOTO MENU

:: Redirecting to the C4P Barcode Entry Menu
:C4PBarcode
cls
color 0A
echo  Please enter the C4P Asset Tag (C4PMA####/C4PNJ####) of the computer. 
echo.
set /p barcode=C4P Barcode: 
GOTO refurbName

:: Redirecting to the Refurbishment Name Entry Menu
:refurbName
cls
color 0A
echo  Please enter the name of the staff performing refurbishment.
echo.
set /p name=Name: 
GOTO refurbConfirmBody

:: Redirecting to Laptop Body Confirmation Menu
:refurbConfirmBody
cls
color 0A
echo  Initializing Quality Assurance Process...
pause
cls
echo  Please check the following:
echo.
echo ===========================================================
echo                          Body
echo ===========================================================
echo.
echo  - No dents, cracks or missing pieces? 
echo.
SET /P T=Select an Option ( 1 - Pass / 2 - Fail / 3 - Run Test): 
IF %T%==1 GOTO refurbConfirmBodyGradePass
IF %T%==1 GOTO refurbConfirmBodyGradePass
IF %T%==2 GOTO MENU
IF %T%==2 GOTO MENU
IF %T%==3 GOTO refurbConfirmBodyTest
IF %T%==3 GOTO refurbConfirmBodyTest

:: Redirecting to the first Body Grade Confirmation Menu (after pressing 1 to pass the test)
:refurbConfirmBodyGradePass
cls
color 0A
echo  Please inspect the laptop's exterior condition and assign a quality grade:
echo.
echo  A - **Excellent**: Like new - no visible wear. No scratches, dents, cracks, and minimal to no signs of previous use. 
echo  B - **Very Good**: Light wear - minimal usage, may have tiny surface marks but no damage or flaws. 
echo  C - **Good/Used**: Noticeable wear - visible scratches or small dents, but housing is fully intact and flaws are cosmetic only. 
echo  D - **Fair**: Heavy wear - obvious use with dents, deep scratches, or faded surfaces. Still fully functional.
echo  F - **Fail**: Not suitable for donation - includes physical damage like cracks, missing keys, broken hinges, or exposed internals.
echo.
pause
set /p bodyGrade=Enter Laptop Body Grade (A, B, C, D, F): 
GOTO refurbConfirmScrn

:: Redirecting to the second Body Grade Confirmation Menu (after pressing 3 to run the test)
:refurbConfirmBodyTest
cls
color 0A
echo  Please inspect the laptop's exterior condition and assign a quality grade:
echo.
echo  A - **Excellent**: Like new - no visible wear. No scratches, dents, cracks, and minimal to no signs of previous use. 
echo  B - **Very Good**: Light wear - minimal usage, may have tiny surface marks but no damage or flaws. 
echo  C - **Good/Used**: Noticeable wear - visible scratches or small dents, but housing is fully intact and flaws are cosmetic only. 
echo  D - **Fair**: Heavy wear - obvious use with dents, deep scratches, or faded surfaces. Still fully functional.
echo  F - **Fail**: Not suitable for donation - includes physical damage like cracks, missing keys, broken hinges, or exposed internals.
echo.
pause
set /p bodyGrade=Enter Laptop Body Grade (A, B, C, D, F): 
cls
echo  Please confirm you have checked the following:
echo.
echo ===========================================================
echo                          Body
echo ===========================================================
echo.
echo  - No dents, cracks or missing pieces? 
echo.
SET /P T=Select an Option ( 1 - Pass / 2 - Fail ):  
IF %T%==1 GOTO refurbConfirmScrn
IF %T%==2 GOTO MENU

:: Redirecting to the Screen Confirmation Menu
:refurbConfirmScrn
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo ===========================================================
echo                          Screen
echo ===========================================================
echo.
echo  - No screen defects or cracks?
echo.
SET /P U=Select an Option ( 1 - Pass / 2 - Fail ): 
IF %U%==1 GOTO refurbConfirmPorts
IF %U%==2 GOTO MENU

:: Redirecting to the Ports Confirmation Menu
:refurbConfirmPorts
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo ===========================================================
echo                          Ports
echo ===========================================================
echo.
echo  All ports are functional?
echo  - Charging Port
echo  - USB-A/USB-C
echo  - Video Out (HDMI/DP/VGA/DVI)
echo  - 3.5mm Headphone Jack
echo  - Ethernet
echo.
SET /P V=Select an Option ( 1 - Pass / 2 - Fail ): 
IF %V%==1 GOTO refurbConfirmTPad
IF %V%==2 GOTO MENU

:: Redirecting to the Touchpad Diagnostic Confirmation Menu
:refurbConfirmTPad
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo ===========================================================
echo                        Touchpad
echo ===========================================================
echo.
echo  The touchpad is working correctly?
echo  - Left Click
echo  - Right Click
echo  - General Mouse Movement 
echo.
SET /P W=Select an Option ( 1 - Pass / 2 - Fail ): 
IF %W%==1 GOTO refurbConfirmKey
IF %W%==2 GOTO MENU

:: Redirecting to the Keyboard Diagnostic Confirmation Menu
:refurbConfirmKey
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo ===========================================================
echo                       Keyboard
echo ===========================================================
echo.
echo  - All keys are present and working as intended?
echo.
SET /P X=Select an Option ( 1 - Pass / 2 - Fail ): 
IF %X%==1 GOTO refurbConfirmBatt
IF %X%==2 GOTO MENU

::Redirecting to the Battery Diagnostic Confirmation Menu
:refurbConfirmBatt
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo ===========================================================
echo                     Battery Health
echo ===========================================================
echo.
echo  - Battery has NOT degraded less than 60% total capacity and holds a sufficient charge?
powershell -NoProfile -ExecutionPolicy Bypass -File "%HOMEDRIVE%\Diagnostics\bHealth.ps1"
echo.
SET /P Y=Select an Option ( 1 - Pass / 2 - Fail ):  
IF %Y%==1 GOTO refurbConfirmWiFiBT
IF %Y%==2 GOTO MENU

:: Redirecting to the WiFi and Bluetooth Diagnostic Confirmation Menu
:refurbConfirmWiFiBT
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo ===========================================================
echo                     WiFi + Bluetooth
echo ===========================================================
echo.
echo  - Shows local SSIDs and connects to networks successfully? Bluetooth working?
echo.
SET /P Z=Select an Option ( 1 - Pass / 2 - Fail ): 
IF %Z%==1 GOTO refurbConfirmSpeakers
IF %Z%==2 GOTO MENU

:: Redirecting to the Speaker Diagnostic Confirmation Menu
:refurbConfirmSpeakers
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo ===========================================================
echo                        Speakers
echo ===========================================================
echo.
echo  - Internal speaker working at intended volumes?
echo.
SET /P AA=Select an Option ( 1 - Pass / 2 - Fail ):  
IF %AA%==1 GOTO refurbConfirmCamMic
IF %AA%==2 GOTO MENU

:: Redirecting to the Camera and Microphone Diagnostic Confirmation Menu
:refurbConfirmCamMic
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo ===========================================================
echo                    Webcam + Microphone
echo ===========================================================
echo.
echo  - Internal webcam operational and working as intended?
echo  - Internal microphone working and not muffled or crackling?
echo.
SET /P BB=Select an Option ( 1 - Pass / 2 - Fail ):  
IF %BB%==1 GOTO refurbConfirmWinUpd
IF %BB%==2 GOTO MENU

:: Redirecting to the Windows Update Diagnostic Confirmation Menu
:refurbConfirmWinUpd
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo ===========================================================
echo                      Windows Updates
echo ===========================================================
echo.
echo  - Critical Windows Updates have been successfully installed?                                                                             
echo.
SET /P CC=Select an Option ( 1 - Pass / 2 - Fail ):  
IF %CC%==1 GOTO refurbConfirmWinAct
IF %CC%==2 GOTO MENU

:: Redirecting to the Windows Activation Diagnostic Confirmation Menu
:refurbConfirmWinAct
cls
color 0A
echo ===========================================================
echo                     Windows Activation
echo ===========================================================
echo.
echo  Checking if Windows is activated, please wait...
echo.
setlocal
for /f "delims=" %%a in ('cscript //nologo "%SystemRoot%\System32\slmgr.vbs" /xpr') do (
    set "activation=%%a"
)

setlocal enabledelayedexpansion
echo !activation! | findstr /i "not" >nul
if not errorlevel 1 (
    echo  Windows is NOT activated.
    echo  Launching Activation Troubleshooter...
    start ms-settings:activation
	GOTO MENU
) else (
    echo - Windows is activated.
)
endlocal
pause
GOTO refurbPreTask

:: Completed all diagnostics and checks
:refurbPreTask
cls
color 0A
echo  Refurbishment diagnostics have been successfully completed!
echo.
echo  Press any key to confirm donation validity and finalize refurbishment. The computer will restart.
pause
GOTO refurbTask

:: Runs C4P Clean-Up and generates the Passed.txt file on the desktop
:refurbTask
cls
color 0A
setlocal enabledelayedexpansion

:: Get current time components (and strip leading space if any)
set "rawHour=%TIME:~0,2%"
set "minute=%TIME:~3,2%"
set "second=%TIME:~6,2%"

:: Trim leading space in hour if it exists
if "!rawHour:~0,1!"==" " (
    set "rawHour=0!rawHour:~1,1!"
)

:: Force numeric interpretation of hour
set /a hour=1%rawHour% - 100

:: Convert to 12-hour format
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

:: Pad hour with leading 0 if < 10
if !hour! LSS 10 set "hour=0!hour!"

:: Final formatted time
set "formattedTime=!hour!:!minute!:!second! !ampm!"

:: Generates the Passed.txt file on the desktop with the diagnostics results
echo  Generating Passed Refurbishment Certificate...
echo ........................................................... > "%USERPROFILE%\Desktop\Passed.txt"
echo  This computer has been fully assessed by the C4P Team and >> "%USERPROFILE%\Desktop\Passed.txt"
echo  all diagnostics have successfully passed inspection on: >> "%USERPROFILE%\Desktop\Passed.txt"
echo.>> "%USERPROFILE%\Desktop\Passed.txt"
echo  Date: %DATE% >> "%USERPROFILE%\Desktop\Passed.txt"
echo  Time: %formattedTime% >> "%USERPROFILE%\Desktop\Passed.txt"
echo  Asset Tag: %barcode% >> "%USERPROFILE%\Desktop\Passed.txt"
echo  Refurbisher: %name% >> "%USERPROFILE%\Desktop\Passed.txt"
echo.>> "%USERPROFILE%\Desktop\Passed.txt"
echo =========================================================== >> "%USERPROFILE%\Desktop\Passed.txt"
echo                  DEVICE DIAGNOSTICS CHECKS >> "%USERPROFILE%\Desktop\Passed.txt"
echo =========================================================== >> "%USERPROFILE%\Desktop\Passed.txt"
echo                        Body - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo                       Body Grade: %bodyGrade% >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                       Screen - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                        Ports - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                      Touchpad - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                      Keyboard - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
powershell -NoProfile -ExecutionPolicy Bypass -File "%HOMEDRIVE%\Diagnostics\bHealth1.ps1" >> "%USERPROFILE%\Desktop\Passed.txt"
echo                       Battery - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                        Ports - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                  WiFi + Bluetooth - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                       Speakers - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                        Webcam - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                      Microphone - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                    Windows Update - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo ........................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                  Windows Activation - Passed >> "%USERPROFILE%\Desktop\Passed.txt"
echo =========================================================== >> "%USERPROFILE%\Desktop\Passed.txt"
echo           ALL CHECKS PASSED, SUITABLE FOR DONATION >> "%USERPROFILE%\Desktop\Passed.txt"
echo =========================================================== >> "%USERPROFILE%\Desktop\Passed.txt"
echo                    SYSTEM SPECIFICATIONS >> "%USERPROFILE%\Desktop\Passed.txt"
echo =========================================================== >> "%USERPROFILE%\Desktop\Passed.txt"
powershell -NoProfile -ExecutionPolicy Bypass -File "%HOMEDRIVE%\Diagnostics\BasicSysInfo.ps1" >> "%USERPROFILE%\Desktop\Passed.txt"
endlocal
%HOMEDRIVE%\Clean-Up.bat
EXIT /B

:: Redirecting to the Restart Menu
:RESTART
cls
color 0A 
shutdown.exe /f /r
EXIT /B

:: Redirecting to the Shutdown Menu
:SHUTDOWN
cls
color 0A
shutdown.exe /s /f
EXIT /B

:: Redirecting to the Close Menu
:CLOSE
cls
color 0A
EXIT /B