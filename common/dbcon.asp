<% session.CodePage = "949" %>
<% Response.CharSet = "EUC-KR" %>
<%
dim dbIp, dbName, dbId, dbPwd
dbIp = "127.0.0.1" 
dbName = "passwordlessx1280" 
dbId = "passwordless" 
dbPwd = "pwl1280!!" 

Set db = Server.CreateObject("ADODB.Connection")
strconnect = "Provider=SQLOLEDB.1;Persist Security Info=False;User ID="&dbId&";Initial Catalog="&dbName&";Data Source="&dbIp&";Password="&dbPwd
db.Open strconnect
%>