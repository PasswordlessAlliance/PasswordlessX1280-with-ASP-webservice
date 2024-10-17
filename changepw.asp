<%@ codepage="949" language="VBScript" %>
<!-- #include virtual="/common/passwordless_config.asp"-->
<!DOCTYPE html>
<html>
<head>
<title>Passwordless X1280 - REST API</title>
<script src="/js/jquery-3.6.0.min.js"></script>
<link rel="shortcut icon" href="/image/icon/favicon.png" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="/css/style.css" />
</head>
<body>
<div class=" main_container">
	<div class=" main_container">
		<div class="modal">
			<div class="login_article">
				<div class="title"><em style="width:100%; text-align:center;">Forgot your password?</em></div>
				<div class="content">
					<div>
						<form>
							<div class="input_group">
								<input type="text" id="id" placeholder="ID" />
							</div>
							<div class="input_group">
								<input type="password" id="pw" placeholder="PASSWORD" />
							</div>
							<div class="input_group">
								<input type="password" id="pw_re" placeholder="Confirmation PASSWORD" />
							</div>
						</form>
					</div>
					<div class="btn_zone">
						<a href="javascript:join();" class="btn active_btn">Save</a>
						&nbsp;
						<a href="/login.asp" class="btn active_btn">Cancel</a>
					</div>           
				</div>
			</div>
		</div>
		<div class="modal_bg"></div>
	</div>
</div>
</body>

<script>
$(document).ready(function() {
	$("#id").focus();
})

function trim(stringToTrim) {
    return stringToTrim.replace(/^\s+|\s+$/g,"");
}

function join() {
	id = $("#id").val();
	pw = $("#pw").val();
	pw_re = $("#pw_re").val();
	name = $("#name").val();
	
	id = trim(id);
	pw = trim(pw);
	pw_re = trim(pw_re);
	name = trim(name);

	$("#id").val(id);
	$("#pw").val(pw);
	$("#pw_re").val(pw_re);
	$("#name").val(name);

	if(id == "") {
		alert("Please enter your ID.");
		$("#id").focus();
		return false;
	}

	if(pw == "") {
		alert("Please enter a password.");
		$("#pw").focus();
		return false;
	}

	if(pw_re == "") {
		alert("Please enter confirmation password.");
		$("#pw_re").focus();
		return false;
	}
	
	if(pw != pw_re) {
		alert("Passwords do not match.");
		$("#pw_re").val("");
		$("#pw_re").focus();
		return false;
	}
	
	if(name == "") {
		alert("Please enter your name.");
		$("#name").focus();
		return false;
	}

	$.ajax({
		url: "/changepw_check.asp",
		method: 'POST',
		dataType: 'json',
		data : {
			id : id,
			pw : pw,
			name : name
		},
		async: false,
		success: function(res) {
			data = res.data;
			console.log(data);
			console.log("result [" + data.result + "]");
			if(data.result == "OK") {
				alert("Password has been changed.");
            	location.href = "/login.asp";
			}
			else {
				alert(data.result);
			}
		},
		error: function(xhr, status, error) {
			console.log("[ERROR] code: " + xhr.status + ", message: " + xhr.responseText + ", status: " + status + ", ERROR: " + error);
		},
		complete: function(res) {
		}
	});
}
</script>

</html>
