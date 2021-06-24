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
<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="static/jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="static/jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function (){
		/*页面加载完成后，要加载活动数据*/
		pageList(1,2);
		/*更新操作*/
		$("#updateBtn").click(function (){
			/*获取用户的修改后的值*/
			var id = $("input[name=selectCheckBox]:checked").val()
			var name = $.trim($("#edit-name").val());
			var owner = $.trim($("#edit-owner").val());
			var startDate = $.trim($("#edit-startDate").val());
			var endDate = $.trim($("#edit-endDate").val());
			var description = $.trim($("#edit-description").val());
			var cost = $.trim($("#edit-cost").val());
			var editBy = "${sessionScope.user.name}";


			$.ajax({
				url : "workbench/activity/Update.do",
				data : {
						"id":id,
						"name":name,
						"owner":owner,
						"startDate":startDate,
						"endDate":endDate,
						"description":description,
						"cost":cost,
						"editBy":editBy},
				dataType : "json",
				type : "post",
				success : function (data) {
					if (data.success){

						/*成功后刷新页面*/
						/*pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
*/							pageList(1,2);

					}
					else {
						alert("更新失败")
					}
				}
			})


		})
		/*填充修改模态窗口*/
		$("#editBtn").click(function () {

			var $selectCheckBox = $("input[name=selectCheckBox]:checked");
			if ($selectCheckBox.length==0){
				alert("请选择要删除的记录")
			}else if ($selectCheckBox.length>1){
				/*清空全面复选框*/
				$("#selectAllCheckBox").prop("checked",false);
				$("input[name=selectCheckBox]:checked").prop("checked",false);
				alert("只能修改一条记录")
				/*清空全面复选框*/
			}else {
				/*并且清空模态窗口*/
				/*$("editActivityModal")[0].reset();*/
				/*获取记录的id*/
				var id = $("input[name=selectCheckBox]:checked").val()
				$.ajax({
					url : "workbench/activity/UserAndActivity.do",
					data : {"id":id},
					dataType : "json",
					type : "get",
					success : function (data) {
						$("#edit-owner").empty();
						/*{"userList":userList,"Activity:Activity:Activity}*/
						$.each(data.userList,function (index,element) {
							$("#edit-owner").append("<option value='"+element.id+"'>"+element.name+"</option>")
						})
						/*下拉列表默认显示登录的用户*/
						$("#edit-owner").val(data.activity.owner);

						/*填充模态窗口*/
						$("#edit-name").val(data.activity.name);
						$("#edit-startDate").val(data.activity.startDate);
						$("#edit-endDate").val(data.activity.endDate);
						$("#edit-cost").val(data.activity.cost);
						$("#edit-description").val(data.activity.description);



					}
				})
				$("#editActivityModal").modal("show")
			}


		})
		/*删除操作*/
		$("#deleteBtn").click(function (){
			/*绑定所有选中的复选框*/
		var $selectCheckBox =  $("input[name=selectCheckBox]:checked");
			if ($selectCheckBox.length==0){
				alert("请选择要删除的记录")
			}else {
				if (confirm("确定要删除吗？")){
					/*访问参数拼接*/
					var param = "";
					$.each($selectCheckBox,function (index,element) {
						param += "id="+$(element).val();
						/*如果不是最后一条id，则加上&*/
						if (index != ($selectCheckBox.length-1)){
							param += "&"
						}
					})
					/*alert(param)*/
					$.ajax({
						url : "workbench/activity/Delete.do",
						data : param,
						type :  "post",
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
		/*复选框选择*/
		/*一，全选中*/
		$("#selectAllCheckBox").click(function () {
			$("input[name=selectCheckBox]").prop("checked",this.checked);
		})
		/*选择全*/
		$("#searchList").on("click",$("input[name=selectCheckBox]"),function () {
			/*选择复选框的长度等于所以复选框的长度，则选中*/
			$("#selectAllCheckBox").prop("checked",$("input[name=selectCheckBox]").length==$("input[name=selectCheckBox]:checked").length)
		})
		/*日历插件*/
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$.ajax({
			url :"workbench/activity/getUserList.do",
			type :"get",
			dataType :"json",
			success : function (data){
				$.each(data,function (index,element) {

					$("#create-owner").append("<option value='"+element.id+"'>"+element.name+"</option>")
				})
				/*下拉列表默认显示登录的用户*/
				$("#create-owner").val("${sessionScope.user.id}")
			}
		})
		
		$("#addBtn").click(function () {
			$("#createActivityModal").modal("show");
		})

		/*用户保存*/
		$("#saveBtn").click(function () {
			$.ajax({
				url :"workbench/activity/MarkActivitySave.do",
				data : {
					"owner" : $.trim($("#create-owner").val()),
					"name" :  $.trim($("#create-name").val()),
					"startDate" :  $.trim($("#create-startDate").val()),
					"endDate" :  $.trim($("#create-endDate").val()),
					"cost" :  $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-description").val()),

		},
				type :"post",
				dataType :"json",
				success : function (data){
					/*{"success":true}*/

					if (data.success){
						/*重置表单*/
						$("#MarkActivityAdd")[0].reset();
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#createActivityModal").modal("hide");
					}else {
						alert("添加失败");
					}
				}
			})
		})

		$("#searchBtn").click(function () {
			/*点击查找的时候，将填入到text中的val保存到隐藏域当中*/
			$("#hide-name").val($.trim($("#search-name").val()));
			$("#hide-owner").val($.trim($("#search-owner").val()));
			$("#hide-startDate").val($.trim($("#search-startDate").val()));
			$("#hide-endDate").val($.trim($("#search-endDate").val()));

			pageList(1,2);
		})
	})

	function pageList(pageNo,pageSize){
		/*清空全面复选框*/
		$("#selectAllCheckBox").prop("checked",false);
		/*执行查找方法的时候,将隐藏保存的值赋予到text当中*/
		$("#search-name").val($.trim($("#hide-name").val()));
		$("#search-owner").val($.trim($("#hide-owner").val()));
		$("#search-startDate").val($.trim($("#hide-startDate").val()));
		$("#search-endDate").val($.trim($("#hide-endDate").val()));
		$.ajax({
			url : "workbench/activity/PageList.do",
			data: {
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"startDate":$.trim($("#search-startDate").val()),
				"endDate":$.trim($("#search-endDate").val())
			},
			dataType:"json",
			type:"get",
			success:function (data){
				var html = ""
				$.each(data.pageList,function (index,element) {

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="selectCheckBox" value="'+element.id+'"/></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+element.id+'\';">'+element.name+'</a></td>'
					html += '<td>'+element.owner+'</td>';
					html += '<td>'+element.startDate+'</td>';
					html += '<td>'+element.endDate+'</td>';
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
		<%--用于保存查找框中的值--%>
	<input type="hidden" id="hide-name">
	<input type="hidden" id="hide-owner">
	<input type="hidden" id="hide-startDate">
	<input type="hidden" id="hide-endDate">
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="MarkActivityAdd" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">


								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate"  readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate"  readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="updateBtn" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control " type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control " type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" id="editBtn" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAllCheckBox" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="searchList">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">

				<div id="activityPage"></div>

			</div>
			
		</div>
		
	</div>
</body>
</html>