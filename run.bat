@echo off
copy "%~dp0url.txt" "%TEMP%\download_url.txt" >nul
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -Command "& { [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; & '%~dp0installer.ps1' }"
