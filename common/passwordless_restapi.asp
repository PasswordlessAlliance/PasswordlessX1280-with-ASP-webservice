<%@ codepage="949" language="VBScript" %>
<!-- #include virtual="/common/dbcon.asp" -->
<!-- #include virtual="/common/passwordless_config.asp" -->
<%
api_url = ""
id = ""
pwd = ""
QRReg = ""

url = Trim(Request("url"))
params = Trim(Request("params"))

DebugLog("[REST API] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> url [" & url & "] params [" & params & "]")

tmpParams = Split(params, "&")
For i=0 To UBound(tmpParams)
	tmpKey = Split(tmpParams(i), "=")
	
	Select case tmpKey(0)
		case "id"		id = tmpKey(1)
		case "pw"		pwd = tmpKey(1)
		case "QRReg"	QRReg = tmpKey(1)
	End Select
Next

DebugLog("[REST API] url [" & url & "] params [" & params & "] id [" & id & "] pwd [" & pwd & "]")

' ------------------------------------------------------------------------------------------- User Check

' Passwordless config check
sessionUserToken = session("PasswordlessToken")
sessionTime = session("PasswordlessTime")
userToken = Request("token")
matchToken = false
matchPasswd = false
userExist = false

If sessionUserToken <> "" and sessionUserToken = userToken Then
	matchToken = true
End If

' Check password when QR reg/unreg
gapTime = 9999999
If Len(sessionTime) > 0 Then
	gapTime = ((Timer * 1000) mod 100000000) - sessionTime
End If

DebugLog("[REST API] Token [" & sessionUserToken & "], sessionTime [" & sessionTime & "] gap [" & gapTime & "sec]")

If url = "joinApUrl" or url = "withdrawalApUrl" Then
	If matchToken = false Then
		msg = "This is not a normal user."
	End If
End If

session("PasswordlessTime") = (Timer * 1000) mod 100000000

' User info check
sql = "select id, pwd from userinfo where id='" & id & "'"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.open sql, db, 1

' Password check
If rs.recordcount > 0 Then
	userExist = true
	db_pwd = rs("pwd")
	
	DebugLog("[REST API] USER pwd [" & pwd & "] DB pwd [" & db_pwd & "]")
	
	If pwd = rs("pwd") Then
		matchPasswd = true
	End If
End If

DebugLog("[REST API] id [" & id & "] pwd [" & pwd & "] userExist [" & userExist & "] matchPasswd [" & matchPasswd & "]")

' ------------------------------------------------------------------------------------------- Passwordless

' API check
Select case url
	case "isApUrl"					api_url = isApUrl
	case "joinApUrl"				api_url = joinApUrl
	case "withdrawalApUrl"			api_url = withdrawalApUrl
	case "getTokenForOneTimeUrl"	api_url = getTokenForOneTimeUrl
	case "getSpUrl"					api_url = getSpUrl
	case "resultUrl"				api_url = resultUrl
	case "cancelUrl"				api_url = cancelUrl
	case "mngToken"					api_url = "manageToken" ' Login: Passwordless reg/unreg --> password check
	
End select

DebugLog("[REST API] api_url [" & api_url & "]")

If api_url <> "" Then

	Select case api_url
	
		case "manageToken"
		
			tmpTime = 0
			tmpToken = ""
			resultStr = "OK"
			
			If matchPasswd = true Then
				tmpTime = getMillisec()
				tmpToken = GetNewPassword(1)
			ELSE
				resultStr = "CHECKIDPW"
			End If
			
			DebugLog("[REST API] result [" & resultStr & "] token [" & tmpToken & "] time [" & tmpTime & "]")
			
			Set oJSON = New aspJSON
			With oJSON.data
			
				.Add "result", resultStr
				.Add "data", oJSON.Collection()
				
				With oJSON.data("data")
				
					.Add "PasswordlessToken", tmpToken
					.Add "PasswordlessTime", tmpTime
					
				End With
				
			End With
		
			xmlhttp_result = oJSON.JSONoutput()
			DebugLog("[REST API] Response [" & xmlhttp_result & "]")
			response.write xmlhttp_result

		case Else:
	
			api_url = full_url & api_url
			params = Replace(params, "id=", "userId=")
			sessionId = getMillisec() & "_sessionId"
			
			' Passwordless auth
			If url = "getSpUrl" Then
				params = params & "&clientIp=" & ip & "&sessionId=" & sessionId & "&random=" & random & "&password="
			End If

			DebugLog("[REST API] userExist [" & userExist & "] ip [" & ip & "] api_url [" & api_url & "] params [" & params & "]")

			If userExist = true Then
				token = ""
				oneTimeToken = ""
				newToken = ""
				
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
				DebugLog("[REST API] RESULT [" & xmlhttp_result & "]")
				
				' Passwordless reg check
				If url = "isApUrl" Then
				
					' password change
					If QRReg = "T" Then

						new_password = GetNewPassword(0)
						sql="update userinfo set pwd='" & new_password & "' where id='" & id & "'"
						db.execute sql
						DebugLog("[REST API] QRReg --> Change password [" & new_password & "]")
						
					End If
					
				' Request OneTimeToken
				ElseIf url = "getTokenForOneTimeUrl" Then
					
					If xmlhttp_result <> "" Then
						
						Set oJSON = New aspJSON
						oJSON.loadJSON(xmlhttp_result)
						code = oJSON.data("code")
						msg = oJSON.data("msg")
						DebugLog("[REST API] code [" & code & "] msg [" & msg & "]")

						If code = "000" or code = "000.0" Then

							token = oJSON.data("data").item("token")
							DebugLog("[REST API] encrypted token [" & token & "]")

							newToken = ""

							' Decrypt OneTimeToken
							Dim oShell, sCommand
							sCommand = Server.MapPath("/") & "\decrypt\decrypt.exe " & serverKey & " " & token
							Set oShell = Server.CreateObject("WScript.Shell")
							Set oExec = oShell.exec(sCommand)

							DebugLog("[REST API] sCommand [" & sCommand & "]")

							Do While oExec.Status = 0
							Loop

							newToken = oExec.stdout.readall
							newToken = replace(newToken, VbCr, "")
							newToken = replace(newToken, VbLf, "")
							newToken = replace(newToken, VbCrLf, "")
							
							DebugLog("[REST API] decrypted token [" & newToken & "]")
						
							oJSON.data("data").item("token") = newToken
							xmlhttp_result = oJSON.JSONoutput()

						End If

					End If

				' Passwordless login
				ElseIf url = "getSpUrl" Then
					DebugLog("[REST API] getSpUrl [" & xmlhttp_result & "]")
					
					Set oJSON2 = New aspJSON
					oJSON2.loadJSON(xmlhttp_result)
					oJSON2.data("sessionId") = sessionId
					xmlhttp_result = oJSON2.JSONoutput()
				
				' Login request accept check
				ElseIf url = "resultUrl" Then
					
					If xmlhttp_result <> "" Then
						
						Set oJSON = New aspJSON
						oJSON.loadJSON(xmlhttp_result)
						code = oJSON.data("code")
						msg = oJSON.data("msg")
						DebugLog("[REST API] code [" & code & "] msg [" & msg & "]")

						If code = "000" or code = "000.0" Then

							auth = oJSON.data("data").item("auth")
							DebugLog("[REST API] auth [" & auth & "]")

							' Login approval
							If auth = "Y" Then
								
								session("id") = id
								
								' Change password
								new_password = GetNewPassword(0)

								sql="update userinfo set pwd='" & new_password & "' where id='" & id & "'"
								db.execute sql
								DebugLog("[REST API] Login --> Change password [" & new_password & "]")
								
							End If
							
						End If
						
						xmlhttp_result = oJSON.JSONoutput()
						
					End If
				
				' Passwordless unregist - logout
				ElseIf url = "withdrawalApUrl" Then
				
					session("id") = ""
					Session.Abandon

				End If
				
				DebugLog("[REST API] Response [" & xmlhttp_result & "]")
				response.write xmlhttp_result

			Else
				Set oJSON = New aspJSON
				With oJSON.data
				
					.Add "result", "CHECKID"
					.Add "data", ""
					
				End With
			
				xmlhttp_result = oJSON.JSONoutput()
				DebugLog("[REST API] Response [" & xmlhttp_result & "]")
				response.write xmlhttp_result
			End If
			
	End Select

End If

Set rs = nothing
Set db = nothing

DebugLog("[REST API] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< [" & url & "]")

' ------------------------------------------------------------------------------------------- Function

' Get millisecond from now
Function getMillisec()
	getMillisec = (Timer * 1000) mod 100000000
End Function

' Create random value
Function GetNewPassword(isSimple)
	Dim Rand_Str, Str_Len, New_password
	
	If isSimple = 0 Then
		Rand_Str = "!@#$%^&*()0123456789!@#$%^&*()abcdefghijklmnopqrstuvwxyz!@#$%^&*()0123456789!@#$%^&*()abcdefghijklmnopqrstuvwxyz!"
	Else
		Rand_Str = "01234567890123456789abcdefghijklmnopqrstuvwxyz012345678901234567890"
	End If
	
	For i=1 To 12
		Randomize()
		New_password = New_password & Mid(Rand_Str, (Rnd() * Len(Rand_str)) + 1, 1)
	Next
	GetNewPassword = New_password
End Function
%>