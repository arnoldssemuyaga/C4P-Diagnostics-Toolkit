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
@echo off
title C4P Diagnostics Toolkit
=======
color F
cls
:...........................................................
REM Main Menu
:MENU

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

cls
color 0a
=======
echo =========================================================================================================
echo                              Hello. Welcome to the C4P Diagnostics Tool v1.5.
echo                          The date is %DATE%, and the time is %formattedTime%.
echo =========================================================================================================
echo.
echo =========================================================================================================
echo                           #0 - Finalize Refurbishment and Start C4P Clean-Up
echo =========================================================================================================
echo                               #1 - Check Battery Health w/ BatteryInfoView
echo =========================================================================================================
echo                                            #2 - Test Keyboard
echo =========================================================================================================
echo                                       #3 - Test Camera and Microphone
echo =========================================================================================================
echo                                        #4 - Test WiFi and Bluetooth
echo =========================================================================================================
echo                                       #5 - Verify Windows Activation
echo =========================================================================================================
echo                                          #6 - System Information
echo =========================================================================================================
echo                               #7 - Generate Built-in Windows Battery Report
echo =========================================================================================================
echo                                 #8 - Open Generated Windows Battery Report
echo =========================================================================================================
echo                                    Enter r to Restart or s to Shutdown
echo =========================================================================================================
echo                                        Enter c to Close the Tool
echo =========================================================================================================
echo.
endlocal
:...........................................................

REM Prompting the user for input
:MainMenuInput
SET /P A=Enter: 
IF "%A%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO MainMenuInput
)
IF %A%==0 GOTO refurbConfirm
IF %A%==1 GOTO bHealth
IF %A%==2 GOTO tKeyboard
IF %A%==3 GOTO tCamMic
IF %A%==4 GOTO tWiFiBTMenu
IF %A%==5 GOTO tWinAct
IF %A%==6 GOTO GenSysInfo
IF %A%==7 GOTO bReport
IF %A%==8 GOTO obReport
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
echo  Generating Battery Report with BatteryInfoView...
echo.
%b2eincfilepath%\BatteryInfoView.exe /stext %HOMEDRIVE%\batteryhealth.txt
if exist %HOMEDRIVE%\batteryhealth.txt (
    echo  Battery report successfully generated!
) else (
    echo  Failed to generate battery report. Please ensure that BatteryInfoView is installed in the correct directory.
)
echo.
echo   Options:
echo   1. Display Battery Health
echo   2. Display Generated Report
echo   3. Main Menu
echo.

:bHealthInput
SET /P B=Select an Option ( 1 / 2 / 3 ): 
IF "%B%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO bHealthInput
)
IF "%B%"=="1" GOTO dbHealth
IF "%B%"=="2" GOTO obReport2
IF "%B%"=="3" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO bHealthInput

REM Redirecting to the Second Battery Health Report Menu (doesn't generate a second battery health report w/ batteryinfoview)
:bHealth2
cls
color 0A
echo.
echo   Options:
echo   1. Display Battery Health
echo   2. Display Generated Report
echo   3. Main Menu
echo.

:bHealth2Input
SET /P C=Select an Option ( 1 / 2 / 3 ): 
IF "%C%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO bHealth2Input
)
IF "%C%"=="1" GOTO dbHealth
IF "%C%"=="2" GOTO obReport2
IF "%C%"=="3" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO bHealth2Input

REM Redirecting to the Battery Health Report through PowerShell
:dbHealth
cls
color 0A
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%b2eincfilepath%\bHealth.ps1"
echo.
echo   Options:
echo   1. Battery Level Above 60%: Continue Diagnostics - Main Menu
echo   2. Battery Level Below 60%: End Diagnostics - Shutdown
echo.

:dbHealthInput
SET /P D=Select an Option ( 1 / 2 ): 
IF "%D%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO dbHealthInput
)
IF "%D%"=="1" GOTO MENU
IF "%D%"=="2" GOTO SHUTDOWN

echo  Invalid option, please try again.
echo.
GOTO dbHealthInput

REM Redirecting to the Generated BatteryInfoView Report
:obReport2
cls
color 0A
type %HOMEDRIVE%\batteryhealth.txt
if exist %HOMEDRIVE%\batteryhealth.txt (
    echo  Generated battery report displayed successfully.
) else (
    echo  Failed to display generated battery report. Please ensure that BatteryInfoView has generated batteryhealth.txt.
)
echo.
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.

:obReport2Input
SET /P E=Select an Option ( 1 / 2 ): 
IF "%E%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO obReport2Input
)
IF "%E%"=="1" GOTO bHealth2
IF "%E%"=="2" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO obReport2Input

REM Redirecting to the Built-in Windows Battery Report
:bReport
cls
color 0A
echo  Generating Windows Battery Report...
echo.
powercfg /batteryreport
echo.
echo   Options:
echo   1. Open Generated Report
echo   2. Main Menu
echo.

:bReportInput
SET /P F=Select an Option ( 1 / 2 ):
IF "%F%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO bReportInput
)
IF "%F%"=="1" GOTO obReport
IF "%F%"=="2" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO bReportInput


REM Redirecting to the Generated Report
REM This will open the report in the default browser
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

:obReportInput
SET /P G=Select an Option ( 1 / 2 ):
IF "%G%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO obReportInput
)
IF "%G%"=="1" GOTO obReport
IF "%G%"=="2" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO obReportInput

REM Redirecting to the Keyboard Tester
:tKeyboard
cls
color 0A
%b2eincfilepath%\KeyboardTest.exe
echo.
echo   Options:
echo   1. Main Menu
echo.

:tKeyboardInput
SET /P H=Select an Option ( 1 ):
IF "%H%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tKeyboardInput
)
IF "%H%"=="1" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO tKeyboardInput

:tKeyboard2
cls
color 0A
%b2eincfilepath%\KeyboardTest.exe
echo.
echo   Options:
echo   1. Re-Run Test
echo   2. Back to Keyboard Diagnostics
echo   3. Main Menu
echo.

:tKeyboardInput2
SET /P HH=Select an Option ( 1 / 2 / 3 ): 
IF "%HH%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tKeyboardInput2
)

IF "%HH%"=="1" GOTO tKeyboard2
iF "%HH%"=="2" GOTO refurbConfirmKey
IF "%HH%"=="3" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO tKeyboardInput2

REM Redirecting to the Camera and Microphone Menu
:tCamMic
cls
color 0A
echo.
echo   Options:
echo   1. Open Windows Camera
echo   2. Open Microphone Settings
echo   3. Main Menu
echo.

:tCamMicInput
SET /P I=Select an Option ( 1 / 2 / 3 ): 
IF "%I%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tCamMicInput
)
IF "%I%"=="1" GOTO wCam
IF "%I%"=="2" GOTO wSound
IF "%I%"=="3" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO tCamMicInput

REM Redirecting to the Camera and Microphone Menu from the refurbConfirm Menu
:tCamMic2
cls
color 0A
echo.
echo   Options:
echo   1. Open Windows Camera
echo   2. Open Microphone Settings
echo   3. Back to Camera + Microphone Diagnostics
echo.

:tCamMicInput2
SET /P I=Select an Option ( 1 / 2 / 3 ): 
IF "%I%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tCamMicInput
)
IF "%I%"=="1" GOTO wCam2
IF "%I%"=="2" GOTO wSound2
IF "%I%"=="3" GOTO refurbConfirmCamMic

echo  Invalid option, please try again.
echo.
GOTO tCamMicInput2

REM Redirecting to the Camera App
:wCam
cls
color 0A
start microsoft.windows.camera:
echo.
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.

:wCamInput
SET /P J=Select an Option ( 1 / 2 ):
IF "%J%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO wCamInput
)
IF "%J%"=="1" GOTO tCamMic
IF "%J%"=="2" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO wCamInput

REM Redirecting to the Camera App from tCamMic2
:wCam2
cls
color 0A
start microsoft.windows.camera:
echo.
echo   Options:
echo   1. Previous Menu
echo.

:wCamInput2
SET /P J=Select an Option ( 1 ):
IF "%J%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO wCamInput2
)
IF "%J%"=="1" GOTO tCamMic2

echo  Invalid option, please try again.
echo.
GOTO wCamInput2

REM Redirecting to the Sound Settings
:wSound
cls
color 0A
start ms-settings:sound
echo.
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.

:wSoundInput
SET /P K=Select an Option ( 1 / 2 ):
IF "%K%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO wSoundInput
)
IF "%K%"=="1" GOTO tCamMic
IF "%K%"=="2" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO wSoundInput

REM Redirecting to the Sound Settings from tCamMic2 or wCam2
:wSound2
cls
color 0A
start ms-settings:sound
echo.
echo   Options:
echo   1. Previous Menu
echo.

:wSoundInput2
SET /P K=Select an Option ( 1 ):
IF "%K%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO wSoundInput2
)
IF "%K%"=="1" GOTO tCamMic2

echo  Invalid option, please try again.
echo.
GOTO wSoundInput2

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


:tWiFiBTMenu2
cls
color 0A
echo   Options:
echo   1. Check WiFi Status
echo   2. View Local WiFi Networks
echo   3. Check Bluetooth Status
echo   4. View Local Bluetooth Networks
echo   5. Back to WiFi + Bluetooth Diagnostics
echo.

:tWiFiBTInput2
SET /P LLL=Select an Option ( 1 / 2 / 3 / 4 / 5 ): 
IF "%LLL%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tWiFiBTInput2
)
IF "%LLL%"=="1" GOTO cWiFi2
IF "%LLL%"=="2" GOTO tWiFi2
IF "%LLL%"=="3" GOTO cBT2
IF "%LLL%"=="4" GOTO tBT2
IF "%LLL%"=="5" GOTO refurbConfirmWiFiBT

echo  Invalid option, please try again.
echo.
GOTO tWiFiBTInput2

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

:cBT2
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
    GOTO tWiFiBTMenu2
)

REM Check if Bluetooth is turned on
powershell -Command "(Get-Service -Name bthserv).Status" | findstr /i "Running" >nul 2>&1
IF ERRORLEVEL 1 (
    echo Bluetooth is not turned on. Please enable Bluetooth and try again.
    echo.
    pause
    GOTO tWiFiBTMenu2
)

echo Bluetooth is installed and turned on.
echo.
pause
GOTO tWiFiBTMenu2

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

:cWiFi2
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
    GOTO tWiFiBTMenu2
)

echo WiFi is connected.
echo Testing internet connectivity by pinging google.com...
ping -n 4 google.com >nul 2>&1
IF ERRORLEVEL 1 (
    echo Unable to reach google.com. There may be an issue with the internet connection.
    echo.
    pause
    GOTO tWiFiBTMenu2
)

echo WiFi is connected and internet is accessible.
echo.
pause
GOTO tWiFiBTMenu2

REM Redirecting to the WiFi Viewer
:tWiFi
cls
color 0A
%b2eincfilepath%\WiFiView.exe
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.

:tWiFiInput
SET /P M=Select an Option ( 1 / 2 ):
IF "%M%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tWiFiInput
)
IF "%M%"=="1" GOTO tWiFiBTMenu
IF "%M%"=="2" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO tWiFiInput

REM Redirecting to the WiFi Viewer
:tWiFi2
cls
color 0A
%b2eincfilepath%\WiFiView.exe
echo   Options:
echo   1. Previous Menu
echo.

:tWiFiInput2
SET /P M=Select an Option ( 1 / 2 ):
IF "%M%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tWiFiInput2
)
IF "%M%"=="1" GOTO tWiFiBTMenu2

echo  Invalid option, please try again.
echo.
GOTO tWiFiInput2

REM Redirecting to the Bluetooth Viewer
:tBT
cls
color 0A
%b2eincfilepath%\BTView.exe
echo   Options:
echo   1. Previous Menu
echo   2. Main Menu
echo.

:tBTInput
SET /P N=Select an Option ( 1 / 2 ):
IF "%N%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tBTInput
)
IF "%N%"=="1" GOTO tWiFiBTMenu
IF "%N%"=="2" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO tBTInput

REM Redirecting to the Bluetooth Viewer
:tBT2
cls
color 0A
%b2eincfilepath%\BTView.exe
echo   Options:
echo   1. Previous Menu
echo.

:tBTInput2
SET /P NN=Select an Option ( 1 ):
IF "%NN%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tBTInput2
)
IF "%NN%"=="1" GOTO tWiFiBTMenu2

echo  Invalid option, please try again.
echo.
GOTO tBTInput2

REM Redirecting to the Windows Activation Checker
:tWinAct
cls
color 0A
echo.
echo  Retrieving Windows Activation Key and Activation Status...
cscript //nologo "%b2eincfilepath%\WinAct.vbs"
color 0A
echo.
echo   Options:
echo   1. Main Menu
echo.

:tWinActInput
SET /P P=Select an Option ( 1 ):
IF "%P%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO tWinActInput
)
IF "%P%"=="1" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO tWinActInput

REM Redirecting to General System Information Menu
:GenSysInfo
cls
color 0A
echo  Gathering CPU, GPU and RAM Information...
cls
powershell -NoProfile -ExecutionPolicy Bypass -File "%b2eincfilepath%\BasicSysInfo.ps1"
echo.
echo   Options:
echo   1. View Detailed System Info Report
echo   2. Main Menu
echo.

:GenSysInfoInput
SET /P Q=Select an Option ( 1 / 2 ):
IF "%Q%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO GenSysInfoInput
)
IF "%Q%"=="1" GOTO SysInfo
IF "%Q%"=="2" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO GenSysInfoInput

REM Redirecting to the Detailed System Information Report Menu
:SysInfo
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
    echo  Invalid option, please try again.
    echo.
    GOTO SysInfoInput
)
IF "%R%"=="1" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO SysInfoInput

REM Redirecting to the Refurbishment Confirmation Menu
:refurbConfirm
cls
color 0A
echo  This will trigger the Quality Assurance process associated with the C4P Quality Assurance Checklist
echo  and generate a text file on the desktop with the passed refurbishment results.
echo.
echo  Would you like to proceed?
echo.

:refurbConfirmInput
SET /P S=Select an Option ( Y / N ): 
IF "%S%"=="" (
    echo  Invalid option, please try again.
    echo.
    GOTO refurbConfirmInput
)
IF /I "%S%"=="Y" GOTO C4PBarcode
IF /I "%S%"=="N" GOTO MENU

echo  Invalid option, please try again.
echo.
GOTO refurbConfirmInput

REM Redirecting to the C4P Barcode Entry Menu
:C4PBarcode
cls
color 0A
echo  Please enter the C4P Asset Tag (C4PMA####/C4PNJ####) of the computer. 
echo.
set /p barcode=C4P Barcode: 
GOTO refurbName

REM Redirecting to the Refurbishment Name Entry Menu
:refurbName
cls
color 0A
echo  Please enter the name of the staff performing this refurbishment.
echo.
set /p name=Name: 
GOTO refurbConfirmBody

REM Redirecting to Laptop Body Confirmation Menu
:refurbConfirmBody
cls
color 0A
echo Initializing Quality Assurance Process...
for /l %%i in (3,-1,1) do (
    echo %%i...
    timeout /t 1 >nul
)
cls
echo  Please check the following:
echo.
echo =========================================================================================================
echo                                                   Body                                                  
echo =========================================================================================================
echo.
echo  - No dents, cracks or missing pieces? 
echo.

:refurbConfirmBodyInput
SET /P T=Select an Option ( 1 - Pass / 2 - Fail / 3 - Run Test): 
IF "%T%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmBodyInput
)
IF "%T%"=="1" GOTO refurbConfirmBodyGradePass
IF "%T%"=="2" GOTO MENU
IF "%T%"=="3" GOTO refurbConfirmBodyTest

echo Invalid option, please try again.
echo.
GOTO refurbConfirmBodyInput


REM Redirecting to the first Body Grade Confirmation Menu (after pressing 1 to pass the test)
:refurbConfirmBodyGradePass
cls
color 0A
echo  Please inspect the laptop's exterior condition and assign a quality grade:
echo.
echo  A - Excellent: Like new - no visible wear. No scratches, dents, cracks, and minimal to no signs of previous use.
echo.
echo  B - Very Good: Light wear - minimal usage, may have tiny surface marks but no damage or flaws.
echo.
echo  C - Good/Used: Noticeable wear - visible scratches or small dents, but housing is fully intact and flaws are cosmetic only.
echo.
echo  D - Fair: Heavy wear - obvious use with dents, deep scratches, or faded surfaces. Still fully functional.
echo.
echo  F - Fail: Not suitable for donation - includes physical damage like cracks, missing keys, broken hinges, or exposed internals.
echo.
pause
echo.

:refurbConfirmBodyGradePassInput
set /p bodyGrade=Enter Laptop Body Grade (A, B, C, D, F): 
IF "%bodyGrade%"=="" (
    echo Invalid grade, please enter A, B, C, D, or F.
    echo.
    GOTO refurbConfirmBodyGradePassInput
)
IF /I "%bodyGrade%"=="A" GOTO refurbConfirmScrn
IF /I "%bodyGrade%"=="B" GOTO refurbConfirmScrn
IF /I "%bodyGrade%"=="C" GOTO refurbConfirmScrn
IF /I "%bodyGrade%"=="D" GOTO refurbConfirmScrn
IF /I "%bodyGrade%"=="F" GOTO refurbConfirmScrn

echo Invalid grade, please enter A, B, C, D, or F.
echo.
GOTO refurbConfirmBodyGradePassInput

REM Redirecting to the second Body Grade Confirmation Menu (after pressing 3 to run the test)
:refurbConfirmBodyTest
cls
color 0A
echo  Please inspect the laptop's exterior condition and assign a quality grade:
echo.
echo  A - Excellent: Like new - no visible wear. No scratches, dents, cracks, and minimal to no signs of previous use.
echo.
echo  B - Very Good: Light wear - minimal usage, may have tiny surface marks but no damage or flaws.
echo.
echo  C - Good/Used: Noticeable wear - visible scratches or small dents, but housing is fully intact and flaws are cosmetic only.
echo.
echo  D - Fair: Heavy wear - obvious use with dents, deep scratches, or faded surfaces. Still fully functional.
echo.
echo  F - Fail: Not suitable for donation - includes physical damage like cracks, missing keys, broken hinges, or exposed internals.
echo.
pause
echo.
set /p bodyGrade=Enter Laptop Body Grade (A, B, C, D, F): 
cls
echo  Please confirm you have checked the following:
echo.
echo =========================================================================================================
echo                                                   Body
echo =========================================================================================================
echo.
echo  - No dents, cracks or missing pieces? 
echo.

:refurbConfirmBodyTestInput
SET /P TT=Select an Option ( 1 - Pass / 2 - Fail ):  
IF "%TT%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmBodyTestInput
)
IF "%TT%"=="1" GOTO refurbConfirmScrn
IF "%TT%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO refurbConfirmBodyTestInput

REM Redirecting to the Screen Confirmation Menu
:refurbConfirmScrn
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo =========================================================================================================
echo                                                  Screen
echo =========================================================================================================
echo.
echo  - No screen defects or cracks?
echo.

:refurbConfirmScrnInput
SET /P U=Select an Option ( 1 - Pass / 2 - Fail / 3 - Run Test ): 
IF "%U%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmScrnInput
)
IF "%U%"=="1" GOTO refurbConfirmPorts
IF "%U%"=="2" GOTO MENU
IF "%U%"=="3" GOTO refurbConfirmScrnTest

echo Invalid option, please try again.
echo.
GOTO refurbConfirmScrnInput

REM Redirecting to the Screen Test Menu (after pressing 3 to run the test)
:refurbConfirmScrnTest
cls
color 0A
echo.
echo  Launching screen testing application. Please test the screen for dead pixels,
echo  color accuracy, brightness, or other defects by running through the following
echo  colors (Use the arrow keys to navigate or press each number to select the color):
echo.
echo  1 - Black
echo  2 - White
echo  3 - Red
echo  4 - Green
echo  5 - Blue
echo  ESC - Menu
echo  Q - Quit
echo.
pause
if exist %b2eincfilepath%\InjuredPixels.exe (
    "%b2eincfilepath%\InjuredPixels.exe"
) else (
    echo  Failed to launch screen testing application. Please ensure that it is in the correct directory.
    echo.
    echo  Press any key to continue to the next test.
    pause
    GOTO refurbConfirmPorts
)

:refurbConfirmScrnTestInput
SET /P UU=Did the screen pass all tests? ( 1 - Pass / 2 - Fail / 3 - Run Test Again): 
IF "%UU%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmScrnTestInput
)
IF "%UU%"=="1" GOTO refurbConfirmPorts
IF "%UU%"=="2" GOTO MENU
IF "%UU%"=="3" GOTO refurbConfirmScrnTest

echo Invalid option, please try again.
echo.
GOTO refurbConfirmScrnTestInput

REM Redirecting to the Ports Test Menu
:refurbConfirmPorts
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo =========================================================================================================
echo                                                   Ports
echo =========================================================================================================
echo.
echo  All ports are functional?
echo  - Charging Port
echo  - USB-A/USB-C
echo  - Video Out (HDMI/DP/VGA/DVI)
echo  - 3.5mm Headphone Jack
echo  - Ethernet
echo.

:refurbConfirmPortsInput
SET /P V=Select an Option ( 1 - Pass / 2 - Fail / 3 - Run Test ): 
IF "%V%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmPortsInput
)
IF "%V%"=="1" GOTO refurbConfirmTPad
IF "%V%"=="2" GOTO MENU
IF "%V%"=="3" GOTO refurbConfirmPortsTestCharging

echo Invalid option, please try again.
echo.
GOTO refurbConfirmPortsInput

REM Redirecting to the Completed Ports Test Menu (after completing the test)
:refurbConfirmPorts2
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo =========================================================================================================
echo                                                   Ports
echo =========================================================================================================
echo.
echo  All ports are functional?
echo  - Charging Port
echo  - USB-A/USB-C
echo  - Video Out (e.g., HDMI, DisplayPort, VGA, DVI)
echo  - 3.5mm Headphone Jack
echo  - Ethernet
echo.

:refurbConfirmPortsInput2
SET /P V=Select an Option ( 1 - Pass / 2 - Fail ): 
IF "%V%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmPortsInput2
)
IF "%V%"=="1" GOTO refurbConfirmTPad
IF "%V%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO refurbConfirmPortsInput2

REM Redirecting to the Charging Port Test Menu
:refurbConfirmPortsTestCharging
cls
color 0A
echo.
echo =========================================================================================================
echo                                             Ports: Charging
echo =========================================================================================================
echo.
echo  Please plug in the corresponding charging cable with the correct wattage now and check if the laptop is charging correctly.
pause
echo.
echo  If the laptop is charging correctly, please select 1 to pass the test. If not, please select 2 to fail the test.
echo.

:refurbConfirmPortsTestChargingInput
SET /P VV=Select an Option ( 1 - Pass / 2 - Fail ): 
IF "%VV%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmPortsTestChargingInput
)
IF "%VV%"=="1" GOTO refurbConfirmPortsTestUSB
IF "%VV%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO refurbConfirmPortsTestChargingInput

REM Redirecting to the USB Port Test Menu
:refurbConfirmPortsTestUSB
cls
color 0A
echo.
echo =========================================================================================================
echo                                               Ports: USB
echo =========================================================================================================
echo.
echo  Launching USBDeview to test USB ports...
echo  Please connect and disconnect USB devices to verify port functionality.
echo.
pause
"%b2eincfilepath%\USBDeview.exe"
echo.
echo  If all USB ports are functional, please select 1 to pass the test. If not, please select 2 to fail the test.

:refurbConfirmPortsTestUSBInput
SET /P XX=Select an Option ( 1 - Pass / 2 - Fail ): 
IF "%XX%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmPortsTestUSBInput
)
IF "%XX%"=="1" GOTO refurbConfirmPortsTestVideo
IF "%XX%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO refurbConfirmPortsTestUSBInput

REM Redirecting to the Video Out Ports Test Menu
:refurbConfirmPortsTestVideo
cls
color 0A
echo.
echo =========================================================================================================
echo                                             Ports: Video Out
echo =========================================================================================================
echo.
echo  Please test all video out ports now (e.g., HDMI, DisplayPort, VGA, DVI).
echo  Connect the laptop to an external monitor or TV and verify that the display is working correctly.
pause
echo.
echo  If all video out ports are displaying correctly, please select 1 to pass the test. If not, please select 2 to fail the test.
echo.

:refurbConfirmPortsTestVideoInput
SET /P ZZ=Select an Option ( 1 - Pass / 2 - Fail ): 
IF "%ZZ%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmPortsTestVideoInput
)
IF "%ZZ%"=="1" GOTO refurbConfirmPortsTestAux
IF "%ZZ%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO refurbConfirmPortsTestVideoInput

REM Redirecting to the AUX Port Test Menu
:refurbConfirmPortsTestAux
cls
color 0A
echo.
echo =========================================================================================================
echo                                             Ports: 3.5mm AUX
echo =========================================================================================================
echo.
echo  Testing the 3.5mm headphone port now.
echo  Connect headphones or external speakers to the AUX port and verify that audio is playing correctly. 
echo  Press any key to continue once a device is connected.
echo.
pause
echo  Playing a test sound now to check the audio output.
powershell -c (New-Object Media.SoundPlayer "C:\Windows\Media\Alarm05.wav").PlaySync()
echo.
echo  If the 3.5mm port is working correctly, please select 1 to pass the test. If not, please select 2 to fail the test.
echo  If you need to hear the sound again, please select 3.
echo.

:refurbConfirmPortsTestAuxInput
SET /P AAA=Select an Option ( 1 - Pass / 2 - Fail / 3 - Run Test Again ): 
IF "%AAA%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmPortsTestAuxInput
)
IF "%AAA%"=="1" GOTO refurbConfirmPortsTestEthernet
IF "%AAA%"=="2" GOTO MENU
IF "%AAA%"=="3" GOTO refurbConfirmPortsReTestAux

echo Invalid option, please try again.
echo.
GOTO refurbConfirmPortsTestAuxInput

:refurbConfirmPortsReTestAux
color 0A
echo.
echo  Replaying test sound.
powershell -c (New-Object Media.SoundPlayer "C:\Windows\Media\Alarm05.wav").PlaySync()
echo.
echo  If the 3.5mm port is working correctly, please select 1 to pass the test. If not, please select 2 to fail the test.
echo  If you need to hear the sound again, please select 3.
echo.
GOTO refurbConfirmPortsTestAuxInput

REM Redirecting to the Ethernet Test Menu
:refurbConfirmPortsTestEthernet
cls
color 0A
echo.
echo =========================================================================================================
echo                                             Ports: Ethernet
echo =========================================================================================================
echo.
echo  Testing the Ethernet port now.
echo  Connect an Ethernet cable to the port and verify that the laptop connects to the network successfully.
echo.
echo  You can check the network status in the system tray or by running a ping test.
pause
echo.
echo  If the Ethernet port is working correctly, please select 1 to pass the test. If not, please select 2 to fail the test.
echo.

:refurbConfirmPortsTestEthernetInput
SET /P EE=Select an Option ( 1 - Pass / 2 - Fail ): 
IF "%EE%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmPortsTestEthernetInput
)
IF "%EE%"=="1" GOTO refurbConfirmPorts2
IF "%EE%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO refurbConfirmPortsTestEthernetInput

REM Redirecting to the Touchpad Diagnostic Confirmation Menu
:refurbConfirmTPad
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo =========================================================================================================
echo                                                Touchpad
echo =========================================================================================================
echo.
echo  The touchpad is working correctly?
echo  - Left Click
echo  - Right Click
echo  - General Mouse Movement
echo.

:refurbConfirmTPadInput
SET /P W=Select an Option ( 1 - Pass / 2 - Fail ): 
IF "%W%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmTPadInput
)
IF "%W%"=="1" GOTO refurbConfirmKey
IF "%W%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO refurbConfirmTPadInput

REM Redirecting to the Keyboard Diagnostic Confirmation Menu
:refurbConfirmKey
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo =========================================================================================================
echo                                                Keyboard
echo =========================================================================================================
echo.
echo  - All keys are present and working as intended?
echo  - No stuck or unresponsive keys?
echo  - Special keys (e.g., Function keys, Num Lock, Caps Lock) are working?
echo.
echo  If you need to test the keyboard, select option 3 to launch the keyboard testing tool.
echo.

:refurbConfirmKeyInput
SET /P X=Select an Option ( 1 - Pass / 2 - Fail / 3 - Run Test ): 
IF "%X%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmKeyInput
)
IF "%X%"=="1" GOTO refurbConfirmBatt
IF "%X%"=="2" GOTO MENU
IF "%X%"=="3" GOTO tKeyboard2

echo Invalid option, please try again.
echo.
GOTO refurbConfirmKeyInput

REM Redirecting to the Battery Diagnostic Confirmation Menu
:refurbConfirmBatt
cls
color 0A
echo.
echo  Checking battery health, please wait...
echo =========================================================================================================
echo                                             Battery Health
%b2eincfilepath%\BatteryInfoView.exe /stext %HOMEDRIVE%\batteryhealth.txt
powershell -NoProfile -ExecutionPolicy Bypass -File "%b2eincfilepath%\bHealth2.ps1"
echo =========================================================================================================
echo.
REM Run the PowerShell script and capture the battery health percentage
for /f "tokens=*" %%A in ('powershell -NoProfile -ExecutionPolicy Bypass -File "%b2eincfilepath%\bHealth.ps1"') do (
    set "batteryHealth=%%A"
)

REM Extract the numeric value from the output (assuming the script outputs a percentage like "Battery Health: 75%")
for /f "tokens=2 delims=:" %%B in ("%batteryHealth%") do (
    set "batteryHealthValue=%%B"
)

REM Remove the % symbol and any leading/trailing spaces
set "batteryHealthValue=%batteryHealthValue:~1,-1%"
set "batteryHealthValue=%batteryHealthValue: =%"

REM Check if the battery health is above or below 60%
:refurbConfirmBattInput
echo Device battery health is %batteryHealthValue%%%.
echo.
echo If the battery health is above 60%, please select 1 to pass the test. If not, please select 2 to fail the test.
echo.
set /P proceed=Would you like to proceed with diagnostics? ( 1 / 2 ): 
IF "%proceed%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmBattInput
)
IF "%proceed%"=="1" GOTO refurbConfirmSpeakers
IF "%proceed%"=="2" GOTO MENU

echo Invalid option, please try again.
echo.
GOTO refurbConfirmBattInput

REM Redirecting to the WiFi and Bluetooth Diagnostic Confirmation Menu
:refurbConfirmWiFiBT
cls
color 0A
echo  Please confirm you have checked the following:
echo =========================================================================================================
echo                                             WiFi + Bluetooth
echo =========================================================================================================
echo.
echo  - Shows local SSIDs and connects to networks successfully? Bluetooth working?
echo.

:refurbConfirmWiFiBTInput
SET /P Z=Select an Option ( 1 - Pass / 2 - Fail / 3 - Run Test ): 
IF "%Z%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmWiFiBTInput
)
IF "%Z%"=="1" GOTO refurbConfirmSpeakers
IF "%Z%"=="2" GOTO MENU
IF "%Z%"=="3" GOTO tWiFiBTMenu2

echo Invalid option, please try again.
echo.
GOTO refurbConfirmWiFiBTInput

REM Redirecting to the Speaker Diagnostic Confirmation Menu
:refurbConfirmSpeakers
cls
color 0A
echo.
echo =========================================================================================================
echo                                                Speakers
echo =========================================================================================================
echo.
echo  Testing the internal speakers now.
echo  Playing a test sound to verify functionality.
echo.
powershell -c (New-Object Media.SoundPlayer "C:\Windows\Media\Alarm05.wav").PlaySync()
pause
echo  If the speakers are working correctly, please select 1 to pass the test. If not, please select 2 to fail the test. 
echo  If you need to hear the test sound again, please select 3 to run the test again.
echo.

:refurbConfirmSpeakersInput
SET /P AA=Select an Option ( 1 - Pass / 2 - Fail / 3 - Run Test Again ):  
IF "%AA%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmSpeakersInput
)
IF "%AA%"=="1" GOTO refurbConfirmCamMic
IF "%AA%"=="2" GOTO MENU
IF "%AA%"=="3" GOTO refurbConfirmSpeakers

echo Invalid option, please try again.
echo.
GOTO refurbConfirmSpeakersInput

REM Redirecting to the Camera and Microphone Diagnostic Confirmation Menu
:refurbConfirmCamMic
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo =========================================================================================================
echo                                            Webcam + Microphone
echo =========================================================================================================
echo.
echo  - Internal webcam operational and working as intended?
echo  - Internal microphone working and not muffled or crackling?
echo.

:refurbConfirmCamMicInput
SET /P BB=Select an Option ( 1 - Pass / 2 - Fail / 3 - Run Test ):  
IF "%BB%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmCamMicInput
)
IF "%BB%"=="1" GOTO refurbConfirmWinUpd
IF "%BB%"=="2" GOTO MENU
IF "%BB%"=="3" GOTO tCamMic2

echo Invalid option, please try again.
echo.
GOTO refurbConfirmCamMicInput

REM Redirecting to the Windows Update Diagnostic Confirmation Menu
:refurbConfirmWinUpd
cls
color 0A
echo  Please confirm you have checked the following:
echo.
echo =========================================================================================================
echo                                             Windows Updates
echo =========================================================================================================
echo.
echo  - Critical Windows Updates have been successfully installed?
echo.

:refurbConfirmWinUpdInput
SET /P CC=Select an Option ( 1 - Pass / 2 - Fail / 3 - Run Test ):  
IF "%CC%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmWinUpdInput
)
IF "%CC%"=="1" GOTO refurbConfirmWinAct
IF "%CC%"=="2" GOTO MENU
IF "%CC%"=="3" GOTO refurbConfirmWinUpdCheck

echo Invalid option, please try again.
echo.
GOTO refurbConfirmWinUpdInput

REM Checking and Installing Windows Updates
:refurbConfirmWinUpdCheck
cls
color 0A
echo Checking for and installing Windows Updates. Please wait...
start ms-settings:windowsupdate
usoclient startinteractivescan
usoclient scaninstallwait
usoclient resumeupdate
pause
echo.
echo Returning to Windows Updates Diagnostic Menu:
for /l %%i in (3,-1,1) do (
    echo %%i...
    timeout /t 1 >nul
)
GOTO refurbConfirmWinUpd

REM Redirecting to the Windows Activation Diagnostic Confirmation Menu
:refurbConfirmWinAct
cls
color 0A
echo =========================================================================================================
echo                                            Windows Activation
echo =========================================================================================================
echo.
echo  Retrieving Windows Activation Key and Activation Status...
echo.
color 0A
echo.
cscript //nologo "%b2eincfilepath%\WinAct.vbs"
color 0A
echo.
echo  Is Windows activated?
echo.

:refurbConfirmWinActInput
SET /P DD=Select an Option ( 1 - Pass / 2 - Fail / 3 - Re-Run Test ):  
IF "%DD%"=="" (
    echo Invalid option, please try again.
    echo.
    GOTO refurbConfirmWinActInput
)
IF "%DD%"=="1" GOTO refurbPreTask
IF "%DD%"=="2" GOTO MENU
IF "%DD%"=="3" GOTO refurbConfirmWinAct

echo Invalid option, please try again.
echo.
GOTO refurbConfirmWinActInput

REM Completed all diagnostics and checks
:refurbPreTask
cls
color 0A
echo.
echo  Diagnostics have successfully completed and all tests have passed!
echo.
echo  Press any key to confirm donation validity and finalize refurbishment. The computer will restart.
echo.
pause
GOTO refurbTask

REM Runs C4P Clean-Up and generates the Passed.txt file on the desktop
:refurbTask
cls
color 0A

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

REM Generates the Passed.txt file on the desktop with the diagnostics results
echo =========================================================================================================
echo                            Generating Passed Refurbishment Report to Desktop...                          
echo =========================================================================================================
echo ...................................................................................................................... > "%USERPROFILE%\Desktop\Passed.txt"
echo  This computer has been fully assessed by the C4P Team and >> "%USERPROFILE%\Desktop\Passed.txt"
echo  all diagnostics have successfully passed inspection on: >> "%USERPROFILE%\Desktop\Passed.txt"
echo.>> "%USERPROFILE%\Desktop\Passed.txt"
echo  Date: %DATE% >> "%USERPROFILE%\Desktop\Passed.txt"
echo  Time: %formattedTime% >> "%USERPROFILE%\Desktop\Passed.txt"
echo  Asset Tag: %barcode% >> "%USERPROFILE%\Desktop\Passed.txt"
echo  Refurbisher: %name% >> "%USERPROFILE%\Desktop\Passed.txt"
echo.>> "%USERPROFILE%\Desktop\Passed.txt"
echo ====================================================================================================================== >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                  DEVICE DIAGNOSTICS CHECKS                                               >> "%USERPROFILE%\Desktop\Passed.txt"
echo ====================================================================================================================== >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                       Body - Passed                                                       >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                       Body Grade: %bodyGrade%                                              >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                      Screen - Passed                                                   >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                       Ports - Passed                                                   >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                      Touchpad - Passed                                                  >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                      Keyboard - Passed                                                  >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                      Battery - Passed                                                  >> "%USERPROFILE%\Desktop\Passed.txt"
powershell -NoProfile -ExecutionPolicy Bypass -File "%b2eincfilepath%\bHealth1.ps1" >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                       Ports - Passed                                                   >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                  WiFi + Bluetooth - Passed                                              >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                      Speakers - Passed                                                 >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                       Webcam - Passed                                                  >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                      Microphone - Passed                                                >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                    Windows Update - Passed                                              >> "%USERPROFILE%\Desktop\Passed.txt"
echo ...................................................................................................................... >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                  Windows Activation - Passed                                            >> "%USERPROFILE%\Desktop\Passed.txt"
echo ====================================================================================================================== >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                           ALL CHECKS PASSED, SUITABLE FOR DONATION                                     >> "%USERPROFILE%\Desktop\Passed.txt"
echo ====================================================================================================================== >> "%USERPROFILE%\Desktop\Passed.txt"
echo                                                    SYSTEM SPECIFICATIONS                                               >> "%USERPROFILE%\Desktop\Passed.txt"
echo ====================================================================================================================== >> "%USERPROFILE%\Desktop\Passed.txt"
powershell -NoProfile -ExecutionPolicy Bypass -File "%b2eincfilepath%\BasicSysInfo.ps1" >> "%USERPROFILE%\Desktop\Passed.txt"
endlocal
GOTO MENU

REM Redirecting to the Restart Menu
:RESTART
cls
color 0A 
shutdown.exe /f /r
EXIT /B

REM Redirecting to the Shutdown Menu
:SHUTDOWN
cls
color 0A
shutdown.exe /s /f
EXIT /B

REM Redirecting to the Close Menu
:CLOSE
cls
color 0A
EXIT /B
