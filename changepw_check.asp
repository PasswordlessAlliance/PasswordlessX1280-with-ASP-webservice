<%@ codepage="949" language="VBScript" %>
<!-- #include virtual="/common/dbcon.asp"-->
<!-- #include virtual="/common/passwordless_log.asp"-->
<!-- #include virtual="/common/passwordless_config.asp"-->
<%
id = Trim(Request("id"))
pwd = Trim(Request("pw"))

DebugLog("[CHANGEPW] id [" & id & "] pw [" & pwd & "]")

sql = "select id from userinfo where id='" & id & "'"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.open sql, db, 1

is_exist = false
result = ""

If rs.recordcount > 0 Then
	is_exist = true
End If

If is_exist = true Then

	sql = "update userinfo set pwd='" & pwd & "' where id='" & id & "'"
	db.execute sql
	result = "OK"
	
Else

	result = "ID [" & id & "] does not exist."

End If

Set rs = nothing
Set DBConn = nothing

Set oJSON = New aspJSON
With oJSON.data
	.Add "data", oJSON.Collection()
	With oJSON.data("data")
		.Add "result", result
	End With
End With

xmlhttp_result = oJSON.JSONoutput()
response.write xmlhttp_result

DebugLog("[CHANGEPW] result [" & xmlhttp_result & "]")

Response.end
%>