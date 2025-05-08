
# C4P Diagnostic Tool – Changelog

**Developer:** Arnold Ssemuyaga  
**Purpose:** Post-setup hardware and system validation for refurbishing Windows laptops  
**Languages:** Batch, PowerShell  
**Project Start Date:** January 2025  
**Current Version:** v1.5  
**Status:** In Development  
:---------------------------------------------------------------------------------------------------
## v0.1 (Early Internal Build)
- Designed a minimal batch interface structured around a numbered menu system. Each option led to a separate diagnostic or utility task.
- The script was integrated into the post-Windows deployment environment using SetupComplete.cmd to ensure automatic launch on first login.
- Added basic diagnostic routines for the keyboard (external tool), battery health (BatteryInfoView), and system specs (systeminfo, PowerShell).
- Enabled simple ping-based WiFi connectivity checks and launched Windows Camera for webcam testing.

**Micro Commits:**
- Initial commit: added MENU layout and basic navigation.
- Basic support for BatteryInfoView and `systeminfo` retrieval.

**Known Issues & Limitations:**
- No fallback logic if diagnostic tools are missing from expected directories.

**Detailed Changelog**
- Designed a minimal menu-driven Batch script to navigate between basic diagnostic functions.
- Integrated the script into the Windows deployment workflow so it would auto-launch post-setup.
- **Keyboard:** Uses a third-party keyboard test tool
- **Camera and Microphone:** Uses a Portable Camera tool or Windows Camera
- **WiFi:** Uses a ping to 8.8.8.8 to test network connectivity
- **Battery:** Uses BatteryInfoView to export batteryhealth.txt, a PowerShell script reads the Battery Health value and displays it. The script then determines whether it is 60% or above, and continues or stops diagnostics based on this.
- Created menu options for generating and opening the built-in Windows battery report using `powercfg /batteryreport`.
- **System Info:** Uses the `systeminfo` command
- **Detailed System Info:** Displays CPU, GPU, motherboard name, and RAM using PowerShell.
- Implemented Windows Activation status check.
- Added manual shutdown and restart functions.
:---------------------------------------------------------------------------------------------------
## v1.0 (Public Internal Release)
- Released a cleaner version with improved user flow and intuitive navigation between different diagnostics and system tools.
- Introduced reliable exit paths, better fail-safe structures, and a clearer layout to help technicians understand diagnostics expectations.
- Refined the overall tool consistency, removing redundant or unclear prompts and adding more explicit instructions for test outcomes.

**Micro Commits:**
- Polished main menu design with uniform spacing.
- Refactored shutdown and restart logic into reusable function blocks.

**Known Issues & Limitations:**
- Camera tool occasionally fails to launch from some device builds.

**Detailed Changelog**
- Released the first fully functional version with a polished menu layout and improved menu navigation.
:---------------------------------------------------------------------------------------------------
## v1.1
- Cleaned up interface and reduced dependency on outdated tools like the Portable Camera tester, which lacked full mic testing support.
- Expanded PowerShell output to include motherboard and GPU information, which helped to quickly show all system specifications in a centralized location.
- Made small refinements to improve diagnostic coverage and output quality from PowerShell scripts.

**Micro Commits:**
- Removed deprecated Portable Camera tool.
- Added PowerShell fallback for system spec parsing.

**Known Issues & Limitations:**
- DISM-based default browser check not supported on newer Windows builds.

**Detailed Changelog**
- Removed Portable Camera tool due to lack of microphone testing capability.
- Expanded system info to include motherboard, GPU, and memory type via PowerShell.
:---------------------------------------------------------------------------------------------------
## v1.2
- Designed the refurb flow concept to digitize the C4P QA checklist. This new logic sequence was placed under Option #0.
- This allowed staff to formally validate device condition across critical categories (body, screen, ports, battery) within the script itself.
- A summary file (`Passed.txt`) was introduced to log basic diagnostics completion, creating a form of audit trail for refurbished machines.

**Micro Commits:**
- Created option #0 to replicate physical QA checklist.
Link: https://docs.google.com/document/d/1Kpm2P4787T_GRvwosgPtFBS1aq-QCjJc-mQaWSITl_A/edit?usp=sharing
- Basic version of `Passed.txt` generator completed.

**Known Issues & Limitations:**
- `Passed.txt` file occasionally overwrites previous version without prompt.

**Detailed Changelog**
- Introduced option #0: Refurb checklist menu mirroring the physical C4P QA checklist.
- Created the first `Passed.txt` generator to confirm diagnostics were run.
:---------------------------------------------------------------------------------------------------
## v1.3
- Developed a fully guided diagnostic checklist into the tool, requiring user input and validation for each component test.
- Added structured prompts for asset tag input, technician name, and grading of body condition from A–F.
- Introduced interactive test modules for ports (USB, HDMI, AUX, Ethernet), with step-by-step prompts and feedback suggestions.
- Integrated logic to track battery health, speaker response, webcam/mic function, and WiFi/Bluetooth connectivity.
- Output now includes a timestamp and full report of system specs, technician name, date, time, and diagnostic test results.
- Expanded logic to detect missing hardware gracefully and provide context-aware feedback instead of crashing or failing silently.

**Micro Commits:**
- Added multi-step refurb flow with name and asset tag.
- Introduced %formattedTime% logic for readable timestamps.

**Known Issues & Limitations:**
- Ethernet test fails silently on devices without port.
- Menu input error if users press Enter without selection.
- Windows Update PowerShell script not functioning properly

**Detailed Changelog**
- Implemented refurb flow for technician name, asset tag, and checklist items.
- Expanded `Passed.txt` to include detailed results and timestamps.
- Added A–F grading for Body diagnostics.
- Added USB/HDMI/AUX/Ethernet port testing sequence with feedback.
- Speaker diagnostics added with playback and retry option.
- Timestamp logic `%formattedTime%` added (12h format).
- First logic for auto Windows Update check added (PowerShell).
- WiFi and Bluetooth tests enhanced using WiFiView and BTView.
- Failover logic for missing tools integrated.
- Added `Clean-Up.bat` to delete logs, tools, and shortcuts on finalization.
:---------------------------------------------------------------------------------------------------
## v1.4
- Converted the batch script into a portable .EXE, embedding the entire diagnostics logic and dependencies for portability.
- Refactored how the tool handles temporary files and diagnostics logs—moved `Clean-Up.bat` to a permanent path for better execution.
- Improved robustness of PowerShell logic for Windows Activation detection and refined battery test flow with fallback protection.
- Created countdown timers to warn users of audio or battery tests.
- Integrated logic to delete traces left behind by diagnostics like Camera/Microphone use.
- Added checks for services like `usoclient` to confirm update status, replacing fragile PowerShell-only checks.

**Micro Commits:**
- Recompiled script with embedded payloads.
- Overhauled activation detection logic for better Windows 11 support.

**Known Issues & Limitations:**
- Minor delay when exiting compiled .exe during cleanup.
- WiFiView occasionally requires admin elevation on Windows 11.

**Detailed Changelog**
- Converted to compiled `.exe`, embedding all necessary executables and scripts.
- Spacing and readability improved across all menus.
- Countdown timer added before launching certain tests.
- Camera/mic tests improved to allow re-run from refurb menu.
- Windows Activation check improved with `WMI` (PowerShell) for newer builds.
- Windows Update logic replaced with `usoclient` for consistency.
- Battery % over 100 no longer causes false failures—prompts user.
- Crash prevention added for missing `batteryhealth.txt`—will always generate before diagnostic test.
- Relocated Clean-Up.bat from being embedded to `C:\` (on Dual C4P Windows image) for consistent path execution.
- Camera/mic usage traces now cleaned during cleanup.
- AUX port crash bug fixed.
- Menu loops finalized for complete diagnostic flow.
:---------------------------------------------------------------------------------------------------
## v1.5
- Implemented backend logic in PowerShell to verify Bluetooth and WiFi functionality by checking drivers, services, and connectivity.
- Updated the refurb checklist to allow launching tests from within each section, streamlining technician workflows.
- Began experimenting with a self-deleting `.exe` function by dropping a scheduled task or Startup `.bat`, which removes tool after use.
- Improved test fallback and navigation. Invalid input detection now provides helpful redirection to main menu or last valid point.

**Micro Commits:**
- Improved logic flow on all test categories.
- Better fallback handling if BatteryInfoView fails to launch.

**Known Issues & Limitations:**
- Self-deletion script doesn't work.

**Detailed Changelog**
- WiFi/Bluetooth now checked using PowerShell:
  - Confirms drivers
  - Checks if services (`bthserv`, `wlan`) are running
  - Displays status or failure message
- Refurb menu now supports in-line test re-entry (e.g. "Run Test" reopens tool).
:---------------------------------------------------------------------------------------------------
## v1.6 (Planned)
- Relocate `%formattedTime%` logic to the menu loop so the timestamp updates every time the user returns to the main menu.
- Streamline diagnostics so tools like KeyboardTest.exe can be launched directly from the refurb menu without going through an extra submenu.
- Refine refurbishment confirmation generator logic so tests for missing hardware (e.g., no Ethernet) are recorded as "N/A" rather than "Passed", improving report accuracy.
- Develop a `.bat` file that generates on-the-fly and deletes the `.exe` and all related diagnostics files after reboot via `shell:startup`.
- Change `WinAct.vbs` to show activation status in first dialog.
:---------------------------------------------------------------------------------------------------
## Future Goals
- Rebuild GUI version in PowerShell using WinForms or WPF.
- Create installer with version-checking and USB deployment support.
- Add CLI tools like HWiNFO64 or BatteryMon for deeper diagnostics.
- Enable cloud upload of logs (`Passed.txt`, results) via SMB or SFTP.
- Generate branded “Donation Ready” certificate (PDF or HTML) with QR code.
- Track technician metrics (e.g., average test duration, skipped sections).
- Add percentage-based cleanup progress visual for clarity.
:---------------------------------------------------------------------------------------------------
