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
        url: "workbench/clue/chart.do",
        dataType : "json",
        type : "get",
        success : function (result) {
            var myChart = echarts.init(document.getElementById('main'));
            option = {
                title: {
                    text: '漏斗图',
                    subtext: '纯属虚构'
                },
                tooltip: {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c}%"
                },
                toolbox: {
                    feature: {
                        dataView: {readOnly: false},
                        restore: {},
                        saveAsImage: {}
                    }
                },
                legend: {
                    data: result.typeLis
                },

                series: [
                    {
                        name:'漏斗图',
                        type:'funnel',
                        left: '10%',
                        top: 60,
                        //x2: 80,
                        bottom: 60,
                        width: '80%',
                        // height: {totalHeight} - y - y2,
                        min: 0,
                        max: 100,
                        minSize: '0%',
                        maxSize: '100%',
                        sort: 'descending',
                        gap: 2,
                        label: {
                            show: true,
                            position: 'inside'
                        },
                        labelLine: {
                            length: 10,
                            lineStyle: {
                                width: 1,
                                type: 'solid'
                            }
                        },
                        itemStyle: {
                            borderColor: '#fff',
                            borderWidth: 1
                        },
                        emphasis: {
                            label: {
                                fontSize: 20
                            }
                        },
                        data: result.dataList1
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
