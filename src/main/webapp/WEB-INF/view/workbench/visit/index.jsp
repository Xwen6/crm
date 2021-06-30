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

		$(function(){
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			/*检查是否有保存或修改成功失败信息*/
			checkFlag();
			/*分页插件和查询数据结合*/
			pageList(1,2);
			/*全选复选框按钮设置*/
			$("#qx").on("click",function () {
				$("input[name=xz]").prop("checked",this.checked);
			})
			$("#getVisitListTBody").on("click",function () {
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
					window.location.href="web/system/toVisitEditTask.do?id="+$box.val();
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
							url:"workbench/visit/deleteVisit.do",
							data:parma,
							dataType:"json",
							type:"post",
							success:function (resp) {
								if (resp)
								{
									pageList(1,$("#visitPage").bs_pagination('getOption', 'rowsPerPage'));
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

			//以下日历插件在FF中存在兼容问题，在IE浏览器中可以正常使用。
			/*
			$("#startTime").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			$("#endTime").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});
			*/

			//定制字段
			$("#definedColumns > li").click(function(e) {
				//防止下拉菜单消失
				e.stopPropagation();
			});
			/*查询按钮绑定事件*/
			$("#queryBtn").on("click",function () {
				/*点击查找的时候，将填入到text中的val保存到隐藏域当中*/
				$("#hide-owner").val($.trim($("#search-owner").val()));
				$("#hide-subject").val($.trim($("#search-subject").val()));
				$("#hide-endDate").val($.trim($("#search-endDate").val()));
				$("#hide-fullname").val($.trim($("#search-fullname").val()));
				$("#hide-stage").val($.trim($("#search-stage").val()));
				$("#hide-priority").val($.trim($("#search-priority").val()));
				pageList(1,2);
			})


		});
		function pageList(pageNo,pageSize){
			$("#getVisitListTBody").empty();
			/*清空全面复选框*/
			$("#qx").prop("checked",false);
			/*执行查找方法的时候,将隐藏保存的值赋予到text当中*/
			$("#search-owner").val($.trim($("#hide-owner").val()));
			$("#search-subject").val($.trim($("#hide-subject").val()));
			$("#search-endDate").val($.trim($("#hide-endDate").val()));
			$("#search-fullname").val($.trim($("#hide-fullname").val()));
			$("#search-stage").val($.trim($("#hide-stage").val()));
			$("#search-priority").val($.trim($("#hide-priority").val()));
			$.ajax({
				url : "workbench/visit/PageList.do",
				data: {
					"pageNo":pageNo,
					"pageSize":pageSize,
					"owner":$.trim($("#search-owner").val()),
					"subject":$.trim($("#search-subject").val()),
					"endDate":$.trim($("#search-endDate").val()),
					"fullname":$.trim($("#search-fullname").val()),
					"stage":$.trim($("#search-stage").val()),
					"priority":$.trim($("#search-priority").val())
				},
				dataType:"json",
				type:"get",
				success:function (data){
					$.each(data.list,function (i,n) {
						$("#getVisitListTBody").append(
								'<tr>'+
									'<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'+
									'<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'web/system/toVisitDetail.do?id='+n.id+'\';">'+n.subject+'</a></td>'+
									'<td>'+n.endDate+'</td>'+
									'<td>'+n.contactsId+'</td>'+
									'<td>'+n.stage+'</td>'+
									'<td>'+n.priority+'</td>'+
									'<td>'+n.owner+'</td>'+
								'</tr>'
						);
					})
					var totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
					/*数据加载完毕之后，加载分页插件*/
					//数据处理完毕后，结合分页查询，对前端展现分页信息

					$("#visitPage").bs_pagination({
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
	<input type="hidden" id="hide-owner">
	<input type="hidden" id="hide-subject">
	<input type="hidden" id="hide-endDate">
	<input type="hidden" id="hide-contactsId">
	<input type="hidden" id="hide-stage">
	<input type="hidden" id="hide-priority">
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>任务列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form id="queryForm" class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
					  <select class="form-control" name="owner" id="search-owner">
						  <option></option>
						  <c:forEach items="${list}" var="u">
							  <option value="${u.id}"}>${u.name}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">主题</div>
				      <input class="form-control" type="text" name="subject" id="search-subject">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">到期日期</div>
				      <input class="form-control time" type="text" name="endDate" id="search-endDate">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人</div>
				      <input class="form-control" type="text" name="contactsId" id="search-contactsId">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">状态</div>
					  <select class="form-control" name="stage" id="search-stage">
						  <option></option>
						  <c:forEach items="${applicationScope.returnState}" var="r">
							  <option value="${r.value}">${r.text}</option>
						  </c:forEach>
					  	<%--<option></option>
					    <option>未启动</option>
					    <option>推迟</option>
					    <option>进行中</option>
					    <option>完成</option>
					    <option>等待某人</option>--%>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">优先级</div>
					  <select class="form-control" name="priority" id="search-priority">
						  <option></option>
						  <c:forEach items="${applicationScope.returnPriority}" var="r">
							  <option value="${r.value}">${r.text}</option>
						  </c:forEach>
					  	<%--<option></option>
					    <option>高</option>
					    <option>最高</option>
					    <option>低</option>
					    <option>最低</option>
					    <option>常规</option>--%>
					  </select>
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='web/system/toVisitSaveTask.do';"><span class="glyphicon glyphicon-plus"></span> 任务</button>
				  <button type="button" class="btn btn-default" onclick="alert('可以自行实现对通话的管理');"><span class="glyphicon glyphicon-plus"></span> 通话</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" name="qx" id="qx" /></td>
							<td>主题</td>
							<td>到期日期</td>
							<td>联系人</td>
							<td>状态</td>
							<td>优先级</td>
							<td>所有者</td>
						</tr>
					</thead>
					<tbody id="getVisitListTBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='web/system/toVisitDetail.do';">拜访客户</a></td>
							<td>2017-07-09</td>
							<td>李四先生</td>
							<td>未启动</td>
							<td>高</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">拜访客户</a></td>
							<td>2017-07-09</td>
							<td>李四先生</td>
							<td>未启动</td>
							<td>高</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="visitPage">
				</div>

			</div>
			
		</div>
		
	</div>
</body>
</html>