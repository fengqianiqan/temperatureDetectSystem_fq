<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
        <%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="GBK">
<title>功能选择</title>
<h3 align=center>请选择查看的数据</h3>
	<style scoped>
			table{
			  border-collapse: collapse;
			  margin: 0 auto;
			  text-align: center;
			}
			table td, table th{
			  border: 1px solid #cad9ea;
			  color: #666;
			  height: 30px;
			}
			table thead th{
			  background-color: #CCE8EB;
			  width: 100px;
			}
			table tr:nth-child(odd){
			  background: #fff;
			}
			table tr:nth-child(even){
			  background: #F5FAFA;
			}
		</style>
	<style>
		input{
            background-color:#f66f6a;
            color:white;
            width: 400px;
            height: 45px;
            border:0;
            font-size: 16px;
            box-sizing: content-box;
           	border-radius: 5px;
        }
        input:hover{
            background-color: #a54b4a;
        }
        html,body{
	width:100%;
	height:100%
}
        body{

  font-family: "华文细黑";
  background:url("Desktop/Java串口连接/Java串口连接/web/p1.gif") no-repeat;
  background-size: 200%;
}
	</style>
	     	<script>
			function redirectTo(targetJSP, name) {
				var url = targetJSP; // 构造重定向 URL
				window.location.href = url; // 将页面重定向到目标 JSP 页面
			}
		</script>

</head>
<body background="Desktop/Java串口连接/Java串口连接/web/p1.gifp/Java串口连接/Java串口连接/web/p1.gif"  >
	<form  method="post" name="form">

	  	<script language="JavaScript">//刷新
			setTimeout(function(){location.reload()},3000);
			//指定1秒刷新一次
		</script>

		<center>
			<input type="button" onclick="redirectTo('light.jsp');" name="light" value="光源"></br>
			<input type="button" onclick="redirectTo('temperature.jsp');" name="temp" value="温湿度"></br>
		</center>
	</form>

	<%
    request.setCharacterEncoding("utf-8");
    Connection connection=null;
    Statement statement=null;
    ResultSet resultSet=null;
    try {
    	Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/zigbee1?characterEncoding=utf-8","root","111111");
        String sql1 = "select * from lightstrength";
        String sql2 = "select * from zigbee_receive_data";
        statement = connection.createStatement();

        resultSet = statement.executeQuery(sql1);
        out.println("</br><table align=\"center\" border=\"2px\">\n" +
                "    <tr>\n" +
                "    <th>id</th><th>光照强度</th><th>时间</th>\n" +
                "    </tr>");
            resultSet.next();
            int id = resultSet.getInt("id");
            String light = resultSet.getString("light");
            String time = resultSet.getString("create_time");
            out.println( "<tr>\n" +
                    " <td>"+id+"</td><td>"+light+"</td><td>"+time+"</td>\n" +
                    " </tr>");
        	out.println("</table>");

        	resultSet = statement.executeQuery(sql2);
        	out.println("</br><table align=\"center\" border=\"2px\">\n" +
                    "    <tr>\n" +
                    "    <th>id</th><th>温度</th><th>湿度</th><th>时间</th>\n" +
                    "    </tr>");
        	resultSet.next();
        	int id1 = resultSet.getInt("id");
        	String temp = resultSet.getString("temperature");
            String humid = resultSet.getString("humidity");
            String time1 = resultSet.getString("create_time");
            out.println( "<tr>\n" +
                    " <td>"+id1+"</td><td>"+temp+"</td><td>"+humid+"</td><td>"+time1+"</td>\n" +
                    " </tr>");
            out.println("</table>");

    }catch (SQLException sqlException){
        out.println("<h1 align=center>加载失败</h1>");
        out.println(sqlException);
    }
    out.close();
    statement.close();
    resultSet.close();
    connection.close();
  %>


</body>
</html>
