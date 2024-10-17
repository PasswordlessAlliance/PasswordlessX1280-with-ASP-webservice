<%@ codepage="949" language="VBScript" %>
<!-- #include virtual="/common/dbcon.asp"-->
<!-- #include virtual="/common/passwordless_log.asp"-->
<!-- #include virtual="/common/passwordless_config.asp"-->
<%
id = session("id")

If id <> "" Then
	response.redirect("/main.asp")
End If
%>
<html>
<head>
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
<script src="/js/jquery-3.6.0.min.js"></script>
<script src="/js/passwordless.js"></script>
<link rel="shortcut icon" href="/image/icon/favicon.png" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="/css/style.css" />
</head>

<body>
<div class=" main_container">
	<div class="modal">
		<div class="login_article">
			<div class="title"><em style="width:100%; text-align:center;" id="login_title" name="login_title"></em></div>
			<div class="content">
				<div id="login_content">
					<form id="frm">
						<div class="input_group">
							<input type="text" id="id" name="id" placeholder="ID" style="width:100%;" />
						</div>
						<div class="input_group" id="pw_group">
							<input type="password" id="pw" name="pw" placeholder="PASSWORD" style="width:100%;" />
						</div>
					</form>
					<div class="input_group" id="bar_group" style="display:none;">
						<div class="timer" id="bar_content" name="bar_content" style="position: relative; background: url('/image/timerBG.png') no-repeat center right; border-radius: 8px; background-size: cover;">
							<div class="pbar" id="passwordless_bar" style="background: rgb(55 138 239 / 70%); height: 50px;width: 100%;border-radius: 8px; animation-duration: 0ms; width:0%;"></div>
							<div class="OTP_num" id="passwordless_num" name="passwordless_num" style="text-shadow:2px 2px 3px rgba(0,0,0,0.7); top: 0; position: absolute; font-size: 22px; color: #ffffff; text-align: center; height:50px; width: 100%; line-height: 50px; font-weight: 800; letter-spacing: 1px;">
								--- ---
							</div>
						</div>
					</div>
					
					<div id="passwordlessSelButton" style="height:30px;margin-top:10px;margin-bottom:10px;">
						<div style="text-align: center;">
							<span style="display:inline-block; padding: 6px 10px 16px 10px; text-align:right;">
								<label for"selLogin1" style="margin:0;padding:0;font-family: 'Noto Sans KR', sans-serif;font-weight:300;font-size:medium;">
									<input type="radio" id="selLogin1" name="selLogin" value="1" onchange="selPassword(1);" checked>
									Password
								</label>
							</span>
							<span style="display:inline-block; padding: 6px 10px 16px 10px; text-align:right;">
								<label for"selLogin2" style="margin:0;padding:0;font-family: 'Noto Sans KR', sans-serif;font-weight:300;font-size:medium;">
									<input class="radio_btn" type="radio" id="selLogin2" name="selLogin" value="2" onchange="selPassword(2);">
									Passwordless
								</label>
							</span>
							<span style="display:inline-block; padding: 6px 10px 16px 10px; text-align:right;">
								<a href="javascript:show_help();" class="cbtn_ball"><img src="/image/help_bubble.png" style="width:16px; height:16px; border:0;"></a>
							</span>
						</div>
					</div>
					
					<div class="pwless_info">
						<a href="javascript:hide_help();" class="cbtn_ball"><img src="/image/ic_fiicls.png" height="20" alt=""></a>
						<p>
							The Passwordless service is a free authentication service that offers security and convenience.
							<br><br>
							To use the Passwordless service, install the Passwordless X1280 app on your smartphone and then scan the QR code to sign-in.
							<br>
							<br>
							<p style="width:100%;text-align:center;font-size:140%;font-weight:800;">
								<font color="#5555FF">Passwordless X1280 Mobile App</font>
								<br>
								<br>
								<a href="https://apps.apple.com/us/app/autootp/id1290713471" target="_new_app_popup"><img src="/image/app_apple_icon.png" style="width:45%;"></a>
								&nbsp;
								<a href="https://play.google.com/store/apps/details?id=com.estorm.autopassword" target="_new_app_popup"><img src="/image/app_google_icon.png" style="width:45%;"></a>
								<br>
								<img src="/image/app_apple_qr.png" style="width:45%;">
								&nbsp;
								<img src="/image/app_google_qr.png" style="width:45%;">
							</p>
							<br>
							The Passwordless service provided is based on the standard technology recommended as X.1280 by ITU-T, a international technical standards organization under the UN. This online service is currently offering it to users for free.
							<br>
							<br>
							Create your own safe and convenient online service with Passwordless!
						</p>
					</div>
					
					<div id="passwordlessNotice" style="display:none;">
						<div style="text-align: center;line-height:24px;">
							To register/unregister the passwordless<br>service, user verification is required.
						</div>
					</div>
					
					<div class="btn_zone">
						<a href="javascript:login();" class="btn active_btn" id="btn_login">Login</a>
					</div>
					<div class="btn_zone" id="login_mobile_check" name="login_mobile_check" style="display:none;">
						<a href="javascript:mobileCheck();" class="btn active_btn">Confirm after mobile authentication</a>
					</div>
					
					<div class="menbership" id="login_bottom1" name="login_bottom" style="text-align:center;">
						<a href="./join.asp">Create Account</a>
						<a href="./changepw.asp">Forgot your password?</a>
					</div>
					<div class="menbership" id="login_bottom2" name="login_bottom" style="text-align:center;">
						<a href="./join.asp">Create Account</a>
						<a href="javascript:moveManagePasswordless();"><font style="font-weight:800;">Passwordless Reg/Unreg</font></a>
					</div>
					<div class="menbership" id="manage_bottom" name="manage_bottom" style="display:none;text-align:center;">
						<a href="./changepw.asp">Forgot your password?</a>
						<a href="javascript:cancelManage();"><font style="font-weight:800;">Login</font></a>
					</div>
				</div>
				
				<div id="passwordless_reg_content" style="display:none;">
					<div style="text-align:center;">
						<span style="width:100%; text-align:center; font-weight:500; font-size:24px;">
							<br>
							Registering the Passwordless Services
						</span>
						<br>
						<img id="qr" name="qr" src="" width="300px" height="300px" style="display:inline-block;margin-top:10px;">
						<p style="width:100%; padding:0% 0%; font-weight:500; font-size:16px; line-height:24px;">
							After installing the Passwordless X1280 app on your smartphone, please scan the QR code.
						</p>
						<br>
						<span style="display:inline-block; width:100%; font-size:18px; padding:10px; margin-bottom:20px;">
							<div style="gap: 10px;display: flex; justify-content: center; margin:8px 0; font-size:13px;">
								<div style="width:88%; text-align:left;">
									<span style="width:30%;">[ Server URL ]</span>
									<span id="server_url" name="server_url" style="font-weight:800;"></span></div>
								<div style="width:10%;"><img src="/image/ic-copy.png" onclick="javascripit:copyTxt1();"></div>
							</div>
							<div style="gap: 10px;display: flex; justify-content: center; margin:8px 0; font-size:13px;">
								<div style="width:88%; text-align:left;">
									<span style="width:30%;">[ Register Code ]</span>
									<span id="register_key" name="register_key" style="font-weight:800;"></span></div>
								<div style="width:10%;"><img src="/image/ic-copy.png" onclick="javascripit:copyTxt2();"></div>
							</div>
							<br>
							<b><span id="rest_time" style="font-size:24px;text-shadow:1px 1px 2px rgba(0,0,0,0.9);color:#afafaf;"></span></b>
						</span>
					</div>
					<div class="btn_zone">
						<a href="javascript:cancelManage();" class="btn active_btn" id="btn_login">Cancel</a>
					</div>
					<div class="btn_zone" id="reg_mobile_check" name="reg_mobile_check" style="display:none;">
						<a href="javascript:mobileCheck();" class="btn active_btn">Confirm after mobile authentication</a>
					</div>
				</div>
				<input type="hidden" id="passwordlessToken" name="passwordlessToken" value="">
				<div id="passwordless_unreg_content" style="display:none;width:100%; text-align:center; font-weight:500; font-size:24px; line-height:35px;">
					Unregistering the Passwordless Services
					<br>
					<br>
					<div class="passwordless_unregist">
						<div style="padding: 0px;">
							<button type="button" id="btn_unregist" name="btn_unregist" style="height:120px; border-radius:4px; color:#FFFFFF; background:#3C9BEE; border-color:#3090E0; padding: 4px 20px; font-size: 20px; line-height:40px;">
								Passwordless service<br>unregistration
							</button>
						</div>
						<div>
							&nbsp;
							<br>
							<p style="width:100%; padding:0% 0%; font-weight:500; font-size:16px; line-height:24px;">
								If you unregister the Passwordless service, you will need to log in with your user password
							</p>
						</div>
						<br>
						<div class="btn_zone">
							<a href="javascript:cancelManage();" class="btn active_btn" id="btn_login">Cancel</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
<script>
var input = document.getElementById("id");
input.addEventListener("keyup", function (event) {
	if (event.keyCode === 13) {
		event.preventDefault();
		login();
	}
});

var input = document.getElementById("pw");
input.addEventListener("keyup", function (event) {
	if (event.keyCode === 13) {
		event.preventDefault();
		login();
	}
});

$("#btn_unregist").on("click", function(){
	if(confirm("Do you want to unregister Passwordless service?")) {
		unregPasswordless();
	}
})

</script>
</html>



</body>
</html>