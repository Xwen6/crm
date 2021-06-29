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
			showRemarkList();
			$("#addRemarkBtn").on("click",function () {
				$.ajax({
					url:"workbench/visit/addRemark.do",
					data:{"noteContent":$.trim($("#remark").val()),"createBy":"${sessionScope.user.id}","visitId":"${visitVo.id}"},
					dataType:"json",
					type:"post",
					success:function (resp) {
						$("#remark").val("");
						if (resp)
						{
							showRemarkList();
						}
						else
						{
							alert("添加失败！")
						}
					}
				})
			})
		});
		function showRemarkList() {
			$("#markDiv").empty();
			$.ajax({
				url: "workbench/visit/getRemarkList.do",
				data: {"visitId":"${visitVo.id}"},
				dataType: "json",
				success:function (resp) {
					$.each(resp,function (i,n) {
						$("#markDiv").append(
								'<div class="remarkDiv" style="height: 60px;">'+
									'<img title="${visitVo.owner}" src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">'+
									'<div style="position: relative; top: -40px; left: 40px;" >'+
										'<h5 id="contentH5">'+n.noteContent+'</h5>'+
										'<font color="gray">任务</font> <font color="gray">-</font> <b>${visitVo.subject}</b> <small style="color: gray;"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由 '+(n.editFlag==0?n.createBy+" 创建":n.editBy+" 修改")+'</small>'+
										'<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'+
										'<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>'+
										'&nbsp;&nbsp;&nbsp;&nbsp;'+
										'<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>'+
										'</div>'+
									'</div>'+
								'</div>'
						);
					})
				}
			})
		}
		function editRemark(id) {
			$("#editRemarkModal").modal("show");
			$("#noteContent").val($("#contentH5").text());
			$("#editRemarkBtn").on("click",function () {
				$.ajax({
					url:"workbench/visit/editRemark.do",
					data:{"id":id,"noteContent":$.trim($("#noteContent").val()),"editBy":"${sessionScope.user.id}"},
					dataType:"json",
					type:"post",
					success:function (resp) {
						if (resp)
						{
							$("#editRemarkModal").modal("hide");
							showRemarkList();
						}
						else
						{
							alert("修改失败！")
						}
					}
				})
			})
		}
		function deleteRemark(id) {
			if (confirm("是否删除？")) {
				$.ajax({
					url: "workbench/visit/deleteRemark.do",
					data: {"id": id},
					dataType: "json",
					type: "post",
					success: function (resp) {
						if (resp) {
							showRemarkList();
						} else {
							alert("删除失败！")
						}
					}
				})
			}
		}

	</script>

</head>
<body>

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
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
					<button type="button" class="btn btn-primary" id="editRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.go(-1);"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>拜访客户</h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='web/system/toVisitEditTask.do?id=${visitVo.id}';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" onclick="window.location.href='workbench/visit/detailDeleteVisit.do?id=${visitVo.id}';"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">主题</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${visitVo.subject}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">到期日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${visitVo.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">联系人</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${visitVo.contactsName}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">状态</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${visitVo.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">优先级</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${visitVo.priority}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">任务所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${visitVo.ownerName}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">提醒时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${visitVo.startTime}（${visitVo.repeatType}）</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${visitVo.createName}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${visitVo.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${visitVo.editName != null?visitVo.editName:"无"}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${visitVo.editTime != null?visitVo.editTime:""}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${visitVo.description}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: -20px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<div id="markDiv"></div>
		
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">任务</font> <font color="gray">-</font> <b>拜访客户</b> <small style="color: gray;"> 2017-01-22 10:10:10 星期二由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">任务</font> <font color="gray">-</font> <b>拜访客户</b> <small style="color: gray;"> 2017-01-22 10:10:10 星期二由zhangsan</small>
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
					<button type="button" id="addRemarkBtn" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>