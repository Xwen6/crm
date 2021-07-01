<%@ page import="java.util.List" %>
<%@ page import="wyu.xwen.settings.domain.DicValue" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
	<script type="text/javascript" src="static/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<link rel="stylesheet" type="text/css" href="static/jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript">

	$(function(){

		/*日历插件*/
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		/*日历插件*/
		$(".time1").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		/*自动补全插件*/
		$("#create-customerName").typeahead({
			source: function (query, process) {
				$.get(
						"workbench/customer/getCustomerName.do",
						{ "name" : query },
						function (data) {

							process(data);
						},
						"json"
				);
			},
			delay: 500
		});
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

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

		pageList(1,2);
		getUserList();
		$("#searchBtn").click(function () {
			/*alert($("#search-source option:selected").text())*/
			/*点击查找的时候，将填入到text中的val保存到隐藏域当中*/
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-customerName").val($.trim($("#search-customerName").val()));
			$("#hidden-source").val($.trim($("#search-source option:selected").text()));
			$("#hidden-birth").val($.trim($("#search-birth").val()));



			pageList(1,2);
		})

		/*自动补全插件*/
		$("#create-customerName").typeahead({
			source: function (query, process) {
				$.get(
						"workbench/customer/getCustomerName.do",
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

		/*新增联系人*/
		/*新增客户*/
		$("#saveContactsBtn").click(function () {
			$.ajax({
				url :"workbench/customer/contactsSave.do",
				data : {
					"owner" : $.trim($("#create-owner").val()),
					"fullname" :  $.trim($("#create-fullname").val()),
					"appellation" :  $.trim($("#create-appellation").val()),
					"mphone" :  $.trim($("#create-mphone").val()),
					"source" : $.trim($("#create-source").val()),
					"customerId" : $.trim($("#create-customerName").val()),
					"job" : $.trim($("#create-job").val()),
					"birth" : $.trim($("#create-birth").val()),
					"email" : $.trim($("#create-email").val()),
					"contactSummary" :  $.trim($("#create-contactSummary1").val()),
					"description" : $.trim($("#create-description").val()),
					"nextContactTime" : $.trim($("#create-nextContactTime1").val()),
					"address" : $.trim($("#create-address1").val()),
					"createBy" : "${sessionScope.user.name}"

				},
				type :"post",
				dataType :"json",
				success : function (data){
					/*{"success":true}*/
					/*alert(data.success)*/
					if (data.success){
						/*重置表单*/
						$("#create-owner").empty();
						$("#contactsAddForm")[0].reset();
						pageList(1,2)
						$('#createContactsModal').modal('hide')
					}else {
						alert("添加失败");
					}
				}
			})
		})

		/*自动补全插件*/
		$("#edit-customerName").typeahead({
			source: function (query, process) {
				$.get(
						"workbench/customer/getCustomerName.do",
						{ "name" : query },
						function (data) {

							process(data);
						},
						"json"
				);
			},
			delay: 500
		});

		/*修改模态窗口的填充*/
		$("#editContactsBtn").click(function () {

			var $selectCheckBox = $("input[name=selectCheckBox]:checked");
			if ($selectCheckBox.length==0){
				alert("请选择要修改的记录")
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
					url : "workbench/contacts/getContactsById.do",
					data : {"id":id},
					dataType : "json",
					type : "get",
					success : function (data) {
						getUserList();


						/*/!*填充模态窗口*!*/
						$("#edit-fullname").val(data.fullname);
						$("#edit-owner").val(data.owner);
						$("#edit-email").val(data.email);
						$("#edit-customerName").val(data.customerName);
						$("#edit-mphone").val(data.mphone);
						$("#edit-job").val(data.job);
						$("#edit-birth").val(data.birth);
						/*$("#edit-source").val(data.source);*/
						$("#edit-description").val(data.description);
						$("#edit-appellation").val(data.appellation);
						$("#edit-nextContactTime").val(data.nextContactTime);
						$("#edit-contactSummary").val(data.contactSummary);
						$("#edit-address2").val(data.address);

						$("#editContactsModal").modal("show")

					}
				})

			}
		})

		/*更新按钮的事件*/
		/*更新操作*/
		$("#updateBtn").click(function (){

			$.ajax({
				url : "workbench/contacts/updateContacts.do",
				data : {
					"id" : $.trim($("input[name=selectCheckBox]:checked").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"fullname" :  $.trim($("#edit-fullname").val()),
					"appellation" :  $.trim($("#edit-appellation").val()),
					"mphone" :  $.trim($("#edit-mphone").val()),
					"source" : $.trim($("#edit-source1").find("option:selected").text()),
					"customerName" : $.trim($("#edit-customerName").val()),
					"job" : $.trim($("#edit-job").val()),
					"birth" : $.trim($("#edit-birth").val()),
					"email" : $.trim($("#edit-email").val()),
					"contactSummary" :  $.trim($("#edit-contactSummary").val()),
					"description" : $.trim($("#edit-description").val()),
					"nextContactTime" : $.trim($("#edit-nextContactTime").val()),
					"address" : $.trim($("#edit-address2").val()),
					"editBy" : "${sessionScope.user.name}"
				},
				dataType : "json",
				type : "post",
				success : function (data) {
					if (data.success){
						/*清除所有者复选框*/

						/*成功后刷新页面*/
						/*pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
*/
						$("#create-owner").empty();

						pageList(1,2)
						$('#editContactsModal').modal('hide')
						alert("修改成功")

					}
					else {
						alert("更新失败")
					}
				}
			})

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
						url : "workbench/contacts/deleteContacts.do",
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
		
	});

	function pageList(pageNo,pageSize){
		/*清空全面复选框*/
		$("#selectAllCheckBox").prop("checked",false);
		/*执行查找方法的时候,将隐藏保存的值赋予到text当中*/
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-customerName").val($.trim($("#hidden-customerName").val()));

		$("#search-birth").val($.trim($("#hidden-birth").val()));

		/*alert($("#search-name").val())*/
		$.ajax({
			url : "workbench/contacts/PageList.do",
			data: {
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"customerName":$.trim($("#search-customerName").val()),
				"source":$.trim($("#hidden-source").val()),
				"birth":$.trim($("#search-birth").val())
			},
			dataType:"json",
			type:"get",
			success:function (data){
				var html = ""
				$.each(data.pageList,function (index,element) {

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="selectCheckBox" value="'+element.id+'"/></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detail.do?id='+element.id+'\';">'+element.fullname+'</a></td>'
					html += '<td>'+element.owner+'</td>';
					html += '<td>'+element.customerName+'</td>';
					html += '<td>'+element.source+'</td>';
					html += '<td>'+element.birth+'</td>';
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

	function getUserList() {
		$.ajax({
			url :"workbench/activity/getUserList.do",
			type :"get",
			dataType :"json",
			success : function (data){
				$.each(data,function (index,element) {
					/*填充新建用户的模态窗口*/
					$("#create-owner").append("<option value='"+element.id+"'>"+element.name+"</option>")
					/*填充修改用户的模态窗口*/
					$("#edit-owner").append("<option value='"+element.id+"'>"+element.name+"</option>")
				})
				/*下拉列表默认显示登录的用户*/
				$("#create-owner").val("${sessionScope.user.id}")
				/*下拉列表默认显示原本所有者*/
				$("#edit-owner").val("${sessionScope.user.id}")
			}
		})
	}
	
</script>
</head>
<body>

	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-fullname">
	<input type="hidden" id="hidden-customerName">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-birth">

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="contactsAddForm" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${applicationScope.source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${applicationScope.appellation}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time1" id="create-nextContactTime1">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveContactsBtn" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								<%--  <option selected>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-source1" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source1">
								  <option></option>
								  <%--<option selected>广告</option>--%>
								<%--  <option>推销电话</option>
								  <option>员工介绍</option>
								  <option>外部介绍</option>
								  <option>在线商场</option>
								  <option>合作伙伴</option>
								  <option>公开媒介</option>
								  <option>销售邮件</option>
								  <option>合作伙伴研讨会</option>
								  <option>内部研讨会</option>
								  <option>交易会</option>
								  <option>web下载</option>
								  <option>web调研</option>
								  <option>聊天</option>--%>
									<c:forEach items="${applicationScope.source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${applicationScope.appellation}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time1" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address2">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="updateBtn"  class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
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
				      <input id="search-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input id="search-fullname" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="search-customerName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${applicationScope.source}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input id="search-birth" class="form-control time" type="text">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createContactsModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" id="editContactsBtn" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAllCheckBox" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="searchList">
					<%--	<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
                            <td>动力节点</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>2000-10-10</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 10px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>