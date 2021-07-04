<%@ page import="java.util.List" %>
<%@ page import="wyu.xwen.settings.domain.DicValue" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
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

<script type="text/javascript">

	function getUserList() {
		$.ajax({
			url :"workbench/activity/getUserList.do",
			type :"get",
			dataType :"json",
			success : function (data){
				$.each(data,function (index,element) {

					/*填充修改用户的模态窗口*/
					$("#edit-owner").append("<option value='"+element.id+"'>"+element.name+"</option>")
				})

				/*下拉列表默认显示原本所有者*/
				$("#edit-owner").val("${sessionScope.user.id}")
			}
		})
	}



	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		/*添加联系复选框选中*/
		$("#relationCheckBox").click(function () {
			$("input[name=selectCheckBox]").prop("checked",this.checked)
		})

		$("#activityList2").on("click",$("input[name=selectCheckBox]"),function (){
			$("#relationCheckBox").prop("checked",$("input[name=selectCheckBox]:checked").length==$("input[name=selectCheckBox]").length)
		})

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
		/*动画效果*/
		$("#remarks").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarks").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		showClueAndActivity();

		$("#searchActivityBtn").keydown(function (event) {
            if (event.keyCode===13)
            {
				/*清空*/
				$("#activityList2").empty()
                editRelation();
                return false;
            }
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

		/*填充修改模态窗口*/
		$("#editBtn").click(function () {

				var id = "${requestScope.clue.id}"
				$.ajax({
					url : "workbench/clue/getClueById.do",
					data : {"id":id},
					dataType : "json",
					type : "get",
					success : function (data) {
						getUserList();

						/*/!*填充模态窗口*!*/
						$("#edit-fullname").val(data.fullname);
						$("#edit-owner").val(data.owner);
						$("#edit-email").val(data.email);
						$("#edit-address").val(data.address)
						$("#edit-website").val(data.website);
						$("#edit-phone").val(data.phone);
						$("#edit-mphone").val(data.mphone);
						$("#edit-company").val(data.company);
						$("#edit-state").val(data.state);
						$("#edit-source").val(data.source);
						$("#edit-description").val(data.description);
						$("#edit-appellation").val(data.appellation);
						$("#edit-nextContactTime").val(data.nextContactTime);
						$("#edit-contactSummary").val(data.contactSummary);

						$("#editClueModal").modal("show")

					}
				})
		})

		/*更新操作*/
		$("#updateBtn").click(function (){

			$.ajax({
				url : "workbench/clue/Update.do",
				data : {
					"id" : "${requestScope.clue.id}",
					"fullname" :$.trim($("#edit-fullname").val()),
					"appellation" :$.trim($("#edit-appellation").val()) ,
					"owner" : $.trim($("#edit-owner").val()),
					"company" : $.trim($("#edit-company").val()),
					"job" : $.trim($("#edit-job").val()),
					"email" : $.trim($("#edit-email").val()),
					"phone" : $.trim($("#edit-phone").val()),
					"website" : $.trim($("#edit-website").val()),
					"mphone" : $.trim($("#edit-mphone").val()),
					"state" : $.trim($("#edit-state").val()),
					"source" : $.trim($("#edit-source").val()),
					"description" : $.trim($("#edit-description").val()),
					"contactSummary" : $.trim($("#edit-contactSummary").val()),
					"nextContactTime" : $.trim($("#edit-nextContactTime").val()),
					"address" : $.trim($("#edit-address").val())
				},
				dataType : "json",
				type : "post",
				success : function (data) {
					if (data.success){
						/*刷新页面*/
						window.location.reload()
						/*清除所有者下拉框*/
						$("#edit-owner").empty();

						/*成功后刷新页面*/
						/*pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
*/						alert("修改成功")
						$("#editClueModal").modal("hide")

					}
					else {
						alert("更新失败")
					}
				}
			})
		})

		/*删除操作*/
		$("#deleteBtn").click(function (){

				if (confirm("确定要删除吗？")){

					$.ajax({
						url : "workbench/clue/Delete.do",
						data : {"id" : "${requestScope.clue.id}"},
						type :  "get",
						dataType : "json",
						success : function (data){
							if(data.success){
								/*回到index页面*/
								document.location.href = "web/system/toClue.do";

							}else{
								alert("删除失败")
							}
						}
					})
				}
		})
/*====================================================================*/
		/*备注*/
		showRemarkList();

		$("#remarkSaveBtn").click(function () {

			if ($.trim($("#remark").val())==null){
				alert("请输入备注内容")
			}

			var noteContent = $.trim($("#remark").val());
			$.ajax({
				url : "workbench/clue/saveRemark.do",
				data : {"noteContent":noteContent,"clueId":"${requestScope.clue.id}"},
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


		$("#updateRemarkBtn").click(function () {
			var id = $("#remarkId").val();
			var noteContent = $.trim($("#noteContent").val());
			var editBy = "${sessionScope.user.name}";
			$.ajax({
				url : "workbench/clue/remarkUpdate.do",
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
		/*-----------------------------------*/

		/*添加关联*/
		$("#addRelation").click(function (){
			/*绑定所有选中的复选框*/
			var $selectCheckBox =  $("input[name=selectCheckBox]:checked");
			if ($selectCheckBox.length==0){
				alert("请选择要关联的活动")
			}else {
				if (confirm("确定要关联吗？")){
					/*访问参数拼接*/
					var param = "";
					$.each($selectCheckBox,function (index,element) {
						param += "activityId="+$(element).val();

						/*如果不是最后一条id，则加上&*/
						if (index != ($selectCheckBox.length-1)){
							param += "&"
						}
					})
					param += "&clueId="+"${requestScope.clue.id}"
					/*alert(param)*/
					$.ajax({
						url : "workbench/clue/saveRelation.do",
						data : param,
						type :  "get",
						dataType : "json",
						success : function (data){
							if(data.success){
								showClueAndActivity()
							$("#bundModal").modal("hide")
							}else{
								alert("删除失败")
							}
						}
					})
				}

			}
		})

	});

	/*解除线索和活动联系的方法*/
    function releaseRelation(id){
       if (confirm("确定要解除关联吗？")){
           $.ajax({
               url: "workbench/clue/relieveActivityAndClueRelation.do",
               data: {"id":id},
               dataType: "json",
               type: "post",
               success : function (data){
                   if (data.success){
                       /*刷新关系列表*/
                       showClueAndActivity();
                   }
                   else {
                       alert("解除失败");
                   }
               }
           })
       }
    }

	function showClueAndActivity(){
		$("#relationCheckBox").prop("checked",false);
		$.ajax({
			url : "workbench/clue/getActivityByClueId.do",
			data : {"clueId":"${requestScope.clue.id}"},
			dataType : "json",
			type : "get",
			success : function (data) {
				/*填充*/
				var html = "";
				$.each(data,function (index,element) {
					html += '<tr id="'+element.id+'">'
					html += '<td>'+element.name+'</td>'
					html += '<td>'+element.startDate+'</td>'
					html += '<td>'+element.endDate+'</td>'
					html += '<td>'+element.owner+'</td>'
					html += '<td><a href="javascript:void(0);" onclick = releaseRelation(\''+element.id+'\') style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>'
					html += '</tr>'
				})
				$("#activityList").html(html);
			}
		})
	}

    function editRelation(){
    	$("#activityList2").empty();
        $.ajax({
            url : "workbench/clue/getActivityByClueId2.do",
            dataType :  "json",
            type : "get",
            data : {"name":$("#searchActivityBtn").val(),"clueId":"${requestScope.clue.id}"},
            success : function (data){
                var html = "";
                $.each(data,function (index,element){
                   html += '<tr>'
                   html += '<td><input type="checkbox" name="selectCheckBox" value="'+element.id+'"/></td>'
                   html += '<td>'+element.name+'</td>'
                   html += '<td>'+element.startDate+'</td>'
                   html += '<td>'+element.endDate+'</td>'
                   html += '<td>'+element.owner+'</td>'
                   html += '</tr>'
                })
                $("#activityList2").append(html);
                $("#bundModal").modal("show");

            }
        })
    }

    /*备注编辑按钮的事件*/
	function editRemark(id){
		/*隐藏域保存id*/
		$("#remarkId").val(id);
		/*填充模态窗口*/
		$("#noteContent").val($("#e"+id).text())
		$("#editRemarkModal").modal("show")
	}

	function deleteRemark(id){
		if (confirm("确定要删除吗？")){
			$.ajax({
				url: "workbench/clue/deleteRemark.do",
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



	function showRemarkList() {
		$.ajax({
			url : "workbench/clue/getRemarkListByCid.do",
			data : {"clueId" : "${requestScope.clue.id}"},
			dataType : "json",
			type : "get",
			success : function (data) {

				var html = "";

				$.each(data,function (index,element) {

					html += '<div id="'+element.id+'" class="remarkDiv" style="height: 60px;">';
					html += '<img title="zhangsan" src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="e'+element.id+'">'+element.noteContent+'</h5>';
					html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${requestScope.clue.fullname}</b> <small style="color: gray;" id="s'+element.id+'"> '+(element.editFlag==0?element.createTime:element.editTime)+' 由'+(element.editFlag==0?element.createBy:element.editBy)+'</small>';
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
	
</script>

</head>
<body>

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
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
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

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchActivityBtn" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="relationCheckBox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityList2">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="addRelation">关联</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" id="closeBtnX2" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="editClueForm" role="form">

						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
									<%-- <option>zhangsan</option>
                                     <option>lisi</option>
                                     <option>wangwu</option>--%>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<option></option>
									<option selected>先生</option>
									<c:forEach items="${applicationScope.appellation}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" >
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
									<option></option>
									<%--<option>试图联系</option>
                                    <option>将来联系</option>
                                    <option selected>已联系</option>
                                    <option>虚假线索</option>
                                    <option>丢失线索</option>
                                    <option>未联系</option>
                                    <option>需要条件</option>--%>
									<c:forEach items="${applicationScope.clueState}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<option></option>
									<%--  <option selected>广告</option>
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
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
								</div>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" id="closeBtn2" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="updateBtn" class="btn btn-primary ">更新</button>
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
			<h3>${requestScope.clue.fullname}${requestScope.clue.appellation} <small>${requestScope.clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.do?id=${clue.id}&fullname=${clue.fullname}&appellation=${clue.appellation}&company=${clue.company}&owner=${clue.owner}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" id="editBtn" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.fullname}${requestScope.clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${requestScope.clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkController" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<div id="remarks"> </div>
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" id="remarkSaveBtn" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table  class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityList">
						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" onclick = editRelation() style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>