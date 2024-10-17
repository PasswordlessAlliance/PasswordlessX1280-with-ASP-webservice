<%@ codepage="949" language="VBScript" %>
<!-- #include virtual="/common/dbcon.asp"-->
<!-- #include virtual="/common/passwordless_log.asp"-->
<!-- #include virtual="/common/passwordless_config.asp"-->
<%
dbPwd = ""
result = ""
id = Trim(Request("id"))
pw = Trim(Request("pw"))

DebugLog("[LOGIN] id [" & id & "] pw [" & pw & "]")

sql = "select id, pwd from userinfo where id='" & id & "'"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.open sql, db, 1

If rs.recordcount = 1 Then
	dbPwd = rs("pwd")
End If

Set rs = nothing
Set DBConn = nothing

If dbPwd <> "" Then

	If pw = dbPwd Then
	
		' Passwordless X1280 recommended specifications (Unable to log in with ID/password when registering Passwordless X1280) - 1:Activated, 0:Inactivated
		If passwordless_recommand = "1" Then
		
			api_url = full_url & "/ap/rest/auth/isAp"
			params = "userId=" & m_id
			code = ""
			msg = ""

			dim DataToSend
			dim xmlhttp
			dim xmlhttp_result

			DataToSend = params

			Set xmlhttp = server.Createobject("MSXML2.ServerXMLHTTP")
				xmlhttp.Open "POST", api_url, false
				xmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
				xmlhttp.send DataToSend
				xmlhttp_result = xmlhttp.responseText
			Set xmlhttp = nothing
			DebugLog("[LOGIN] isAp RESULT [" & xmlhttp_result & "]")
			
			Set oJSON = New aspJSON
			oJSON.loadJSON(xmlhttp_result)
			code = oJSON.data("code")
			msg = oJSON.data("msg")
			
			DebugLog("[LOGIN] code [" & code & "] msg [" & msg & "]")
			
			exist = false
			If code = "000" or code = "000.0" Then
				exist = oJSON.data("data").item("exist")
			End If
		
		End If
		
		If exist = true Then
			' Passwordless X1280 registered ID & recommended specifications activated
			result = "REGISTERED"
		Else
			' Login OK
			result = "OK"
			session("id") = id
		End If

	Else
		'Wrong Password
		result = "CHECK"
	End If

Else
	' Wrong ID
	result = "CHECK"
End If

Set oJSON = New aspJSON
With oJSON.data
	.Add "data", oJSON.Collection()
	With oJSON.data("data")
		.Add "result", result
	End With
End With

xmlhttp_result = oJSON.JSONoutput()
response.write xmlhttp_result

DebugLog("[LOGIN] result [" & xmlhttp_result & "]")

Response.end
%>