<%--
  Created by IntelliJ IDEA.
  User: 25021
  Date: 2021/6/6
  Time: 16:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>mytitle</title>
    <style type="text/css">

        .main{
            width: 800px;
            height: 800px;
            align-items: center;

        }

    </style>

    <script src="static/jquery/jquery-1.11.1-min.js"></script>
    <script src="static/ECharts/echarts.min.js"></script>

</head>
    <body>
        <div id="main" class="main">

        </div>

        <script type="text/javascript">
            $.ajax({
                url: "workbench/activity/chart.do",
                dataType : "json",
                type : "get",
                success : function (result) {
                    var myChart = echarts.init(document.getElementById('main'));
                    option = {
                        title: {
                            text: '市场活动',
                            left: 'center'
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left',
                        },
                        series: [
                            {
                                type: 'pie',
                                radius: '40%',
                                data: result,
                                emphasis: {
                                    itemStyle: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                }
                            }
                        ]
                    };
                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })
        </script>
    </body>
</html>
