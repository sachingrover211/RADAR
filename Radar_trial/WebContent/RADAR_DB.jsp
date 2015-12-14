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
String tasklist=request.getParameter("taskList");
//String planlist=request.getParameter("planList");
//String sglist=request.getParameter("sgList");

String[] tasks = tasklist.split(",");
//String[] plans = planlist.split(",");
//String[] subgoals = sglist.split(",");
//String tasks=request.getParameter("taskList");
//String plans=request.getParameter("planList");

//session.putValue("userid",user);

Class.forName("com.mysql.jdbc.Driver"); 
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/radar","root","root");
Statement st= con.createStatement();
ResultSet rs;
st.executeUpdate("delete from tasks");
st.executeUpdate("update fire_stations set rescuers=1, helicopters =1, big_engines=1, small_engines=1, bulldozers=1, ladders =1");
for(int i=0; i<tasks.length; i++){
	if(tasks[i].equals("Big Fire At Byeng")){
		st.executeUpdate("update fire_stations set rescuers=0, small_engines=0, big_engines =0");
		int res1=st.executeUpdate("insert into tasks values ('fire_at byeng')");		
	}	
	else if (tasks[i].equals("Small Fire At Byeng")){
		st.executeUpdate("update fire_stations set small_engines=0, big_engines =0, rescuers = 0");		
		int res1=st.executeUpdate("insert into tasks values ('fire_at byeng'), ('small_fire_at byeng')");
	}
}
//for(int i=0; i<plans.length; i++){
//	int res1=st.executeUpdate("insert into plans values ('"+plans[i]+"')");
//}
//for(int i=0; i<subgoals.length; i++){
//	int res1=st.executeUpdate("insert into subgoals values ('"+subgoals[i]+"')");
//}

//int res1=st.executeUpdate("insert into tasks values ('"+tasks+"')");
//int res2=st.executeUpdate("insert into plans values ('"+plans+"')");

//int i=st.executeUpdate("insert into users values ('"+user+"','"+pwd+"','"+fname+"','"+lname+"','"+email+"')");


%>
</body>
</html>
