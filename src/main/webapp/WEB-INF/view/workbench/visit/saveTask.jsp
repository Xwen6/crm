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
	<script type="text/javascript" src="static/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
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
				pickerPosition: "button-left"
			});
			$("#reminderTime").click(function(){
				if(this.checked){
					$("#reminderTimeDiv").show("200");
				}else{
					$("#reminderTimeDiv").hide("200");
				}
			});
			$("#addBtn").on("click",function () {
				$("#addVisitForm").submit();
			})
			$("#submitContacts").on("click",function () {
				$("#hiddenContactsId").val($("input[name=contacts]:checked").val());
				let $contactsId = $("#hiddenContactsId").val()
				$("#create-contacts").val($("#"+$contactsId).text());
				$("#findContacts").modal("hide");
			})
			$("#queryContactsByName").keydown(function (event) {
				if (event.keyCode == 13)
				{
					showContacts();
					return false;
				}
			})
			$("#queryContactsByName").typeahead({
				source: function (query, process) {
					$.get(
							"contacts/getContactsListByName.do",
							{ "name" : query },
							function (data) {
								//alert(data);
								process(data);
							},
							"json"
					);
				},
				delay: 1500
			});
			$("#cancelBtn").on("click",function () {
				window.history.go(-1);
			})

		});
		function showContacts() {
			$("#contactsTBody").empty();
			$.ajax({
				url:"contacts/getContactsList.do",
				data:{"name":$.trim($("#queryContactsByName").val())},
				dataType:"json",
				type:"get",
				success:function (resp) {
					$.each(resp,function (i,n) {
						$("#contactsTBody").append(
								/*'<tr>'+
								'<td><input type="radio" value="'+n.id+'" name="xz"/></td>'+
								'<td id="activityName">'+n.name+'</td>'+
								'<td>'+n.startDate+'</td>'+
								'<td>'+n.endDate+'</td>'+
								'<td>'+n.owner+'</td>'+
								'</tr>'*/
								'<tr>'+
								'<td><input type="radio" value="'+n.id+'" name="contacts"/></td>'+
								'<td id="'+n.id+'">'+n.fullname+'</td>'+
								'<td>'+n.email+'</td>'+
								'<td>'+n.mphone+'</td>'+
								'</tr>'
						);
					})
				}
			})
			$("#findContacts").modal("show");
		}
	</script>
</head>
<body>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="queryContactsByName" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsTBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitContacts">添加</button>
				</div>
			</div>
		</div>
	</div>
	
	<div style="position:  relative; left: 30px;">
		<h3>创建任务</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" id="addBtn" class="btn btn-primary">保存</button>
			<button type="button" id="cancelBtn" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" method="post" action="visit/addVisit.do" id="addVisitForm">
		<div class="form-group">
			<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner" name="owner">
				  <c:forEach items="${list}" var="u">
					  <option value="${u.id}" ${u.id == user.id ? "selected":""}>${u.name}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-subject" class="col-sm-2 control-label">主题<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-subject" name="subject">
			</div>
		</div>
		<div class="form-group">
			<label for="create-endDate" class="col-sm-2 control-label">到期日期</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-endDate" name="endDate">
			</div>
			<label for="create-contacts" class="col-sm-2 control-label">联系人&nbsp;&nbsp;<a href="javascript:void(0);" onclick="showContacts()" id="showContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contacts">
				<input type="hidden" name="contactsId" id="hiddenContactsId">
			</div>
		</div>
	
		<div class="form-group">
			<label for="create-stage" class="col-sm-2 control-label">状态</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-stage" name="stage">
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
			<label for="create-priority" class="col-sm-2 control-label">优先级</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-priority" name="priority">
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
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description" name="description"></textarea>
			</div>
		</div>
		
		<div style="position: relative; left: 103px;">
			<span><b>提醒时间</b></span>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="checkbox" id="reminderTime">
		</div>
		
		<div id="reminderTimeDiv" style="width: 500px; height: 180px; background-color: #EEEEEE; position: relative; left: 185px; top: 20px; display: none;">
			<div class="form-group" style="position: relative; top: 10px;">
				<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
				<div class="col-sm-10" style="width: 300px;">
					<input type="text" class="form-control time" id="create-startTime" name="startTime">
				</div>
			</div>
			
			<div class="form-group" style="position: relative; top: 15px;">
				<label for="create-repeatType" class="col-sm-2 control-label">重复类型</label>
				<div class="col-sm-10" style="width: 300px;">
					<select class="form-control" id="create-repeatType" name="repeatType">
					  <option></option>
					  <option>每天</option>
					  <option>每周</option>
					  <option>每月</option>
					  <option>每年</option>
					</select>
				</div>
			</div>
			
			<div class="form-group" style="position: relative; top: 20px;">
				<label for="create-noticeType" class="col-sm-2 control-label">通知类型</label>
				<div class="col-sm-10" style="width: 300px;">
					<select class="form-control" id="create-noticeType" name="noticeType">
					  <option></option>
					  <option>邮箱</option>
					  <option>弹窗</option>
					</select>
				</div>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>