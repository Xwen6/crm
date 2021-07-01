<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="wyu.xwen.settings.domain.DicValue" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
	<script type="text/javascript" src="static/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		/*动画效果*/
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		/*日历插件*/
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});
		/*------------------------------------------------------*/

		getUserList();
		$("#editBtn").click(function () {

				/*并且清空模态窗口*/
				/*$("editActivityModal")[0].reset();*/
				/*获取记录的id*/
				var id = "${requestScope.customer.id}"
				$.ajax({
					url : "workbench/customer/getCustomerById.do",
					data : {"id":id},
					dataType : "json",
					type : "get",
					success : function (data) {
						/*填充模态窗口*/
						$("#edit-name").val(data.name);
						$("#edit-owner").val(data.owner);
						$("#edit-phone").val(data.phone);
						$("#edit-website").val(data.website);
						$("#edit-description").val(data.description);
						$("#edit-contactSummary").val(data.contactSummary);
						$("#edit-nextContactTime").val(data.nextContactTime);
						$("#edit-address").val(data.address)
					}
				})
				$("#editCustomerModal").modal("show")
		})

		/*执行修改*/
		$("#updateBtn").click(function (){
			/*获取用户的修改后的值*/
			var id = "${requestScope.customer.id}";
			var name = $.trim($("#edit-name").val());
			var owner = $.trim($("#edit-owner").val());
			var phone = $.trim($("#edit-phone").val());
			var website = $.trim($("#edit-website").val());
			var description = $.trim($("#edit-description").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $.trim($("#edit-nextContactTime").val());
			var address = $.trim($("#edit-address").val());
			var editBy = "${sessionScope.user.name}";

			$.ajax({
				url : "workbench/customer/updateCustomer.do",
				data : {
					"id":id,
					"name":name,
					"owner":owner,
					"phone":phone,
					"website":website,
					"description":description,
					"contactSummary":contactSummary,
					"nextContactTime":nextContactTime,
					"address":address,
					"editBy":editBy},
				dataType : "json",
				type : "post",
				success : function (data) {
					if (data.success){
						/*清除所有者复选框*/
						$("#edit-owner").empty();
						/*成功后刷新页面*/
						/*pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
*/						alert("修改成功")
						window.location.href='workbench/customer/detail.do?id='+"${requestScope.customer.id}"

					}
					else {
						alert("更新失败")
					}
				}
			})
		})

		/*删除操作*/
		$("#deleteCustomerBtn").click(function (){
			/*绑定所有选中的复选框*/

			if (confirm("确定要删除吗？")){
				/*		alert(param);*/
				$.ajax({
					url : "workbench/customer/deleteCustomer.do",
					data :{"id":"${requestScope.customer.id}"},
					type :  "get",
					dataType : "json",
					success : function (data){
						if(data.success){
							/*刷新删除后的的跳转到index页面*/
							window.location.href='web/system/toCustomer.do'

						}else{
							alert("删除失败")
						}
					}
				})
			}
		})
		/***************************************/
		showRemarkList();

		/*更新备注*/
		$("#updateRemarkBtn").click(function () {
			var id = $("#remarkId").val();
			var noteContent = $.trim($("#noteContent").val());
			var editBy = "${sessionScope.user.name}";
			$.ajax({
				url : "workbench/customer/remarkUpdate.do",
				data : {"id":id,"noteContent":noteContent,"editBy":editBy},
				dataType : "json",
				type : "post",
				success : function (data){
					if (data.success){
						showRemarkList();
						$("#editRemarkModal").modal("hide")
					}
					else {
						alert("更新失败");
					}
				}
			})
		})

		/*新增备注*/

		$("#saveRemarkBtn").click(function () {

			if ($.trim($("#remark").val())==null){
				alert("请输入备注内容")
			}

			var noteContent = $.trim($("#remark").val());
			$.ajax({
				url : "workbench/customer/saveRemark.do",
				data : {"noteContent":noteContent,"customerId":"${requestScope.customer.id}"},
				dataType : "json",
				type : "post",
				success : function (data) {
					if (data.success){
						alert("添加成功")
						showRemarkList()
						$("#remark").val("")
					}
					else {
						alert("添加失败")
					}
				}
			})

		})

		/*===============================================*/
		showTranList();

		/*删除交易*/
		$("#tranDeleteBtn").click(function () {
			$.ajax({
				url : "workbench/customer/deleteTran.do",
				data : {"id" : $("#tranId").val()},
				dataType : "json",
				Type : "post",
				success : function (data){
					if(data.success){
						showTranList();
						$("#removeTransactionModal").modal("hide")
					}
					else {alert("删除失败")}
				}
			})

		})
		/*========================*/
		showContactsList();
		/*删除联系人*/
		$("#deleteContactsBtn").click(function () {
			$.ajax({
				url : "workbench/customer/deleteContacts.do",
				data : {"id" : $("#contactsId").val()},
				dataType : "json",
				Type : "post",
				success : function (data){
					if(data.success){
						showContactsList();
						$("#removeContactsModal").modal("hide")
					}
					else {alert("删除失败")}
				}
			})

		})
		/*==============+++++++++==================*/
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
					"contactSummary" :  $.trim($("#create-contactSummary").val()),
					"description" : $.trim($("#create-description").val()),
					"nextContactTime" : $.trim($("#create-nextContactTime").val()),
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
						$("#contactsAddForm")[0].reset();
						showContactsList();
						$("#createContactsModal").modal("hide");
					}else {
						alert("添加失败");
					}
				}
			})
		})


	});


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

    function showRemarkList() {
        $.ajax({
            url : "workbench/customer/getRemarkListByCid.do",
            data : {"customerId" : "${requestScope.customer.id}"},
            dataType : "json",
            type : "get",
            success : function (data) {

                var html = "";

                $.each(data,function (index,element) {

                    html += '<div id="'+element.id+'" class="remarkDiv" style="height: 60px;">';
                    html += '<img title="zhangsan" src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;" >';
                    html += '<h5 id="e'+element.id+'">'+element.noteContent+'</h5>';
                    html += '<font color="gray">客户</font> <font color="gray">-</font> <b>${requestScope.customer.name}</b> <small style="color: gray;" id="s'+element.id+'"> '+(element.editFlag==0?element.createTime:element.editTime)+' 由'+(element.editFlag==0?element.createBy:element.editBy)+'</small>';
                    html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+element.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                    html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+element.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';

                })
                $("#remarks").html(html);
            }
        })
    }

	function editRemark(id){
		/*隐藏域保存id*/
		$("#remarkId").val(id);
		/*填充模态窗口*/
		$("#noteContent").val($("#e"+id).text())
		$("#editRemarkModal").modal("show")
	}
		/*删除备注*/
	function deleteRemark(id){
		if (confirm("确定要删除吗？")){
			$.ajax({
				url: "workbench/customer/deleteRemark.do",
				data: {"id":id},
				dataType: "json",
				type: "post",
				success : function (data){
					if (data.success){
						/*刷新列表*/
						$("#"+id).remove();
					}
					else {
						alert("删除失败")
					}
				}
			})
		}
	}


	function showTranList(){

		$.ajax({
			url : "workbench/customer/showTranList.do",
			data : {"customerId":"${requestScope.customer.id}"},
			dataType : "json",
			Type : "post",
			success : function (data) {
				var html = "";

				$.each(data,function (index,element) {
					html += '<tr id="'+element.id+'">'
					html +=		'<td><a href="transaction/detail.html" style="text-decoration: none;">'+element.name+'</a></td>'
					html +=		'<td>'+element.money+'</td>'
					html +=		'<td>'+element.stage+'</td>'
					html +=		'<td>90</td>'
					html +=		'<td>'+element.expectedDate+'</td>'
					html +=		'<td>'+element.type+'</td>'
					html +=		'<td><a href="javascript:void(0);" onclick=deleteTran(\''+element.id+'\') style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>'
					html += '</tr>'
				})

				$("#tranList").html(html);

			}
		})

	}

	function showContactsList(){

		$.ajax({
			url : "workbench/customer/showContactsList.do",
			data : {"customerId":"${requestScope.customer.id}"},
			dataType : "json",
			Type : "post",
			success : function (data) {
				var html = "";

				$.each(data,function (index,element) {
				html +=	'<tr id="'+element.id+'">'
				html +=		'<td><a href="contacts/detail.jsp" style="text-decoration: none;">'+element.fullname+'</a></td>'
				html +=		'<td>'+element.email+'</td>'
				html +=		'<td>'+element.mphone+'</td>'
				html +=		'<td><a href="javascript:void(0);" onclick=deleteContacts(\''+element.id+'\') style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>'
				html +=	'</tr>'
				})

				$("#contactsList").html(html);

			}
		})

	}

	function deleteTran(id){
		$("#tranId").val(id);
		$("#removeTransactionModal").modal("show");
	}

	function deleteContacts(id){
		$("#contactsId").val(id);
		$("#removeContactsModal").modal("show");
	}


</script>

</head>
<body>

	<!-- 删除联系人的模态窗口 -->
	<div class="modal fade" id="removeContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除联系人</h4>
				</div>
				<div class="modal-body">
					<input type="hidden" id="contactsId">
					<p>您确定要删除该联系人吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" id="deleteContactsBtn" class="btn btn-danger" data-dismiss="modal">删除</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 删除交易的模态窗口 -->
    <div class="modal fade" id="removeTransactionModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 30%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title">删除交易</h4>
                </div>
                <div class="modal-body">
					<input type="hidden" id="tranId">
                    <p>您确定要删除该交易吗？</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button id="tranDeleteBtn" type="button" class="btn btn-danger">删除</button>
                </div>
            </div>
        </div>
    </div>
	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
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
							<%--	  <option>广告</option>
								  <option>推销电话</option>
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
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								 <%-- <option>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
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
								<input type="text" class="form-control" id="create-birth">
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
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"><%--这个线索即将被转换--%></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime" value="2017-05-01">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"><%--北京大兴区大族企业湾--%></textarea>
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
	
	<!-- 修改客户的模态窗口 -->
    <div class="modal fade" id="editCustomerModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改客户</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">
                                  <%--  <option>zhangsan</option>
                                    <option>lisi</option>
                                    <option>wangwu</option>--%>
                                </select>
                            </div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" value="动力节点">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
                            <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-description" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-description"></textarea>
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
                                    <input type="text" class="form-control time" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" id="updateBtn" class="btn btn-primary">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.customer.name} <small><a href="'${requestScope.customer.website}'" target="_blank">${requestScope.customer.website}</a></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" id="editBtn" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" id="deleteCustomerBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${requestScope.customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.customer.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${requestScope.customer.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabe2">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 10px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<div id="remarks"></div>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tranList">
						<tr>
							<td><a href="transaction/detail.html" style="text-decoration: none;">动力节点-交易01</a></td>
							<td>5,000</td>
							<td>谈判/复审</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>新业务</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeTransactionModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="transaction/save.html" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactsList">
						<%--<tr>
							<td><a href="contacts/detail.jsp" style="text-decoration: none;">李四</a></td>
							<td>lisi@bjpowernode.com</td>
							<td>13543645364</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#createContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>