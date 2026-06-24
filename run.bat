@echo off
echo Copying URL file...
copy "%~dp0url.txt" "%TEMP%\download_url.txt"

if not exist "%TEMP%\download_url.txt" (
    echo URL file not found!
    pause
    exit /b 1
)

echo Running installer...
cscript.exe //nologo "%~dp0installer.vbs"

if errorlevel 1 (
    echo Installer failed!
    pause
    exit /b 1
)

echo Done!
