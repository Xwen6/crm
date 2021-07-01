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
	<script type="text/javascript">
		$(function () {
			$("#addBtn").on("click",function () {
				$("#addForm").submit();
			})
		})
	</script>
</head>
<body>

<div style="position:  relative; left: 30px;">
	<h3>新增字典值</h3>
	<div style="position: relative; top: -40px; left: 70%;">
		<button type="button" id="addBtn" class="btn btn-primary">保存</button>
		<button type="button" class="btn btn-default" onclick="window.history.go(-1);">取消</button>
	</div>
	<hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" id="addForm" action="settings/web/addDicValue.do" method="post" role="form">

	<div class="form-group">
		<label for="create-dicTypeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select class="form-control" name="typeCode" id="create-dicTypeCode" style="width: 200%;">
				<option></option>
				<c:forEach items="${applicationScope.dicTypeList}" var="d">
					<option value="${d.code}">${d.code}</option>
				</c:forEach>
			</select>
		</div>
	</div>

	<div class="form-group">
		<label for="create-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" name="value" class="form-control" id="create-dicValue" style="width: 200%;">
		</div>
	</div>

	<div class="form-group">
		<label for="create-text" class="col-sm-2 control-label">文本</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" name="text" class="form-control" id="create-text" style="width: 200%;">
		</div>
	</div>

	<div class="form-group">
		<label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" name="orderNo" class="form-control" id="create-orderNo" style="width: 200%;">
		</div>
	</div>
</form>

<div style="height: 200px;"></div>
</body>
</html>