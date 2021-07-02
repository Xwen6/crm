<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="static/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="static/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="static/jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})
		$("#searchList").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		pageList(1,2);
		/*模糊查询*/
		$("#searchBtn").click(function () {

			/*点击查找的时候，将填入到text中的val保存到隐藏域当中*/
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-customerName").val($.trim($("#search-customerName").val()));
			$("#hidden-phone").val($.trim($("#search-phone").val()));
			$("#hidden-stage").val($.trim($("#search-stage option:selected").val()));
			$("#hidden-type").val($.trim($("#search-type option:selected").val()));
			$("#hidden-source").val($.trim($("#search-source option:selected").val()));
			$("#hidden-contactsName").val($.trim($("#search-contactsName").val()));

			pageList(1,2);
		})


		/*复选框选择*/
		/*一，全选中*/
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		/*选择全*/
		$("#searchList").on("click",$("input[name=xz]"),function () {
			/*选择复选框的长度等于所以复选框的长度，则选中*/
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})

		/*删除操作*/
		$("#deleteBtn").click(function (){
			/*绑定所有选中的复选框*/
			var $selectCheckBox =  $("input[name=xz]:checked");
			if ($selectCheckBox.length===0){
				alert("请选择要删除的记录")
			}else {
				if (confirm("确定要删除吗？")){
					/*访问参数拼接*/
					var param = "ids=";
					$.each($selectCheckBox,function (index,element) {
						param += $(element).val();
						/*如果不是最后一条id，则加上&*/
						if (index != ($selectCheckBox.length-1)){
							param += ","
						}
					})

					/*	alert(param);*/
					$.ajax({
						url : "workbench/transaction/deleteTran.do",
						data : param,
						type :  "get",
						dataType : "json",
						success : function (data){
							if(data.success){
								/*刷新删除后的的pageList*/
								pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
										,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

							}else{
								alert("删除失败")
							}
						}
					})
				}

			}
		})

		/*修改*/
		$("#editBtn").click(function () {
			var $selectCheckBox = $("input[name=xz]:checked");
			if ($selectCheckBox.length==0){
				alert("请选择要修改的记录")
			}else if ($selectCheckBox.length>1){
				/*清空复选框*/
				$("#qx").prop("checked",false);
				$("input[name=xz]:checked").prop("checked",false);
				alert("只能修改一条记录")

			}else{
				var id = $("input[name=xz]:checked").val()
				window.location.href="workbench/transaction/toEditTran.do?id="+id
			}
		})

	});

	function pageList(pageNo,pageSize){
		$.ajax({
			url : "workbench/transaction/pageList.do",
			data: {
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#hidden-name").val()),
				"owner":$.trim($("#hidden-owner").val()),
				"customerName":$.trim($("#hidden-customerName").val()),
				"type":$.trim($("#hidden-type").val()),
				"stage":$.trim($("#hidden-stage").val()),
				"source":$.trim($("#hidden-source").val()),
				"contactsName":$.trim($("#hidden-contactsName").val())
			},
			dataType:"json",
			type:"get",
			success:function (data){
				var html = ""
				$.each(data.pageList,function (index,element) {

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="xz" value="'+element.id+'"/></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+element.id+'\';">'+element.name+'</a></td>'
					html += '<td>'+element.customerName+'</td>';
					html += '<td>'+element.stage+'</td>';
					html += '<td>'+element.type+'</td>';
					html += '<td>'+element.owner+'</td>';
					html += '<td>'+element.source+'</td>';
					html += '<td>'+element.contactsName+'</td>';
					html += '</tr>';
				})

				$("#searchList").html(html);

				var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				/*数据加载完毕之后，加载分页插件*/
				//数据处理完毕后，结合分页查询，对前端展现分页信息

				$("#activityPage").bs_pagination({
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

	<%--保存上次查询的条件--%>
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-customerName">
	<input type="hidden" id="hidden-stage">
	<input type="hidden" id="hidden-type">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-contactsName">

	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="search-stage">
					  	<option></option>
						  <c:forEach items="${applicationScope.stage}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-type">
					  	<option></option>
					  <c:forEach items="${transactionType}" var="t">
						  <option value="${t.value}">${t.text}</option>
					  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						 <c:forEach items="${source}" var="s">
							 <option value="${s.value}">${s.text}</option>
						 </c:forEach>>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactsName">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='web/system/toTranSave.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" id="editBtn" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="searchList">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>