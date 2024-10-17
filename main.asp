<%@ codepage="949" language="VBScript" %>
<%
id = session("id")

If id = "" Then
	response.redirect("/login.asp")
End If
%>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<link rel="shortcut icon" href="/image/icon/favicon.png" type="image/x-icon" />
<link rel="stylesheet" type="text/css" href="/css/style.css" />
<title>Passwordless X1280 - REST API</title>
<style>
.sample_site{ padding: 2em;  text-align: center; width: 80%;  margin: 0 0 0 0;}
.sample_site li p{width: 500px; text-decoration: none; color: #333333; padding: 30px 30px 30px; border: 1px solid #e1e1e1; box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.15); border-radius: 10px; }
.sample_site li a{width: 500px; text-decoration: none; color: #333333; padding: 0px 0px 0px; border: 1px solid #e1e1e1; box-shadow: 0px 0px 8px rgba(0, 0, 0, 0.15); border-radius: 10px; }
.sample_site li .btn{line-height: 20px; font-size: 17px; padding: 17px 40px; font-weight: 500; display: inline-block; margin: 0 auto; background: #4ea1ff; margin: 15px 0 0 0; border-radius: 8px; color: #ffffff;}
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
						<p style="background-color:#ffffff;">
							<strong>Experience fast authentication with PasswordlessX1280</strong>
							<span>This is a technology in which an online service presents a one-time password to the user without the user entering it, and then the user verifies it with the PasswordlessX1280 app.</span>
							<a href="javascript:logout();"><em class="btn" id="btn_logout">Logout</em></a>
							&nbsp;
							<a href="javascript:withdraw();"><em class="btn" id="btn_delete">Withdraw</em></a>
						</p>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>

<script>
$("#btn_logout").click(function(e){
	console.log("Logout");
});

function logout() {
	$.ajax({
        url : "/logout.asp",
        type : "post",
        success : function(res) {
            location.href = "/";
        },
        error : function(res) {
            alert(res.msg);
        },
        complete : function() {
        }
    });
}

function withdraw() {
	if(confirm("Are you sure you want to withdraw?")) {
		$.ajax({
	        url : "/withdraw.jsp",
	        type : "post",
	        success : function(res) {
	        	if(res.result == "OK")
	        		alert("Membership withdrawal has been completed.");
	        	
	            location.href = "/";
	        },
	        error : function(res) {
	            alert(res.msg);
	        },
	        complete : function() {
	        }
	    });
	}
}
</script>
</html>