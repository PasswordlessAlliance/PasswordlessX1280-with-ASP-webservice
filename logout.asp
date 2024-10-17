<%@ codepage="949" language="VBScript" %>
<!-- #include virtual="/common/passwordless_log.asp"-->
<%
id = session("id")
DebugLog("[LOGOUT] id [" & id & "]")
session("id") = ""
%>