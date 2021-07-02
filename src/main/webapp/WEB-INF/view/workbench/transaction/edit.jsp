<%@ page import="java.util.Set" %>
<%@ page import="java.util.Map" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
	Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");
	Set<String> keySet = pMap.keySet();

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
	<script type="text/javascript" src="static/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript" >

	$(function () {
		/*拼接Json*/
		var jsonObj = {
			<%
                 for (String key : keySet) {
                    String value = pMap.get(key);
                %>

			"<%=key%>":<%=value%>,


			<%
            }
            %>
		}

		$("#edit-stage").change(function () {
			var stage = $("#edit-stage").val();
			var possibility = jsonObj[stage];
			$("#edit-possibility").val(possibility);
		})

		/*日历插件1*/
		$(".time1").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$(".time2").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		$("#searchActivity").keydown(function (event) {
			if (event.keyCode==13){
				$.ajax({
					url : "workbench/clue/getActivityList.do",
					data : {"name":$("#searchActivity").val()},
					dataType : "json",
					success :function (data){
						var html = ""
						$.each(data,function (index,element) {
							html += '<tr>'
							html += '<td><input type="radio" name="qx" value="'+element.id+'"/></td>'
							html += '<td id="'+element.id+'">'+element.name+'</td>'
							html += '<td>'+element.startDate+'</td>'
							html += '<td>'+element.endDate+'</td>'
							html += '<td>'+element.owner+'</td>'
							html += '</tr>'
						})
						$("#activityList").html(html);
					}
				})
				return false;
			}
		})
		$("#submitActivityBtn").click(function () {
			if ($("input[name=qx]:checked").length==1){
				var id = $("input[name=qx]:checked").val()
				var  name = $("#"+id).html()

				/**/
				$("#edit-activityId").val(id);
				$("#edit-activity").val(name);
				$("#findMarketActivity").modal("hide")

			}
			else {
				alert("请选择")
			}
		})

		$("#searchContacts").keydown(function (event) {
			if (event.keyCode==13){
				$.ajax({
					url : "workbench/transaction/getContactsList.do",
					data : {"fullname":$("#searchContacts").val()},
					dataType : "json",
					success :function (data){
						var html = ""
						$.each(data,function (index,element) {
							html += '<tr>'
							html += '<td><input type="radio" name="qx" value="'+element.id+'"/></td>'
							html += '<td id="'+element.id+'">'+element.fullname+'</td>'
							html += '<td>'+element.email+'</td>'
							html += '<td>'+element.mphone+'</td>'
							html += '</tr>'
						})
						$("#contactsList").html(html);
					}
				})

				return false;
			}
		})
		$("#submitContactsBtn").click(function () {
			if ($("input[name=qx]:checked").length==1){
				var id = $("input[name=qx]:checked").val()
				var  name = $("#"+id).html()

				/**/
				$("#edit-contactsId").val(id);
				$("#edit-contactsName").val(name);
				$("#findContacts").modal("hide")

			}
			else {
				alert("请选择")
			}
		})

		/*自动补全插件*/
		$("#edit-customerName").typeahead({
			source: function (query, process) {
				$.get(
						"workbench/transaction/getCustomerName.do",
						{ "name" : query },
						function (data) {
							//alert(data);

							/*

                                data
                                    [{客户名称1},{2},{3}]

                             */

							process(data);
						},
						"json"
				);
			},
			delay: 500
		});

		/*保存*/
		$("#updateBtn").click(function () {
			$("#updateTranForm").submit();
		})


	})
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchActivity" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable4" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityList">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
					</div>
				</div>
			</div>
		</div>
	</div>

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
						    <input type="text" id="searchContacts" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
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
						<tbody id="contactsList">
						<%--	<tr>
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
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" id="updateBtn" class="btn btn-primary">更新</button>
			<button type="button" id="cancelBtn" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" id="updateTranForm" role="form" style="position: relative; top: -30px;" action="workbench/transaction/updateTran.do" method="post">
		<div class="form-group">
			<input type="hidden" name="id" value="${requestScope.tran.id}">
			<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-owner" name="owner">
				<%--  <option selected>zhangsan</option>
				  <option>lisi</option>
				  <option>wangwu</option>--%>
					<c:forEach items="${requestScope.userList}" var="u">
						<option value="${u.id}" ${user.id eq u.id ? "selected":""}>${u.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-money" value="${requestScope.tran.money}" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" value="${requestScope.tran.name}" name="name">
			</div>
			<label for="edit-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="edit-expectedDate" value="${requestScope.tran.expectedDate}" name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-customerName" name="customerName"  placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-stage" name="stage">
			  	<option></option>
				  <c:forEach items="${applicationScope.stage}" var="s">
					  <option value="${s.value}"  ${requestScope.tran.stage eq s.value ? "selected":""}>${s.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type" name="type">
				  <option></option>
					<c:forEach items="${applicationScope.transactionType}" var="s">
						<option value="${s.value}"  ${requestScope.tran.type eq s.value ? "selected":""}>${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" value="90">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source" name="source">
				  <option></option>
					<c:forEach items="${applicationScope.source}" var="s">
						<option value="${s.value}" ${requestScope.tran.source eq s.value ? "selected":""}>${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-activity" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-activity" >
				<input type="hidden" id="edit-activityId" name="activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-contactsName" >
				<input type="hidden" id="edit-contactsId" name="contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description" name="description">${requestScope.tran.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary" name="contactSummary">${requestScope.tran.contactSummary}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time2"  id="edit-nextContactTime" value="${requestScope.tran.nextContactTime}" name="nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>