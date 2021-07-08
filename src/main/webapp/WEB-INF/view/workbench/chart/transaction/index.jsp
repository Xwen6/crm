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
        *{
            margin: 0;
            padding: 0;
        }
        .main{
            width: 100%;
            height: 100%;
            position: absolute;

        }
        .quarter-div{
            width: 50%;
            height: 50%;
            float: left;
            display: flex;
            justify-content: center;
            align-items: center;


        }

        .content {
            width: 95%;
            height: 90%;
            margin: 0 auto;
            background:#fafcfd;


        }
    </style>

    <script src="static/jquery/jquery-1.11.1-min.js"></script>
    <script src="static/ECharts/echarts.min.js"></script>

</head>
<body>
    <div class="main">
        <div class="quarter-div blue">
            <div id="main1" class="content"></div>
        </div>

        <div class="quarter-div green">
            <div id="main2" class="content">	 </div>
        </div>

        <div class="quarter-div orange">
            <div id="main3" class="content" >	 </div>
        </div>

        <div class="quarter-div yellow">
            <div id="main4" class="content" >	 </div>
        </div>
    </div>

    <script type="text/javascript">

        $(function () {
            $.ajax({
                url : "workbench/transaction/chart1.do",
                dataType : "json",
                type : "get",
                success : function (result) {

                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main1'));
                    // 指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '近七日新增交易'
                        },
                        tooltip: {},
                        legend: {
                            data:['交易']
                        },
                        xAxis: {
                            data: result.countKey
                        },
                        yAxis: {},
                        series: [{
                            name: '交易',
                            type: 'bar',
                            data: result.countValue
                        }]
                    };
                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })

            $.ajax({
                url: "workbench/transaction/chart2.do",
                dataType : "json",
                type : "get",
                success : function (result) {
                    var myChart = echarts.init(document.getElementById('main2'));
                    option = {
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            top: '5%',
                            left: 'center'
                        },
                        series: [
                            {
                                name: '访问来源',
                                type: 'pie',
                                radius: ['40%', '80%'],
                                avoidLabelOverlap: false,
                                label: {
                                    show: false,
                                    position: 'center'
                                },
                                emphasis: {
                                    label: {
                                        show: true,
                                        fontSize: '40',
                                        fontWeight: 'bold'
                                    }
                                },
                                labelLine: {
                                    show: false
                                },
                                data: result
                            }
                        ]
                    };
                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })

            $.ajax({
                url : "workbench/transaction/chart3.do",
                dataType : "json",
                type : "get",
                success : function (result) {
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main3'));
                    option = {
                        xAxis: {
                            type: 'category',
                            data: result.countKey
                        },
                        yAxis: {
                            type: 'value'
                        },
                        series: [{
                            data: result.countValue,
                            type: 'line',
                            smooth: true
                        }]
                    };
                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            })
            $.ajax({
                url : "workbench/transaction/chart4.do",
                dataType : "json",
                type : "get",
                success : function (result) {
                    var myChart = echarts.init(document.getElementById('main4'));
                    option = {
                        title: {
                            text: '每种类型的交易',
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
                                name: '访问来源',
                                type: 'pie',
                                radius: '50%',
                                data:result,
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
        })

    </script>
</body>
</html>
