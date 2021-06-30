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
	<script type="text/javascript">
		$(function () {
			showDicTypeList();
			/*全选复选框按钮设置*/
			$("#qx").on("click",function () {
				$("input[name=xz]").prop("checked",this.checked);
			})
			$("#dicTypeTBody").on("click",function () {
				$("#qx").prop("checked",$("input[name=xz]").length === $("input[name=xz]:checked").length)
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
					window.location.href="web/system/toDicTypeEdit.do?code="+$box.val();
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
						let parma = "codes=";
						$.each($box, function (i, n) {
							parma += $(n).val();
							if (i < $box.length - 1)
							{
								parma += ",";
							}
						})
						$.ajax({
							url:"settings/web/deleteDicType.do",
							data:parma,
							dataType:"json",
							type:"post",
							success:function (resp) {
								if (resp)
								{
									showDicTypeList();
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
		})
		/*展示数据字典类型*/
		function showDicTypeList() {
			$("#dicTypeTBody").empty();
			$.ajax({
				url:"settings/web/getDicTypeList.do",
				dataType:"json",
				success:function (resp) {
					$.each(resp,function (i,n) {
						$("#dicTypeTBody").append(
								'<tr class="active">'+
									'<td><input type="checkbox" name="xz" value="'+n.code+'" /></td>'+
									'<td>'+i+'</td>'+
									'<td>'+n.code+'</td>'+
									'<td>'+n.name+'</td>'+
									'<td>'+n.description+'</td>'+
								'</tr>'
						)
					})
				}
			})
		}
	</script>
	</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>

	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='web/system/toDicTypeSave.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" name="qx" id="qx" /></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody id="dicTypeTBody">
				<%--<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td>sex</td>
					<td>性别</td>
					<td>性别包括男和女</td>
				</tr>--%>
			</tbody>
		</table>
	</div>
	
</body>
</html>