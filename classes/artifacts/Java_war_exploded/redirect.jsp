<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK"%>
        <%@page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="GBK">
<title>����ѡ��</title>
<h3 align=center>��ѡ��鿴������</h3>
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

  font-family: "����ϸ��";
  background:url("Desktop/Java��������/Java��������/web/p1.gif") no-repeat;
  background-size: 200%;
}
	</style>
	     	<script>
			function redirectTo(targetJSP, name) {
				var url = targetJSP; // �����ض��� URL
				window.location.href = url; // ��ҳ���ض���Ŀ�� JSP ҳ��
			}
		</script>

</head>
<body background="Desktop/Java��������/Java��������/web/p1.gifp/Java��������/Java��������/web/p1.gif"  >
	<form  method="post" name="form">

	  	<script language="JavaScript">//ˢ��
			setTimeout(function(){location.reload()},3000);
			//ָ��1��ˢ��һ��
		</script>

		<center>
			<input type="button" onclick="redirectTo('light.jsp');" name="light" value="��Դ"></br>
			<input type="button" onclick="redirectTo('temperature.jsp');" name="temp" value="��ʪ��"></br>
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
                "    <th>id</th><th>����ǿ��</th><th>ʱ��</th>\n" +
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
                    "    <th>id</th><th>�¶�</th><th>ʪ��</th><th>ʱ��</th>\n" +
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
        out.println("<h1 align=center>����ʧ��</h1>");
        out.println(sqlException);
    }
    out.close();
    statement.close();
    resultSet.close();
    connection.close();
  %>


</body>
</html>
