<!-- #include virtual="/common/aspJson.asp"-->
<!-- #include virtual="/common/passwordless_log.asp"-->
<%
passwordless_recommand = "1"												' Passwordless X1280 recommended spec. (Cannot use ID/PWD when Passwordless login) - 1:Passwordless login only, 0:ID/PWD login available
server_name = "PasswordlessX1280"											' decrypt log

'Passwordless URL		
isApUrl = "/ap/rest/auth/isAp"												' Passwordless API - isAp
joinApUrl = "/ap/rest/auth/joinAp"											' Passwordless API - joinAp
withdrawalApUrl = "/ap/rest/auth/withdrawalAp"								' Passwordless API - withdrawalAp
getTokenForOneTimeUrl = "/ap/rest/auth/getTokenForOneTime"					' Passwordless API - getTokenForOneTime
getSpUrl = "/ap/rest/auth/getSp"											' Passwordless API - getSp
resultUrl = "/ap/rest/auth/result"											' Passwordless API - result
cancelUrl = "/ap/rest/auth/cancel"											' Passwordless API - cancel

full_url = "http://your-passwordlessX1280-domain:11040"						' Passwordless auth server
serverId = "Set your server ID"												' Passwordless server id
serverKey = "Set your server key"											' Passwordless server key
ip = Request.ServerVariables("REMOTE_ADDR")									' Client IP
%>
