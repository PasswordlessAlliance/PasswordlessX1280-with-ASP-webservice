<%@ codepage="949" language="VBScript" %>
<%
id = session("id")
IF id <> "" THEN
	response.redirect("/main.asp")
END IF
%>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<link rel="shortcut icon" href="/image/icon/favicon.png" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="/css/style.css" />
<title>Passwordless X1280 - REST API</title>
<style>
.pwless_info{top: 213px; left: 155px; width: 350px;padding: 15px 20px 30px;border-radius: 4px;position: absolute;border: 1px solid #7599ff; background: #ffffff; font-size: 12px;line-height: 15px; font-weight: 400; display:none;}
.pwless_info .cbtn_ball{ display:block; text-align:right;     margin: 0 0 10px;}
.pwless_info .cbtn_ball img{ height:24px;}
.pwless_info:before{    position: absolute;right: 210px;top: 0;margin-top: -16px;border-top: 8px solid transparent;border-right: 8px solid transparent;border-bottom: 8px solid #7599ff;border-left: 8px solid transparent;content: "";}
</style>
<style>
.sample_site{ padding: 2em;  text-align: center; width: 80%;  margin: 0 0 0 0;}
</style>
</head>
<body>
<div class=" main_container">
	<div class="modal">
		<div class="sample_site" sylte="margin: -150px 0 0 0;">
			<div style="width:100%;">
				<ul>
					<li>
						<a href="/login.asp" style="background-color:#ffffff;"><img src="/image/pl_logo.png">
							<p>
							<span>Experience fast authentication with PasswordlessX1280</span>
							<span>This is a technology in which an online service presents a one-time password to the user without the user entering it, and then the user verifies it with the PasswordlessX1280 app.</span>
							<em class="btn">Experience it</em>
							</p>
						</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>