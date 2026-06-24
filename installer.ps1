# Check if running with elevated privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Restart with elevation
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Read URL from file
$tempPath = $env:TEMP
$urlFile = "$tempPath\download_url.txt"
$installerPath = "$tempPath\installer.exe"

$downloadUrl = Get-Content $urlFile

# Download using Invoke-WebRequest (more reliable than XMLHTTP)
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing
    
    # Run installer silently
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
    
    # Clean up
    Remove-Item $installerPath -Force
    Remove-Item $urlFile -Force
} catch {
    # Log error to temp file
    "Error: $_" | Out-File "$tempPath\install_error.txt"
}
