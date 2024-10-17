<%
Sub DebugLog(msg)
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim fso, f,path2logfile

yyyy = Year(now)

tmp_mm = Month(now)
If tmp_mm < 10 Then
mm = "0" & tmp_mm
Else
mm = tmp_mm
End If

tmp_dd = Day(now)
If tmp_dd < 10 Then
dd = "0" & tmp_dd
Else
dd = tmp_dd
End If

path2logfile = Server.MapPath("\common") & "\passwordless_" & yyyy & mm & dd & "_log.txt"

Set fso = Server.CreateObject("Scripting.FileSystemObject")

Set f = fso.OpenTextFile(path2logfile, ForAppending, True)
f.WriteLine now & " : " & msg
f.Close
Set fso = Nothing
End Sub
%>