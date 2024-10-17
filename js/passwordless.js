var selPasswordNo = 1;	// 1:password, 2:passwordless, 3:passwordless manage
var timeoutId = null;
var check_millisec = 0;
var passwordless_terms = 0;
var passwordless_milisec = 0;
var pushConnectorUrl = "";
var pushConnectorToken = "";
var sessionId = "";
var loginStatus = false;
var checkType = "";	// login: "LOGIN", QR-Registration: "QR"

var str_login = "Login";
var str_cancel = "Cancel";
var str_title_password = "Password Login";
var str_title_passwordless = "Passwordless Login";
var str_passwordless_regunreg = "Passwordless Reg/Unreg";
var str_passwordress_notreg = "Passwordless registration is required.";
var str_input_id = "Please enter your ID.";
var str_input_password = "Please enter a password.";
var str_passwordless_blocked = "Passwordless account has been suspended.\nContact your account manager.";
var str_regrequest = "You are not registered for the Passwordless services.\nPasswordless registration is required.\nWould you like to register the Passwordless X1280 service?";
var str_login_expired = "Passwordless login time has expired.";
var str_login_canceled = "Authentication was canceled.";
var str_qrreg_expired = "Passwordless QR registration time has expired.";
var str_autootp_after_reg = "Passwordless service has been registered.\n\nLog in with the safe and convenient Passwordless X1280 app.\n\nWhile Passwordless service is registered,\nyou cannot log in with your ID/password.\n\nTo log in again with your ID/password,\ncancel the Passwordless service and then use it.";
var str_autootp_after_reg_new = "Passwordless service has been registered.\nLog in with the safe and convenient Passwordless X1280 app.\n\nWhen Passwordless service has been registered,\nyour password has been changed to a random value.\n\nTo log in again with your ID/password, use the \"Find Password\" function to reset your password and then log in.";
var str_passwordless_unreg = "Passwordless service has been canceled.\n\nYour password has been changed to a random value, so if you want to log in with your ID/password, use the \"Find Password\" function to reset your password and then log in.";
var str_autootp_unregquest = "Do you want to cancel Passwordless service?";
var str_try = "Try again later.";
var str_autootp_copy1 = "Server URL has been copied.";
var str_autootp_copy2 = "Register code has been copied.";
var str_reg_not_yet = "Passwordless service has not been registered yet.\nPlease scan the QR code in the Passwordless X1280 app.";
var str_accept_not_yet = "Still waiting for approval.\nPlease press the Approve button in the Passwordless X1280 app.";

$(document).ready(function() {

	passwordless = window.localStorage.getItem('passwordless');
	
	if(passwordless != "Y")
		selPassword(1);
	else
		selPassword(2);
	
	$("#id").focus();
})

function trim(stringToTrim) {
	if(stringToTrim != "")
    	return stringToTrim.replaceAll(/^\s+|\s+$/g,"");
    else
    	return stringToTrim;
}

function copyTxt1() {
	var tmpVal = $("#server_url").html();
	tmpVal = tmpVal.replaceAll(" ", "");
	var tempInput = document.createElement("input")
	tempInput.value = tmpVal;
	document.body.appendChild(tempInput);
	tempInput.select();
	document.execCommand("copy");
	document.body.removeChild(tempInput);
	alert(str_autootp_copy1);
}

function copyTxt2() {
	var tmpVal = $("#register_key").html();
	tmpVal = tmpVal.replaceAll(" ", "");
	var tempInput = document.createElement("input")
	tempInput.value = tmpVal;
	document.body.appendChild(tempInput);
	tempInput.select();
	document.execCommand("copy");
	document.body.removeChild(tempInput);
	alert(str_autootp_copy2);
}

// Select Password login/Passwordless login radio button
function selPassword(sel) {
	if(sel == 1) {
		if(loginStatus == true) {
			cancelLogin();
		}
		
		selPasswordNo = 1;
		$("#login_title").html(str_title_password);
		$("#selLogin1").prop("checked", true);
		$("#selLogin2").prop("checked", false);
		$("#pw").attr("placeholder", "PASSWORD");
		$("#pw").attr("disabled", false);
		$("#pw_group").show();
		$("#bar_group").hide();
		$("#login_bottom1").show();
		$("#login_bottom2").hide();

		$("#pw_group").show();
		$("#login_bottom1").show();
		
		window.localStorage.removeItem('passwordless');
	}
	else if(sel == 2) {
		selPasswordNo = 2;
		$("#login_title").html(str_title_passwordless);
		$("#selLogin1").prop("checked", false);
		$("#selLogin2").prop("checked", true);
		$("#pw").val("");
		$("#pw").attr("placeholder", "");
		$("#pw").attr("disabled", true);
		$("#pw_group").hide();
		$("#bar_group").show();
		$("#login_bottom1").hide();
		$("#login_bottom2").show();

		window.localStorage.setItem('passwordless', 'Y');
	}
	
	$("#passwordlessSelButton").show();
	$("#manage_bottom").hide();
	$("#passwordlessNotice").hide();
	$("#btn_login").html(str_login);
}

// Request Login
function login() {
	id = $("#id").val();
	pw = $("#pw").val();
	
	id = trim(id);
	pw = trim(pw);
	
	$("#id").val(id);
	$("#pw").val(pw);
	
	if(id == "") {
		alert(str_input_id);	// ID
		$("#id").focus();
		return false;
	}

	// Password ·Î±×ÀÎ
	if(selPasswordNo == 1) {
		if(pw == "") {
			alert(str_input_password);	// PASSWORD
			$("#pw").focus();
			return false;
		}
		
		$.ajax({
			url: "/login_check.asp",
			method: 'POST',
			dataType: 'json',
			data : {
				id : id,
				pw : pw
			},
			async: false,
			success: function(res) {
				data = res.data;
				console.log(data);
				console.log("result [" + data.result + "]");
				if(data.result == "OK") {
					location.href = "/";
				}
				else if(data.result == "REGISTERED") {
				}
				else {
					alert("Please check your ID or password");
				}
			},
			error: function(xhr, status, error) {
				console.log("[ERROR] code: " + xhr.status + ", message: " + xhr.responseText + ", status: " + status + ", ERROR: " + error);
			},
			complete: function(res) {
			}
		});
	}
	// Passwordless Login
	else if(selPasswordNo == 2) {
		if(loginStatus == true)
			cancelLogin();
		else
			loginPasswordless();
	}
	// Passwordless manage
	else if(selPasswordNo == 3) {
		managePasswordless();
	}
}

// ------------------------------------------------ Passwordless ------------------------------------------------

function callApi(data) {

	var ret_val = "";
	api_url = "/common/passwordless_restapi.asp";

	$.ajax({
		url: api_url,
		method: 'POST',
		dataType: 'json',
		data: data,
		async: false,
		success: function(data) {
			//console.log(data);
			if(data.result == "CHECKID")
				data.result = "Please check your ID";
			if(data.result == "CHECKIDPW")
				data.result = "Please check your ID or password";
			
			ret_val = data;
		},
		error: function(xhr, status, error) {
			console.log("[ERROR] code: " + xhr.status + ", message: " + xhr.responseText + ", status: " + status + ", ERROR: " + error);
		},
		complete: function(data) {
		}
	});
	
	return ret_val;
}

// Passwordless Login
function loginPasswordless() {
	checkType = "LOGIN";
	
	var existId = passwordlessCheckID("");
	console.log("existId=" + existId);
	
	if(existId == "T") {
		var token = getTokenForOneTime();
		
		if(token != "") {
			loginStatus = true;
			$("#btn_login").html(str_cancel);	// cancel
			loginPasswordlessStart(token);
		}
	}
	else if(existId == "F") {
		if(confirm(str_regrequest))
			moveManagePasswordless();
	}
	else {
		alert(existId);
	}
}

// Passwordless registered check
function passwordlessCheckID(QRReg) {
	var id = $("#id").val();
	var ret_val = "";
	var data = {
		url: "isApUrl",
		params: "id=" + id + "&QRReg=" + QRReg
	}
	
	var result = callApi(data);
	//console.log(result);
	
	if(result.result == true) {
		var resultData = result.data;
		var msg = result.msg;
		var code = result.code;
		
		//console.log("data=" + data);
		//console.log("msg [" + msg + "] code [" + code + "]");
		
		if(code == "000" || code == "000.0") {
			var exist = resultData.exist;
			if(exist)	ret_val = "T";
			else		ret_val = "F";
		}
		else {
			ret_val = msg;
		}
	}
	else if(result.result == "SLEEP") {
		ret_val = "S";
	}
	else {
		ret_val = result.result;
	}
	//console.log("ret_val=" + ret_val);
	
	return ret_val;
}

// onetime token request
function getTokenForOneTime() {

	var id = $("#id").val();
	var ret_val = "";
	var data = {
		url: "getTokenForOneTimeUrl",
		params: "id=" + id
	}
	
	var result = callApi(data);
	var msg = result.msg;
	var code = result.code;
	
	console.log("msg [" + msg + "] code [" + code + "]");
	
	if(code == "000" || code == "000.0") {
		var oneTimeToken = result.data.token;
		ret_val = oneTimeToken;
	}
	else {
		alert("Onetime Token Request error : [" + code + "] " + msg);
	}

	return ret_val;
}

function loginPasswordlessStart(token) {
	
	var id = $("#id").val();
	var data = {
		url: "getSpUrl",
		params: "id=" + id + "&token=" + token
	}
	
	var result = callApi(data);
	var msg = result.msg;
	var code = result.code;
	
	console.log("msg [" + msg + "] code [" + code + "]");
	console.log(result);
	
	if(code == "000" || code == "000.0") {
		var resultData = result.data;
		term = resultData.term;
		servicePassword = resultData.servicePassword;
		pushConnectorUrl = resultData.pushConnectorUrl;
		pushConnectorToken = resultData.pushConnectorToken;
		sessionId = result.sessionId;
		
		window.localStorage.setItem('session_id', sessionId);
		
		var today = new Date();
		passwordless_milisec = today.getTime();
		passwordless_terms = parseInt(term - 1);
		console.log("term=" + term + ", servicePassword=" + servicePassword);
		
		connWebSocket();
		drawPasswordlessLogin();
	}
	else if(code == "200.6") {
		sessionId = window.localStorage.getItem('session_id');
		//console.log("Already request authentication --> send [cancel], sessionId=" + sessionId);
		
		if(true || (sessionId !== undefined && sessionId != null && sessionId != "")) {
			var data = {
				url: "cancelUrl",
				params: "id=" + id + "&sessionId=" + sessionId
			}
			
			var result = callApi(data);
			var msg = result.msg;
			var code = result.code;
		
			if(code == "000" || code == "000.0") {
				window.localStorage.removeItem('session_id');
				setTimeout(() => loginPasswordlessStart(token), 500);
			}
			else {
				cancelLogin();
				alert(str_try);
			}
		}
		else {
			cancelLogin();
			alert(str_try);
		}
	}
	else if(code == "200.7") {
		cancelLogin();
		alert(str_passwordless_blocked);
	}
}

// OTP code & Timer
function drawPasswordlessLogin() {
	//console.log("----- drawPasswordlessLogin -----");

	var id = $("#id").val();
	var today = new Date();
	var gap_second = Math.ceil((today.getTime() - passwordless_milisec) / 1000);
	
	if(loginStatus == true) {
		if(gap_second < passwordless_terms) {
		
			var today = new Date();
			var now_millisec = today.getTime();
			var gap_millisec = now_millisec - check_millisec;
			
			if(gap_millisec > 1500) {
				check_millisec = today.getTime();
				//loginPasswordlessCheck();	// remove annotation when using polling method
			}
	
			gap_millisec = now_millisec - passwordless_milisec;
			var ratio = 100 - (gap_millisec / passwordless_terms / 1000) * 100 - 1;
			if(ratio > 0) {
				var tmpPassword = servicePassword;
				if(tmpPassword.length == 6)
					tmpPassword = tmpPassword.substr(0, 3) + " " + tmpPassword.substr(3, 6);
				
				if(loginStatus == true) {
					$("#passwordless_bar").css("width", ratio + "%");
					$("#passwordless_num").text(tmpPassword);
				}
			}
			
			timeoutId = setTimeout(drawPasswordlessLogin, 100);
		}
		else {
			if(timeoutId != null) {
				clearTimeout(timeoutId);
				timeoutId = null;
			}
			
			$("#passwordless_bar").css("width", "0%");
			$("#rest_time").html("0 : 00");
			
			setTimeout(() => alert(str_login_expired), 100);	// Passwordless login time expired
			setTimeout(() => cancelLogin(), 100);
		}
	}
}

// Wait for approval
function loginPasswordlessCheck() {
	//console.log("----- loginPasswordlessCheck -----");

	var today = new Date();
	var now_millisec = today.getTime();
	var gap_millisec = now_millisec - passwordless_milisec;
	
	if(gap_millisec < passwordless_terms * 1000 - 1000) {
		
		var id = $("#id").val();
		var data = {
			url: "resultUrl",
			params: "id=" + id + "&sessionId=" + sessionId
		}
		
		var result = callApi(data);
		var msg = result.msg;
		var code = result.code;
		
		if(code == "000" || code == "000.0") {
			
			var auth = result.data.auth;
			if(auth == "Y") {
				if(timeoutId != null) {
					clearTimeout(timeoutId);
					timeoutId = null;
				}
				window.localStorage.removeItem('session_id');
				
				location.href = "/";
				
			}
			else if(auth == "N") {
				cancelLogin();
				setTimeout(() => alert(str_login_canceled), 100);
			}
			else if(auth == "W") {
				alert(str_accept_not_yet);
			}
		}
		else {
			cancelLogin();
			alert(msg);
		}
	}
}

// Cancel Login
function cancelLogin() {
	
	loginStatus = false;

	if(timeoutId != null) {
		clearTimeout(timeoutId);
		timeoutId = null;
	}
	
	$("#btn_login").html(str_login);
	$("#passwordless_bar").css("width", "0%");
	$("#passwordless_num").text("--- ---");
	$("#login_mobile_check").hide();

	sessionId = window.localStorage.getItem('session_id');
	
	var id = $("#id").val();
	var data = {
		url: "cancelUrl",
		params: "id=" + id + "&sessionId=" + sessionId
	}
	
	var result = callApi(data);

	window.localStorage.removeItem('session_id');
}

// Open passwordless management page
function moveManagePasswordless() {
	selPasswordNo = 3;
	$("#passwordlessSelButton").hide();
	$("#login_bottom1").hide();
	$("#login_bottom2").hide();
	$("#bar_group").hide();
	$("#pw_group").show();
	$("#manage_bottom").show();
	$("#passwordlessNotice").show();
	$("#login_title").html(str_passwordless_regunreg);
	$("#btn_login").html(str_passwordless_regunreg);
	$("#pw").attr("placeholder", "PASSWORD");
	$("#pw").attr("disabled", false);
}

// Close passwordless management page
function moveBackSetting() {
	selPasswordNo = 2;

	$("#td_qr").hide();
	$("#reg_qr").hide();
	$("#unregist_qr").hide();

	$("#td_login").show();
	
	cancelManage();
}

// Passwordless management request
function managePasswordless() {
	
	id = $("#id").val();
	pw = $("#pw").val();
	
	id = trim(id);
	pw = trim(pw);
	
	$("#id").val(id);
	$("#pw").val(pw);
	
	if(id == "") {
		alert(str_input_id);	// ID
		$("#id").focus();
		return false;
	}

	if(pw == "") {
		alert(str_input_password);	// PASSWORD
		$("#pw").focus();
		return false;
	}
	
	var PasswordlessToken = "";
	
	var id = $("#id").val();
	
	var data = {
		url: "mngToken",
		params: "id=" + id + "&pw=" + pw
	}
	
	var result = callApi(data);
	
	console.log(result);
	if(result.result == "OK") {
		PasswordlessToken = result.data.PasswordlessToken;
		$("#passwordlessToken").val(PasswordlessToken);
		console.log("PasswordlessToken=" + PasswordlessToken);
	}
	else {
		alert(result.result);
		$("#pw").val("");
	}
	
	if(PasswordlessToken != "") {
		var existId = passwordlessCheckID("");
		console.log("existId=" + existId);
		
		$("#td_login").hide();
		$("#td_qr").show();
		
		if(existId == "T") {
			$("#login_content").hide();
			$("#passwordless_unreg_content").show();
		}
		else if(existId == "F") {
			getPasswordlessQRinfo(PasswordlessToken);
		}
		else {
			alert(existId);
		}
	}
}

// Passwordless registration QRCode request
function getPasswordlessQRinfo(PasswordlessToken) {
	
	checkType = "QR";

	var id = $("#id").val();
	var data = {
		url: "joinApUrl",
		params: "id=" + id + "&token=" + PasswordlessToken
	}
	
	var result = callApi(data);
	//console.log(result);
	var resultData = result.data;
	var msg = result.msg;
	var code = result.code;
	
	console.log(data);
	console.log("msg [" + msg + "] code [" + code + "]");
	
	if(code == "000" || code == "000.0") {
		console.log("------------ info -----------");
		console.log(resultData);
		
		var qr = resultData.qr;
		var corpId = resultData.corpId;
		var registerKey = resultData.registerKey;
		var terms = resultData.terms;
		var serverUrl = resultData.serverUrl;
		var userId = resultData.userId;
		
		var tmpRegisterKey = "";
		var tmpInterval = 4;
		for(var i=0; i<registerKey.length / tmpInterval; i++) {
			tmpRegisterKey = tmpRegisterKey + registerKey.substring(i*tmpInterval, i*tmpInterval + tmpInterval);
			if(registerKey.length > i*tmpInterval)
				tmpRegisterKey = tmpRegisterKey + " ";
		}
		registerKey = tmpRegisterKey;
		
		console.log("qr: " + qr);
		console.log("corpId: " + corpId);
		console.log("registerKey: " + registerKey);
		console.log("terms: " + terms);
		console.log("serverUrl: " + serverUrl);
		console.log("userId: " + userId);
		
		pushConnectorUrl = resultData.pushConnectorUrl;
		pushConnectorToken = resultData.pushConnectorToken;
		
		console.log("pushConnectorUrl: " + pushConnectorUrl);
		console.log("pushConnectorToken: " + pushConnectorToken);
		
		$("#login_content").hide();
		$("#passwordless_reg_content").show();
		
		$("#qr").prop("src", qr);
		$("#id").html(userId);
		$("#server_url").html(serverUrl);
		$("#register_key").html(registerKey);
		
		var today = new Date();
		passwordless_milisec = today.getTime();
		passwordless_terms = parseInt(terms - 1);
		check_millisec = today.getTime();
		
		connWebSocket();
		drawPasswordlessReg();
	}
	else {
		alert("[" + code + "] " + msg);
	}
}

function drawPasswordlessReg() {

	var id = $("#id").val();
	var today = new Date();
	var gap_second = Math.ceil((today.getTime() - passwordless_milisec) / 1000);
	
	if(gap_second < passwordless_terms) {
	
		var tmp_min = parseInt((passwordless_terms - gap_second) / 60);
		var tmp_sec = parseInt((passwordless_terms - gap_second) % 60);
		
		if(tmp_sec < 10)
			tmp_sec = "0" + tmp_sec;
		
		$("#rest_time").html(tmp_min + " : " + tmp_sec);
		
		timeoutId = setTimeout(drawPasswordlessReg, 300);
		
		var today = new Date();
		var now_millisec = today.getTime();
		var gap_millisec = now_millisec - check_millisec;
		if(gap_millisec > 1500) {
			check_millisec = today.getTime();
			//regPasswordlessOK();	// remove annotation when using polling method
		}
	}
	else {
		if(timeoutId != null) {
			clearTimeout(timeoutId);
			timeoutId = null;
		}
		
		$("#rest_time").html("0 : 00");
		
		$("#login_content").show();
		$("#passwordless_reg_content").hide();
		
		cancelSetting();
		setTimeout(() => alert(str_qrreg_expired), 100);
	}
}

function cancelSetting() {
	selPassword(2);
	
	$("#td_login").show();
	$("#login_button").show();
	
	$("#td_qr").hide();
	$("#reg_qr").hide();
	$("#login_mobile_check").hide();
	$("#passwordlessNotice").hide();
	$("#manage_bottom1").hide();
	$("#manage_bottom2").hide();
	
	cancelManage();
}

// Passwordless registration check
function regPasswordlessOK() {
	var existId = passwordlessCheckID("T");
	
	if(existId == "T") {
		clearTimeout(timeoutId);
		$("#login_content").hide();
		$("#passwordless_reg_content").show();
	
		cancelManage();
	}
}

// Passwordless service cancellation
function unregPasswordless() {
	var passwordlessToken = $("#passwordlessToken").val();
	var id = $("#id").val();
	var data = {
		url: "withdrawalApUrl",
		params: "id=" + id + "&token=" + passwordlessToken
	}
	
	var result = callApi(data);
	var msg = result.msg;
	var code = result.code;
	if(result.result == true) {
		if(code == "000" || code == "000.0") {
			window.localStorage.removeItem('passwordless');
			$("#td_qr").hide();
			$("#reg_qr").hide();
			$("#unregist_qr").hide();
			
			$("#td_login").show();
			
			selPassword(1);
			cancelManage();

			setTimeout(function() {
				alert(str_passwordless_unreg);
				
				$("#id").val("");
				location.href = "/";
			}, 100);
		}
		else {
			cancelManage();
			alert("[" + code + "] " + msg);
		}
	}
	else {
		cancelManage();
		alert(msg);
	}
}

// Passwordless Setting cancellation
function cancelManage() {
	
	if(timeoutId != null) {
		clearTimeout(timeoutId);
		timeoutId = null;
	}

	$("#pw").val("");
	$("#login_content").show();
	$("#passwordless_reg_content").hide();
	$("#passwordless_unreg_content").hide();
	$("#reg_mobile_check").hide();
	
	passwordless = window.localStorage.getItem('passwordless');
	
	if(passwordless != "Y")
		selPassword(1);
	else
		selPassword(2);
}

// Help
var showHelp = false;
function show_help() {
	if(showHelp == false) {
		$(".pwless_info").show();
		showHelp = true;
	}
	else {
		hide_help();
	}
}
function hide_help() {
	$(".pwless_info").hide();
	showHelp = false;
}

function mobileCheck() {
	if(checkType == "LOGIN")
		loginPasswordlessCheck();
	else if(checkType == "QR")
		regPasswordlessOK();
}

//-------------------------------------------------- WebSocket -------------------------------------------------

/*
	- WebSocket readyState
	  0 CONNECTING	The socket has been created, but the connection is not yet open.
	  1 OPEN		The connection is open and ready for communication.
	  2 CLOSING		The connection is being closed.
	  3 CLOSED		The connection was closed, or could not be opened.
*/

var qrSocket = null;
var result = null;

function connWebSocket() {

	qrSocket = new WebSocket(pushConnectorUrl);

	qrSocket.onopen = function(e) {
		console.log("######## WebSocket Connected ########");
		var send_msg = '{"type":"hand","pushConnectorToken":"' + pushConnectorToken + '"}';
		console.log("url [" + pushConnectorUrl + "]");
		console.log("send [" + send_msg + "]");
		qrSocket.send(send_msg);
	}

	qrSocket.onmessage = async function (event) {
		console.log("######## WebSocket Data received [" + qrSocket.readyState + "] ########");
		
		try {
			if (event !== null && event !== undefined) {
				result = await JSON.parse(event.data);
				if(result.type == "result") {
					if(checkType == "LOGIN")
						loginPasswordlessCheck();
					else if(checkType == "QR")
						regPasswordlessOK();
				}
			}
		} catch (err) {
			console.log(err);
		}
	}

	qrSocket.conclose = function(event) {
		if(event.wasClean)
			console.log("######## WebSocket Disconnected - OK !!! [" + qrSocket.readyState + "] ########");
		else
			console.log("######## WebSocket Disconnected - Error !!! [" + qrSocket.readyState + "] ########");

		console.log("=================================================");
		console.log(event);
		console.log("=================================================");
	}

	qrSocket.onerror = function(error) {
		console.log("######## WebSocket Error !!! [" + qrSocket.readyState + "] ########");
		console.log("=================================================");
		console.log(error);
		console.log("=================================================");

		$("#login_mobile_check").show();
		$("#reg_mobile_check").show();
	}
}