<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>环境监测系统</title>
    <h3 align=center>当前光照强度</h3>
     	<script>
			function redirectTo(targetJSP, name) {
				var url = targetJSP; // 构造重定向 URL
				window.location.href = url; // 将页面重定向到目标 JSP 页面
			}
		</script>
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
		  width: 10px;
		}
		table tr:nth-child(odd){
		  background: #fff;
		}
		table tr:nth-child(even){
		  background: #F5FAFA;
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
	</style>


</head>
<body background="Desktop/Java串口连接/Java串口连接/web/p1.gifp/Java串口连接/Java串口连接/web/p1.gif">

<script language="JavaScript">//刷新
		setTimeout(function(){location.reload()},3000);
		//指定1秒刷新一次
	</script>


<form>
	<center>
		<input type="button" onclick="redirectTo('redirect.jsp');" name="redi" value="返回">
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
        String sql = "select * from lightstrength";
        statement = connection.createStatement();
        int n = 0;
        resultSet = statement.executeQuery(sql);
        out.println("<table align=\"center\" border=\"2px\">\n" +
                "    <tr>\n" +
                "    <th>id</th><th>光照强度</th><th>时间</th>\n" +
                "    </tr>");
        while (resultSet.next()) {
        	n++;
            int id = resultSet.getInt("id");
            String light = resultSet.getString("light");
            String time = resultSet.getString("create_time");
            out.println( "<tr>\n" +
                    " <td>"+id+"</td><td>"+light+"</td><td>"+time+"</td>\n" +
                    " </tr>");
        }
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
  	<script language="JavaScript">//刷新
		setTimeout(function(){location.reload()},1000);
		//指定1秒刷新一次
	</script>



</body>
</html>
