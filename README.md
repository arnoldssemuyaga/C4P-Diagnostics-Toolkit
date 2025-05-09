# 💻 C4P Diagnostics Toolkit

![License](https://img.shields.io/github/license/arnoldssemuyaga/C4P-Diagnostics-Toolkit?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Windows-blue?style=flat-square)
![Made With](https://img.shields.io/badge/Built%20With-Batch%20%26%20PowerShell-lightgrey?style=flat-square)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=flat-square)

The **C4P Diagnostics Toolkit** is a standalone executable designed to assist in the refurbishment and quality assurance of laptops. It provides a user-friendly interface for performing various diagnostic tests, generating reports, and ensuring that laptops meet the required standards for donation or reuse.

---

## 🎯 Purpose

This toolkit automates the process of testing and verifying key laptop components—hardware, software, and system configurations. It finishes with a clean-up process that removes setup files, generates a summary report, and prepares the laptop for deployment.

> 🔒 **Note:** This tool is specifically built to run on a fresh install of the **Dual Windows 10/11 C4P image**.

---

## ✨ Features

The executable includes the following embedded tools, extracted to a temporary directory during runtime:

- 🔋 **BatteryInfoView** — Detailed battery health reports  
- ⌨️ **KeyboardTester** — Test all keys, including function and special keys  
- 📶 **WiFiView** — Scan and view nearby WiFi networks  
- 📡 **BTView** — Scan and diagnose Bluetooth devices  
- 🖥️ **InjuredPixels** — Dead pixel and display quality test  
- 🔌 **USBDeview** — Test USB port functionality  
- 📜 **Custom PowerShell Scripts** — Gather system specs, battery data, and more

> All tools run seamlessly from the toolkit with no extra setup required.

---

## 🧭 Main Menu Options

#0 Finalize Refurbishment and Start C4P Clean-Up

#1 Check Battery Health (BatteryInfoView)

#2 Test Keyboard

#3 Test Camera and Microphone

#4 Test WiFi and Bluetooth

#5 Verify Windows Activation

#6 System Information

#7 Generate Windows Battery Report

#8 Open Generated Battery Report

🔁 Enter `r` to Restart  ⏻ Enter `s` to Shutdown  ❌ Enter `c` to Close the Tool

---

## 🔍 Diagnostics Section (`#0`)

Running the **Finalize Refurbishment** option initiates a guided checklist to test:

| Component             | Description                                                                |
|-----------------------|----------------------------------------------------------------------------|
|      🖥️  Body        |            Check dents, cracks, missing parts, and assign a grade          |
|      💡  Screen       |            Verify no cracks, and run dead pixel test                       |
|      🔌  Ports       |            Test all I/O ports including USB, video, audio, Ethernet        |
|      🖱️  Touchpad     |            Test click functions and cursor movement                        |
|      ⌨️ Keyboard     |            Check all keys including special keys                           |
|      🔋  Battery      |            Review battery health with BatteryInfoView                      |
| 📶 WiFi/📡 Bluetooth |            Check connectivity and scan nearby devices                      |
|      🔊  Speakers    |            Play a sound to confirm output                                  |
|   📷 Webcam/🎤 Mic   |            Launch camera and sound settings for testing                   |
|  🛠️ Windows Updates  |            Confirm installation of essential updates                       |
|    ✅  Activation    |            Check Windows activation status                                 |

📄 After all tests, a report (`Passed.txt`) is created on the desktop summarizing all results.

---

## 🧹 Clean-Up Script (Final Step)

Executed after diagnostics, `Clean-Up.bat` performs:

1. 🗑️ **Deletes** temp files, scripts, and diagnostics tools  
2. 🔧 **Resets** Windows Update to "Notify before download"  
3. ⚡ **Enables** Hibernate & Fast Startup  
4. 🧠 **Applies** registry tweaks for optimization  
5. 🔁 **Restarts** Windows Explorer  
6. 🔄 **Reboots** system after notifying user  
7. 🧨 **Self-deletes** the script to leave no traces  

> 🔒 *This script is only available in the internal version with the Dual C4P image. Link:* https://github.com/Computers-4-People/Dual-Windows-C4P-Installer

---

## 🚀 How to Use

1. 🛑 Run the executable **as Administrator**  
2. 📋 Follow on-screen instructions  
3. ✅ Select diagnostics or start full refurbishment (`#0`)  
4. 🧼 Complete steps and let the tool prepare the system

---

## 📦 Requirements

- No dependencies — all tools are included and auto-extracted during runtime.

---

## 📄 License

This project is licensed under the [GPL 3.0 License](LICENSE).

---

## 🙌 Credits

Built and maintained by **Arnold Ssemuyaga**  
Made for the **Computers 4 People** refurbishment pipeline
