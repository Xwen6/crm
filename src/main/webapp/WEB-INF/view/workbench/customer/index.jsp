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

	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		pageList(1,2);
		getUserList();

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
			pickerPosition: "top-left"
		});

		$("#searchBtn").click(function () {
			/*点击查找的时候，将填入到text中的val保存到隐藏域当中*/
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-website").val($.trim($("#search-website").val()));
			$("#hidden-phone").val($.trim($("#search-phone").val()));



			pageList(1,2);
		})

		/*新增客户*/
		$("#saveCustomerBtn").click(function () {
			$.ajax({
				url :"workbench/customer/customerSave.do",
				data : {
					"owner" : $.trim($("#create-owner").val()),
					"name" :  $.trim($("#create-name").val()),
					"website" :  $.trim($("#create-website").val()),
					"phone" :  $.trim($("#create-phone").val()),
					"contactSummary" :  $.trim($("#create-contactSummary").val()),
					"description" : $.trim($("#create-description").val()),
					"nextContactTime" : $.trim($("#create-nextContactTime").val()),
					"address" : $.trim($("#create-address").val())

				},
				type :"post",
				dataType :"json",
				success : function (data){
					/*{"success":true}*/
					/*alert(data.success)*/
					if (data.success){
						/*重置表单*/
						$("#CustomerAddForm")[0].reset();
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#createCustomerModal").modal("hide");
					}else {
						alert("添加失败");
					}
				}
			})
		})

		/*x修改*/
		/*填充修改模态窗口*/
		$("#editBtn").click(function () {

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
			}
		})

		/*执行修改*/
		$("#updateBtn").click(function (){
			/*获取用户的修改后的值*/
			var id = $("input[name=selectCheckBox]:checked").val()
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
						pageList(1,2);

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
                    var param = "id=";
                    $.each($selectCheckBox,function (index,element) {
                        param += $(element).val();
                        /*如果不是最后一条id，则加上&*/
                        if (index != ($selectCheckBox.length-1)){
                            param += ","
                        }
                    })

                    	/*	alert(param);*/
                    $.ajax({
                        url : "workbench/customer/deleteCustomer.do",
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
		$("#search-phone").val($.trim($("#hidden-phone").val()));
		$("#search-website").val($.trim($("#hidden-website").val()));

		/*alert($("#search-name").val())*/
		$.ajax({
			url : "workbench/customer/PageList.do",
			data: {
				"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"phone":$.trim($("#search-phone").val()),
				"website":$.trim($("#search-website").val())
			},
			dataType:"json",
			type:"get",
			success:function (data){
				var html = ""
				$.each(data.pageList,function (index,element) {

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="selectCheckBox" value="'+element.id+'"/></td>'
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id='+element.id+'\';">'+element.name+'</a></td>'
					html += '<td>'+element.owner+'</td>';
					html += '<td>'+element.phone+'</td>';
					html += '<td>'+element.website+'</td>';
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

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form id="CustomerAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
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
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label ">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveCustomerBtn" class="btn btn-primary" data-dismiss="modal">保存</button>
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
								 <%-- <option>zhangsan</option>
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
                                    <input type="text" class="form-control" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address">北京大兴大族企业湾</textarea>
                                </div>
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
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<%--保存查询信息--%>

			<input type="hidden" id="hidden-name">
			<input type="hidden" id="hidden-owner">
			<input type="hidden" id="hidden-phone">
			<input type="hidden" id="hidden-website">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" id="search-name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="search-owner" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" id="search-phone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" id="search-website" type="text">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" id="addCustomer" class="btn btn-primary" data-toggle="modal" data-target="#createCustomerModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" id="editBtn" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="selectAllCheckBox" type="checkbox" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
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