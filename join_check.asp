<%@ codepage="949" language="VBScript" %>
<!-- #include virtual="/common/dbcon.asp"-->
<!-- #include virtual="/common/passwordless_log.asp"-->
<!-- #include virtual="/common/passwordless_config.asp"-->
<%
id = Trim(Request("id"))
pwd = Trim(Request("pw"))
name = Trim(Request("name"))

DebugLog("[JOIN] id [" & id & "] pw [" & pwd & "] name [" & name & "]")

sql = "select id from userinfo where id='" & id & "'"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.open sql, db, 1

is_exist = false
result = ""

If rs.recordcount > 0 Then
	is_exist = true
End If

If is_exist = false Then

	sql = "insert into userinfo (id, pwd, name) values('" & id & "', '" & pwd & "', '" & name & "')"
	db.execute sql
	result = "OK"
	
Else

	result = "ID [" & id & "] already exists. Please enter another ID."

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

DebugLog("[JOIN] result [" & xmlhttp_result & "]")

Response.end
%>