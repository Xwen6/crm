<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="static/jquery/bs_pagination/jquery.bs_pagination.min.css">
	<link href="static/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="static/jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript">
		$(function () {
			/*删除*/
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
							url:"settings/department/deleteDepartment.do",
							data:parma,
							dataType:"json",
							type:"post",
							success:function (resp) {
								if (resp)
								{
									pageList(1,$("#deptDiv").bs_pagination('getOption', 'rowsPerPage'));
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
			/*编辑保存按钮绑定事件*/
			$("#editDeptBtn").on("click",function () {
				$.ajax({
					url:"settings/department/updateDepartment.do",
					data:{
						"id":$.trim($("#edit-id").val()),
						"newId":$.trim($("#edit-newId").val()),
						"name":$.trim($("#edit-name").val()),
						"manager":$.trim($("#edit-manager").val()),
						"phone":$.trim($("#edit-phone").val()),
						"description":$.trim($("#edit-description").val())
					},
					dataType:"json",
					type:"post",
					success:function (resp) {
						if (resp)
						{
							alert("修改成功！");
							pageList(1,$("#deptDiv").bs_pagination('getOption', 'rowsPerPage'));
							$("#editDeptModal").modal("hide");
						}
						else
						{
							alert("修改失败");
						}
					}
				})
			})
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
					$.ajax({
						url:"settings/department/getDeptById.do",
						data:{"id":$box.val()},
						dataType:"json",
						success:function (resp) {
							$("#edit-id").val(resp.id);
							$("#edit-newId").val(resp.id);
							$("#edit-name").val(resp.name);
							$("#edit-manager").val(resp.manager);
							$("#edit-phone").val(resp.phone);
							$("#edit-description").val(resp.description);
							$("#editDeptModal").modal("show");
						}
					})
				}

			})
			/*添加模态窗口关闭清空内容*/
			$("#createDeptModal").on("hide.bs.modal",function () {
				$("#addForm")[0].reset();
			})
			/*添加部门绑定事件*/
			$("#saveBtn").on("click",function () {
				let id = $.trim($("#create-id").val());
				let name = $.trim($("#create-name").val());
				let manager = $.trim($("#create-manager").val());
				let phone = $.trim($("#create-phone").val());
				let description = $.trim($("#create-description").val());
				$.ajax({
					url:"settings/department/addDepartment.do",
					data:{"id":id,"name":name,"manager":manager,"phone":phone,"description":description},
					dataType:"json",
					type:"post",
					success:function (resp) {
						if (resp)
						{
							alert("保存成功！")
							$("#createDeptModal").modal("hide")
							pageList(1,$("#deptDiv").bs_pagination('getOption', 'rowsPerPage'));
						}
						else
						{
							alert("保存失败！")
						}
					}
				})
			})
			pageList(1,2);
			/*全选复选框按钮设置*/
			$("#qx").on("click",function () {
				$("input[name=xz]").prop("checked",this.checked);
			})
			$("#getDeptTBody").on("click",function () {
				$("#qx").prop("checked",$("input[name=xz]").length === $("input[name=xz]:checked").length)
			})
		})
		/*修改密码*/
		function updatePassword() {
			let oldPwd = $.trim($("#oldPwd").val());
			let newPwd = $.trim($("#newPwd").val());
			let confirmPwd = $.trim($("#confirmPwd").val());
			if (oldPwd === '')
			{
				alert("原密码不能为空！")
			}
			else
			{
				if (newPwd === '' || confirmPwd === '')
				{
					alert("新密码或确认密码不能为空！")
				}
				else
				{
					if (newPwd !== confirmPwd)
					{
						alert("新密码与确认密码不一致!")
					}
					else
					{
						$.ajax({
							url:"web/system/updatePassword.do",
							data:{"id":"${user.id}","oldPwd":oldPwd,"newPwd":newPwd},
							dataType:"json",
							type:"post",
							success:function (resp) {
								if (resp.flag)
								{
									alert("修改成功，请重新登录。")
									window.location.href="web/system/logout.do"
								}
								else
								{
									alert(resp.message)
								}
							}
						})
					}
				}
			}
		}
		/*页面加载函数*/
		function pageList(pageNo,pageSize){
			$("#getDeptTBody").empty();
			/*清空全面复选框*/
			$("#qx").prop("checked",false);
			$.ajax({
				url : "settings/department/pageList.do",
				data: {
					"pageNo":pageNo,
					"pageSize":pageSize,
				},
				dataType:"json",
				type:"get",
				success:function (data){
					$.each(data.list,function (i,n) {
						$("#getDeptTBody").append(
								'<tr class="active">'+
									'<td><input type="checkbox" name="xz" value="'+n.id+'" /></td>'+
									'<td>'+n.id+'</td>'+
									'<td>'+n.name+'</td>'+
									'<td>'+n.manager+'</td>'+
									'<td>'+n.phone+'</td>'+
									'<td>'+n.description+'</td>'+
								'</tr>'
						);
					})
					var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
					/*数据加载完毕之后，加载分页插件*/
					//数据处理完毕后，结合分页查询，对前端展现分页信息

					$("#deptDiv").bs_pagination({
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
	</script>
</head>
<body>

	<!-- 我的资料 -->
	<div class="modal fade" id="myInformation" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">我的资料</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative; left: 40px;">
						姓名：<b>${user.name}</b><br><br>
						登录帐号：<b>${user.loginAct}</b><br><br>
						组织机构：<b>${user.deptno}，市场部，二级部门</b><br><br>
						邮箱：<b>${user.email}</b><br><br>
						失效时间：<b>${user.expireTime}</b><br><br>
						允许访问IP：<b>${user.allowIps}</b>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改密码的模态窗口 -->
	<div class="modal fade" id="editPwdModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 70%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="oldPwd" style="width: 200%;">
							</div>
						</div>

						<div class="form-group">
							<label for="newPwd" class="col-sm-2 control-label">新密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="newPwd" style="width: 200%;">
							</div>
						</div>

						<div class="form-group">
							<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="confirmPwd" style="width: 200%;">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" onclick="updatePassword();">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 退出系统的模态窗口 -->
	<div class="modal fade" id="exitModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">离开</h4>
				</div>
				<div class="modal-body">
					<p>您确定要退出系统吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='web/system/logout.do';">确定</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 顶部 -->
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;五邑大学</span></div>
		<div style="position: absolute; top: 15px; right: 15px;">
			<ul>
				<li class="dropdown user-dropdown">
					<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
						<span class="glyphicon glyphicon-user"></span> ${sessionScope.user.name} <span class="caret"></span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</a>
					<ul class="dropdown-menu">
						<li><a href="web/system/toSettings.do"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
						<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<!-- 创建部门的模态窗口 -->
	<div class="modal fade" id="createDeptModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title"><span class="glyphicon glyphicon-plus"></span> 新增部门</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="addForm" role="form">
					
						<div class="form-group">
							<label for="create-id" class="col-sm-2 control-label">编号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-id" style="width: 200%;" placeholder="编号不能为空，具有唯一性">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-name" class="col-sm-2 control-label">名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-manager" class="col-sm-2 control-label">负责人</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-manager" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 55%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveBtn" >保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改部门的模态窗口 -->
	<div class="modal fade" id="editDeptModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title"><span class="glyphicon glyphicon-edit"></span> 编辑部门</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-newId" class="col-sm-2 control-label">编号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-newId" style="width: 200%;">
								<input type="hidden" id="edit-id">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-name" class="col-sm-2 control-label">名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-manager" class="col-sm-2 control-label">负责人</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-manager" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 55%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="editDeptBtn" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<div style="width: 95%">
		<div>
			<div style="position: relative; left: 30px; top: -10px;">
				<div class="page-header">
					<h3>部门列表</h3>
				</div>
			</div>
		</div>
		<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; top:-30px;">
			<div class="btn-group" style="position: relative; top: 18%;">
			  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createDeptModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
			  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
			</div>
		</div>
		<div style="position: relative; left: 30px; top: -10px;">
			<table class="table table-hover">
				<thead>
					<tr style="color: #B3B3B3;">
						<td><input type="checkbox" name="qx" id="qx" /></td>
						<td>编号</td>
						<td>名称</td>
						<td>负责人</td>
						<td>电话</td>
						<td>描述</td>
					</tr>
				</thead>
				<tbody id="getDeptTBody">
					<tr class="active">
						<td><input type="checkbox" /></td>
						<td>1110</td>
						<td>财务部</td>
						<td>张飞</td>
						<td>010-84846005</td>
						<td>description info</td>
					</tr>
					<tr>
						<td><input type="checkbox" /></td>
						<td>1120</td>
						<td>销售部</td>
						<td>关羽</td>
						<td>010-84846006</td>
						<td>description info</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div style="height: 50px; position: relative;top: 0px; left:30px;">
			<div id="deptDiv">
			</div>
		</div>
			
	</div>
	
</body>
</html>