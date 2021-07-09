<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
	Object o = request.getAttribute("flag");
	String message = (String) request.getAttribute("message");
	boolean flag = false;
	if (o != null)
	{
		flag = (boolean) o;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	<link href="static/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="static/jquery/bs_pagination/jquery.bs_pagination.min.css">
	<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="static/jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript">
		$(function () {
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			checkFlag();
			pageList(1,2);
			$("#saveBtn").on("click",function () {
				let regExp = /^[A-Za-z0-9]+$/;      //用户名的正则表达式
				let emailReg = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/; //邮箱的正则表达式
				let loginActNo = $.trim($("#create-loginActNo").val());
				let username = $.trim($("#create-username").val());
				let loginPwd = $.trim($("#create-loginPwd").val());
				let confirmPwd = $.trim($("#create-confirmPwd").val());
				let email = $.trim($("#create-email").val());
				let expireTime = $.trim($("#create-expireTime").val());
				let lockStatus = $.trim($("#create-lockStatus").val());
				let dept = $.trim($("#create-dept").val());
				let allowIps = $.trim($("#create-allowIps").val());
				if (loginActNo === "")
				{
					alert("用户名不能为空！")
					return false;
				}
				else
				{
					if (loginActNo.length <6 || loginActNo > 14)
					{
						alert("用户名长度不合法")
						return false;
					}
					else
					{
						if (regExp.test(loginActNo))
						{
							if (loginPwd === "" || confirmPwd === "")
							{
								alert("密码不能为空！")
								return false;
							}
							else
							{
								if (loginPwd === confirmPwd)
								{
									if (emailReg.test(email))
									{
										if (dept === "")
										{
											alert("部门不能为空！")
											return false;
										}
										else
										{
											$.ajax({
												url: "settings/user/addUser.do",
												data: {
													"loginAct": loginActNo,
													"name": username,
													"loginPwd": loginPwd,
													"email": email,
													"expireTime": expireTime,
													"lockStatus": lockStatus,
													"deptName": dept,
													"allowIps": allowIps,
													"createBy": "${user.id}"
												},
												dataType: "json",
												type: "post",
												success: function (resp) {
													if (resp)
													{
														alert("保存成功！")
														$("#createUserModal").modal("hide")
														pageList(1, $("#userPage").bs_pagination('getOption', 'rowsPerPage'));
													}
													else
													{
														alert("保存失败！")
														return false;
													}
												}
											})
										}
									}
									else
									{
										alert("邮箱不合法！");
										return false;
									}
								}
								else
								{
									alert("密码和确认密码不一致！")
									return false;
								}
							}
						}
						else
						{
							alert("用户名含有特殊符号！");
							return false;
						}
					}
				}

			})
			/*添加模态窗口关闭清空内容*/
			/*$("#createUserModal").on("hide.bs.modal",function () {
				$("#saveForm")[0].reset();
			})*/

			/*全选复选框按钮设置*/
			$("#qx").on("click",function () {
				$("input[name=xz]").prop("checked",this.checked);
			})
			$("#userTBody").on("click",function () {
				$("#qx").prop("checked",$("input[name=xz]").length === $("input[name=xz]:checked").length)
			})
			/*编辑保存按钮绑定事件*/
			/*$("#editUserBtn").on("click",function () {
				$.ajax({
					url:"settings/user/updateUser.do",
					data:{
						"id":$.trim($("#edit-id").val()),
						"loginAct":$.trim($("#edit-loginActNo").val()),
						"name":$.trim($("#edit-username").val()),
						"loginPwd":$.trim($("#edit-loginPwd").val()),
						"email":$.trim($("#edit-email").val()),
						"expireTime":$.trim($("#edit-expireTime").val()),
						"lockStatus":$.trim($("#edit-lockStatus").val()),
						"deptName":$.trim($("#edit-dept").val()),
						"allowIps":$.trim($("#edit-allowIps").val()),
						"editBy":""
					},
					dataType:"json",
					type:"post",
					success:function (resp) {
						if (resp)
						{
							alert("修改成功！");
							pageList(1,$("#userPage").bs_pagination('getOption', 'rowsPerPage'));
							$("#editUserModal").modal("hide");
						}
						else
						{
							alert("修改失败");
						}
					}
				})
			})*/
			/*编辑按钮绑定事件*/
			$("#editBtn").on("click",function () {
				let $box = $("input[name=xz]:checked");
				if ($box.length === 0)
				{
					alert("请选择您要修改的选项！")
				}
				else if ($box.length > 1)
				{
					alert("您只能选择一个选项！")
				}
				else
				{
					window.location.href="web/system/toUserDetail.do?id="+$box.val();
				}
			})
			/*绑定删除事件*/
			$("#deleteBtn").on("click",function () {
				let $box = $("input[name=xz]:checked");
				if ($box.length === 0)
				{
					alert("请选择您要删除的选项！")
				}
				else
				{
					if (confirm("是否要删除选中的记录？"))
					{
						let parma = "ids=";
						$.each($box, function (i, n) {
							parma += $(n).val();
							if (i < $box.length - 1)
							{
								parma += ",";
							}
						})
						$.ajax({
							url:"settings/user/deleteUser.do",
							data:parma,
							dataType:"json",
							type:"post",
							success:function (resp) {
								if (resp)
								{
									pageList(1,$("#userPage").bs_pagination('getOption', 'rowsPerPage'));
									alert("删除成功！")
								}
								else
								{
									alert("删除失败！")
								}
							}
						})
					}
				}
			})
			//定制字段
			$("#definedColumns > li").click(function(e) {
				//防止下拉菜单消失
				e.stopPropagation();
			});
			/*查询按钮绑定事件*/
			$("#queryBtn").on("click",function () {
				/*点击查找的时候，将填入到text中的val保存到隐藏域当中*/
				$("#hide-name").val($.trim($("#search-name").val()));
				$("#hide-deptName").val($.trim($("#search-deptName").val()));
				$("#hide-lockState").val($.trim($("#search-lockState").val()));
				$("#hide-startTime").val($.trim($("#search-startTime").val()));
				$("#hide-endTime").val($.trim($("#search-endTime").val()));
				pageList(1,2);
			})
			$("#cancelBtn").on("click",function () {
				$("#saveForm")[0].reset();
			})
			$("#closeBtn").on("click",function () {
				$("#saveForm")[0].reset();
			})
		})
		/*查询用户*/
		function pageList(pageNo,pageSize){
			$("#userTBody").empty();
			/*清空全面复选框*/
			$("#qx").prop("checked",false);
			/*执行查找方法的时候,将隐藏保存的值赋予到text当中*/
			$("#search-name").val($.trim($("#hide-name").val()));
			$("#search-deptName").val($.trim($("#hide-deptName").val()));
			$("#search-lockState").val($.trim($("#hide-lockState").val()));
			$("#search-startTime").val($.trim($("#hide-startTime").val()));
			$("#search-endTime").val($.trim($("#hide-endTime").val()));
			$.ajax({
				url : "settings/user/pageList.do",
				data: {
					"pageNo":pageNo,
					"pageSize":pageSize,
					"name":$.trim($("#search-name").val()),
					"deptName":$.trim($("#search-deptName").val()),
					"lockState":$.trim($("#search-lockState").val()),
					"startTime":$.trim($("#search-startTime").val()),
					"endTime":$.trim($("#search-endTime").val())
				},
				dataType:"json",
				type:"get",
				success:function (data){
					$.each(data.list,function (i,n) {
						$("#userTBody").append(
								'<tr>'+
									'<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'+
									'<td>'+i+'</td>'+
									'<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'web/system/toUserDetail.do?id='+n.id+'\';">'+n.loginAct+'</a></td>'+
									'<td>'+n.name+'</td>'+
									'<td>'+n.deptName+'</td>'+
									'<td>'+n.email+'</td>'+
									'<td>'+n.expireTime+'</td>'+
									'<td>'+n.allowIps+'</td>'+
									'<td>'+n.lockState+'</td>'+
									'<td>'+n.createName+'</td>'+
									'<td>'+n.createTime+'</td>'+
									'<td>'+(n.editName == null ? '无':n.editName)+'</td>'+
									'<td>'+(n.editTime == null ? '----------------------------':n.editTime)+'</td>'+
								'</tr>'

						);
					})
					var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
					/*数据加载完毕之后，加载分页插件*/
					//数据处理完毕后，结合分页查询，对前端展现分页信息

					$("#userPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.total, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						//该回调函数时在，点击分页组件的时候触发的
						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					});

				}
			})
		}
		function checkFlag() {
			if (<%=flag%>)
			{
				alert("<%=message%>");
				<%
                flag = false;
                %>
			}
		}
	</script>
</head>
<body>
	<input type="hidden" id="hide-name">
	<input type="hidden" id="hide-deptName">
	<input type="hidden" id="hide-lockState">
	<input type="hidden" id="hide-startTime">
	<input type="hidden" id="hide-endTime">

	<!-- 创建用户的模态窗口 -->
	<div class="modal fade" id="createUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" id="closeBtn" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">新增用户</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="saveForm" role="form">
					
						<div class="form-group">
							<label for="create-loginActNo" class="col-sm-2 control-label">登录帐号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-loginActNo">
							</div>
							<label for="create-username" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-username">
							</div>
						</div>
						<div class="form-group">
							<label for="create-loginPwd" class="col-sm-2 control-label">登录密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-loginPwd">
							</div>
							<label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-confirmPwd">
							</div>
						</div>
						<div class="form-group">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-expireTime">
							</div>
						</div>
						<div class="form-group">
							<label for="create-lockStatus" class="col-sm-2 control-label">锁定状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-lockStatus">
								  <option></option>
								  <option>启用</option>
								  <option>锁定</option>
								</select>
							</div>
							<label for="create-dept" class="col-sm-2 control-label">部门<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="create-dept">
                                    <option></option>
                                    <option>市场部</option>
                                    <option>策划部</option>
                                </select>
                            </div>
						</div>
						<div class="form-group">
							<label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-allowIps" style="width: 280%" placeholder="多个用逗号隔开">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" id="cancelBtn" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveBtn" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>用户列表</h3>
			</div>
		</div>
	</div>
	
	<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
		<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">用户姓名</div>
		      <input class="form-control" id="search-name" type="text">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">部门名称</div>
		      <input class="form-control" id="search-deptName" type="text">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">锁定状态</div>
			  <select class="form-control" id="search-lockState">
			  	  <option></option>
				  <c:forEach items="${applicationScope.lockStatus}" var="l">
					  <option value="${l.value}">${l.text}</option>
				  </c:forEach>
			  </select>
		    </div>
		  </div>
		  <br><br>
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">失效时间</div>
			  <input class="form-control time" type="text" id="search-startTime" />
		    </div>
		  </div>
		  
		  ~
		  
		  <div class="form-group">
		    <div class="input-group">
			  <input class="form-control time" type="text" id="search-endTime" />
		    </div>
		  </div>
		  
		  <button type="button" id="queryBtn" class="btn btn-default">查询</button>
		  
		</form>
	</div>
	
	
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createUserModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
		
	</div>
	
	<div style="position: relative; left: 30px; top: 40px; width: 110%">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" name="qx" /></td>
					<td>序号</td>
					<td>登录帐号</td>
					<td>用户姓名</td>
					<td>部门名称</td>
					<td>邮箱</td>
					<td>失效时间</td>
					<td>允许访问IP</td>
					<td>锁定状态</td>
					<td>创建者</td>
					<td>创建时间</td>
					<td>修改者</td>
					<td>修改时间</td>
				</tr>
			</thead>
			<tbody id="userTBody">
				<%--<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td><a  href="detail.html">zhangsan</a></td>
					<td>张三</td>
					<td>市场部</td>
					<td>zhangsan@bjpowernode.com</td>
					<td>2017-02-14 10:10:10</td>
					<td>127.0.0.1,192.168.100.2</td>
					<td>启用</td>
					<td>admin</td>
					<td>2017-02-10 10:10:10</td>
					<td>admin</td>
					<td>2017-02-10 20:10:10</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>2</td>
					<td><a  href="detail.html">lisi</a></td>
					<td>李四</td>
					<td>市场部</td>
					<td>lisi@bjpowernode.com</td>
					<td>2017-02-14 10:10:10</td>
					<td>127.0.0.1,192.168.100.2</td>
					<td>锁定</td>
					<td>admin</td>
					<td>2017-02-10 10:10:10</td>
					<td>admin</td>
					<td>2017-02-10 20:10:10</td>
				</tr>--%>
			</tbody>
		</table>
	</div>
	
	<div style="height: 50px; position: relative;top: 30px; left: 30px;">
		<div id="userPage">
		</div>
	</div>
			
</body>
</html>