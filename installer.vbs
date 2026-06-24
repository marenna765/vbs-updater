' --------------------------------------------------------------------------
'  Silent Installer - Enterprise Monitor Agent
' --------------------------------------------------------------------------
Option Explicit

' Check for elevation
If Not WScript.Arguments.Named.Exists("elevated") Then
    CreateObject("Shell.Application").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevated", "", "runas", 0
    WScript.Quit
End If

Dim strUrl, strTemp, strFile, objXMLHTTP, objADOStream, objFSO, objShell, objFile

' Read URL from file
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
strTemp = objShell.ExpandEnvironmentStrings("%TEMP%")

' Open and read the URL file
Set objFile = objFSO.OpenTextFile(strTemp & "\download_url.txt", 1)
strUrl = objFile.ReadAll
objFile.Close

' Set file path for installer
strFile = strTemp & "\agent_installer.exe"

' Download
Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
objXMLHTTP.open "GET", strUrl, False
objXMLHTTP.send()

' Handle redirects
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
    objADOStream.Position = 0 ' Reset position before saving
    objADOStream.SaveToFile strFile, 2 ' Overwrite
    objADOStream.Close
    
    ' Install
    Set objShell = CreateObject("WScript.Shell")
    objShell.Run """" & strFile & """ /S", 0, True
    
    ' Cleanup
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    If objFSO.FileExists(strFile) Then objFSO.DeleteFile strFile
    If objFSO.FileExists(strTemp & "\download_url.txt") Then objFSO.DeleteFile strTemp & "\download_url.txt"
End If
