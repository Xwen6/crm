<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="static/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="static/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>

		function login(){
			//判断用户名是否有特殊字符的正则表达式
			var UsernameRgeExp = /^[a-zA-Z0-9]+$/
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());
			if (loginAct === "" ||loginPwd === ""){
				$("#msg").html("");
				$("#msg").html("账号密码不能为空");
				return false;
			}
			//判断用户名是否在6-14位之间
		  else if($.trim($("#loginAct").val()).length<6||$.trim($("#loginAct").val()).length>14){
				$("#msg").html("用户名要在6-14位之间");
			}

			//alert(!(UsernameRgeExp.test(usname)))
			else if(!(UsernameRgeExp.test($.trim($("#loginAct").val())))){
				$("#msg").html("用户名只能由数字和字母组成");
			}
			else{
				$.ajax({
					url : "settings/user/login.do" ,
					data :{"loginAct":loginAct,"loginPwd":loginPwd},
					dataType :"json",
					type : "post",
					success : function (data) {
						if (data.success){

							window.location.href = "web/system/toWorkBench.do";
						}
						else {
							$("#msg").html("");
							$("#msg").html(data.msg)
						}
					}
				})
			}

		}
		$(function (){
			if(window.top!=window){
				window.top.location=window.location;
			}
			/*加载完成后清空内容*/
			$("#loginAct").val("");
			$("#msg").html("")
			/*加载完成后聚焦*/
			$("#loginAct").focus();
			$("#loginSubmitBtn").click(function () {

				login();

			})

			$(window).keydown(function (event){
				if (event.keyCode===13){
					login();
				}
			})

		})

	</script>

</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="static/image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;五邑大学</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<span id="msg" style="color: red"></span>
					</div>
					<button type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;" id="loginSubmitBtn">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>