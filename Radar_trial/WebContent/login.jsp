<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
String userid=request.getParameter("user");
session.putValue("userid",userid);
String pwd=request.getParameter("pwd");
Class.forName("com.mysql.jdbc.Driver");
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/radar","root","password");
Statement st= con.createStatement();
ResultSet rs=st.executeQuery("select * from users where user_id='"+userid+"'");
if(rs.next())
{
if(rs.getString(2).equals(pwd))
{
out.println("welcome"+userid);

}
else
{
out.println("Invalid password try again");
}
}
else
%>
</body>
</html>