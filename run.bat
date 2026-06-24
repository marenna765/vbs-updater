@echo off
copy "%~dp0url.txt" "%TEMP%\download_url.txt" >nul
cscript.exe //nologo "%~dp0installer.vbs"
