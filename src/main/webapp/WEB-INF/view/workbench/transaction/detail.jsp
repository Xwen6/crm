<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="wyu.xwen.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@ page import="wyu.xwen.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
	/*阶段的列表*/
	List<DicValue> dvList = (List<DicValue>) request.getServletContext().getAttribute("stage");
	/*可能性*/
	Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");
	Set<String> keySet = pMap.keySet();
	/*取得状态的分界点*/
	int index = 0;
	for(int i = 0;i<dvList.size();i++){
		DicValue dv = dvList.get(i);
		String stage = dv.getValue();
		String possibility = pMap.get(stage);
		if ("0".equals(possibility)){
			index=i;
			break;
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>

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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		/*拼接Json*/
		/*var jsonObj = {
			<%--<%
                 for (String key : keySet) {
                    String value = pMap.get(key);
                %>--%>

			<%--<%=key%>":<%=value%>,--%>


			<%--<%
            }
            %>--%>
		}*/

		/*var stage = $("#stage").text();
		var possibility = jsonObj[stage];
		$("#possibility").text(possibility);*/

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
		
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });

		/*页面加载完毕之后刷新历史记录*/
		showTranHistory();
	});

	function showTranHistory(){
		$.ajax({
			url : "workbench/transaction/getTranHistoryList.do",
			dataType : "json",
			type : "get",
			data : {"tranId":"${requestScope.tran.id}"},
			success : function (data) {
				var html = "";
				$.each(data,function (index,element) {
					html += '<tr>'
					html += '<td>'+element.stage+'</td>'
					html += '<td>'+element.money+'</td>'
					html += '<td>'+element.possibility+'</td>'
					html += '<td>'+element.expectedDate+'</td>'
					html += '<td>'+element.createTime+'</td>'
					html += '<td>'+element.createBy+'</td>'
					html += '</tr>'
				})
				$("#tranHistoryList").html(html)
			}
		})
	}

	function changeStage(stage,id){
		alert(stage)
		$.ajax({
			url : "workbench/transaction/changeStage.do",
			data : {
				"id":"${requestScope.tran.id}",
				"stage":stage,
			},
			dataType : "json",
			type : "post",
			success : function (data) {
				if (data.success){
					$("#stage").html(data.tran.stage)
					$("#possibility").html(data.tran.possibility)
					$("#editBy").html(data.tran.editBy)
					$("#editTime").html(data.tran.editTime)

					changeIcon(stage,id);
				}else {
					alert("修改失败");
				}
			} 
		})
	}

	function changeIcon(stage,id){
		/*当前阶段*/
		var currentStage = stage;
		/*当前可能性*/
		var currentPossibility = $("#possibility").html();
		/*当前阶段的下标*/
		var currentIndex = id;
		/*阶段分界点下标*/
		var demarcationIndex =  <%=index%>;
		/*如果当前阶段的下标为分界点后的*/
		if (currentIndex >= demarcationIndex){
			/*遍历分界点之前的*/
			for (var i=0;i<demarcationIndex;i++){
				/*黑圈*/
				/*先移除之前的样式*/
				$("#"+i).removeClass();
				/*添加样式*/
				$("#"+i).addClass("glyphicon glyphicon-record mystage");
				 /*样式颜色*/
				$("#"+i).css("color","#000000")
			}
			/*遍历分界点之后的*/
			for (var i=<%=dvList.size()%>;i>=demarcationIndex;i--){
				/*当前阶段的为红叉*/
				if (currentIndex==i){
					/*红叉*/
					$("#"+i).removeClass();
					/*添加样式*/
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					/*样式颜色*/
					$("#"+i).css("color","#ff0000")
				}
				else  {
					/*黑叉*/
					$("#"+i).removeClass();
					/*添加样式*/
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					/*样式颜色*/
					$("#"+i).css("color","#000000")
				}
			}
			
		}
		else {
		     for (var i=0;i< <%=dvList.size()%>;i++){
		     	if (i>=demarcationIndex){
		     		/*黑叉*/
					$("#"+i).removeClass();
					/*添加样式*/
					$("#"+i).addClass("glyphicon glyphicon-remove mystage");
					/*样式颜色*/
					$("#"+i).css("color","#000000")
				}
		     	/*如果等于当前阶段的下标为选中*/
				 if (i==currentIndex){
					 $("#"+i).removeClass();
					 /*添加样式*/
					 $("#"+i).addClass("glyphicon glyphicon-map-marker mystage");
					 /*样式颜色*/
					 $("#"+i).css("color","#90f790")
				 }
				 /*小于当前阶段下标为绿圈*/
				 else if (i<currentIndex){
					 $("#"+i).removeClass();
					 /*添加样式*/
					 $("#"+i).addClass("glyphicon glyphicon-ok-circle mystage");
					 /*样式颜色*/
					 $("#"+i).css("color","#90f790")
				 }
				 /*如果大于当前阶段下标，小于分界点下标为黑圈*/
				 else if (currentIndex<i<demarcationIndex){
					 $("#"+i).removeClass();
					 /*添加样式*/
					 $("#"+i).addClass("glyphicon glyphicon-record mystage");
					 /*样式颜色*/
					 $("#"+i).css("color","#000000")
				 }
			 }

		}
	}
	
	
</script>

</head>
<body>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.tran.customerName}-${requestScope.tran.name} <small>￥${requestScope.tran.money}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='edit.jsp';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;" id="stageList">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%
			/*当前页面的状态*/
			Tran tran = (Tran) request.getAttribute("tran");
			String currentStage = tran.getStage();
			/*根据当前状态取得当前可能性*/
			String currentPossibility = pMap.get(currentStage);
			/*判断当前可能性*/
			/*如果当前可能性为0*/
			if ("0".equals(currentPossibility)){
				/*前面阶段为黑圈*/
				for (int i = 0;i<dvList.size();i++){
					/*取得阶段*/
					DicValue dv = dvList.get(i);
					String stage = dv.getText();
					String possibility = pMap.get(stage);
					/*找出为0的可能性*/
					if ("0".equals(possibility)){
						/*当前的stage是否与该stage相等*/
						if (stage.equals(currentStage)){
							/*红叉*/
		%>
							<span id="<%=i%>"  onclick="changeStage('<%=stage%>','<%=i%>')"
								  class="glyphicon glyphicon-remove mystage"
							  data-toggle="popover"
							  data-placement="bottom"
							  data-content="<%=stage%>" style="color: red;">
							</span>
							-----------
		<%
						}
						else {
							/*黑叉*/
		%>
							<span id="<%=i%>"  onclick="changeStage('<%=stage%>','<%=i%>')"
								  class="glyphicon glyphicon-remove mystage"
							  data-toggle="popover"
							  data-placement="bottom"
							  data-content="<%=stage%>" >
							</span>
		<%
						}
					}
					else {
						/*黑圈*/
		%>
						<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
							  class="glyphicon glyphicon-record mystage"
							  data-toggle="popover"
							  data-placement="bottom"
							  data-content="<%=stage%>" >
						</span>
						-----------
		<%


		}
				}
			}
			/*如果不为零*/
			else {
				/*找出当前阶段的下标*/
				int stageIndex = 0;
				for (int i = 0;i<dvList.size();i++){
					/*取得阶段*/
					DicValue dv = dvList.get(i);
					String stage = dv.getText();
					/*如果是该阶段是当前阶段记录并赋值*/
					if (stage.equals(currentStage)){
						stageIndex=i;
						break;
					}
				}

				/*大于当前阶段小于可能性为0阶段的都为黑圈*/
				for (int i = 0;i<dvList.size();i++ ){
					DicValue dv = dvList.get(i);
					String stage = dv.getValue();
					String possibility = pMap.get(stage);
					if (i==stageIndex){
		%>
					    <span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
					    	  class="glyphicon glyphicon-map-marker mystage"
					    	  data-toggle="popover"
					    	  data-placement="bottom"
					    	  data-content="<%=stage%>" style="color: #90F790;">
					    </span>
						-----------
		<%
					}
					if (i<stageIndex){
						/*绿圈*/
		%>
						<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
							  class="glyphicon glyphicon-ok-circle mystage"
							  data-toggle="popover"
							  data-placement="bottom"
							  data-content="<%=stage%>" style="color: #90F790;">
						</span>
						-----------
		<%
					}
					if (stageIndex<i&&i<index){
						/*黑圈*/
		%>
						<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
							  class="glyphicon glyphicon-record mystage"
							  data-toggle="popover"
							  data-placement="bottom"
							  data-content="<%=stage%>" >
						</span>
						-----------
		<%

		}
					if (i>=index){
						/*黑叉*/
		%>
						<span id="<%=i%>"  onclick="changeStage('<%=stage%>','<%=i%>')"
							  class="glyphicon glyphicon-remove mystage"
							  data-toggle="popover"
							  data-placement="bottom"
							  data-content="<%=stage%>" >
						</span>
						-----------
		<%
					}
				}
			}
		%>


		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<span class="closingDate">${requestScope.tran.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.customerName}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${requestScope.tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${requestScope.tran.possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.activityName}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.contactsName}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${requestScope.tran.editBy}&nbsp;&nbsp;</b><small id="editTime" style="font-size: 10px; color: gray;">${requestScope.tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述 </div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.tran.description}&nbsp;&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${requestScope.tran.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
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
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="tranHistoryList">
						<%--<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>10</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>需求分析</td>
							<td>5,000</td>
							<td>20</td>
							<td>2017-02-07</td>
							<td>2016-10-20 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>谈判/复审</td>
							<td>5,000</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>2017-02-09 10:10:10</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>