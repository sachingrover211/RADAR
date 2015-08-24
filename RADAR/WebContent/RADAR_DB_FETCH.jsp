<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>
<%@ page import ="java.sql.SQLException" %>
<%@ page import ="java.sql.ResultSet" %>
<%@ page import ="java.sql.ResultSetMetaData" %>
<%@ page import ="org.json.*" %>
<%@ page import ="org.json.JSONObject" %>
<%@ page import ="org.json.JSONArray" %>
<%@ page import ="org.json.JSONException" %>

<%
//String tasks=request.getParameter("taskList");
//String plans=request.getParameter("planList");

//session.putValue("userid",user);

Class.forName("com.mysql.jdbc.Driver"); 
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/radar","root","password");
Statement st= con.createStatement();
ResultSet rs = st.executeQuery("select * from fire_stations");

JSONArray json_arr = new JSONArray();
ResultSetMetaData rsmd = rs.getMetaData();
int numColumns = rsmd.getColumnCount();

while(rs.next()) {
	JSONObject obj = new JSONObject();
	for (int i=1; i<numColumns+1; i++) {
		String column_name = rsmd.getColumnName(i);
		if(rsmd.getColumnType(i)==java.sql.Types.INTEGER) {
	         obj.put(column_name, rs.getInt(column_name));
	    }
		else if(rsmd.getColumnType(i)==java.sql.Types.VARCHAR) {
	         obj.put(column_name, rs.getString(column_name));
	    }
	}
	json_arr.put(obj);
}


Statement st1= con.createStatement();
ResultSet rs1 = st1.executeQuery("select * from police_stations");
ResultSetMetaData rsmd1 = rs1.getMetaData();
int numColumns1 = rsmd1.getColumnCount();

while(rs1.next()) {
	JSONObject obj = new JSONObject();
	for (int i=1; i<numColumns1+1; i++) {
		String column_name = rsmd1.getColumnName(i);
		if(rsmd1.getColumnType(i)==java.sql.Types.INTEGER) {
	         obj.put(column_name, rs1.getInt(column_name));
	    }
		else if(rsmd1.getColumnType(i)==java.sql.Types.VARCHAR) {
	         obj.put(column_name, rs1.getString(column_name));
	    }
	}
	json_arr.put(obj);
}

Statement st2= con.createStatement();
ResultSet rs2 = st2.executeQuery("select * from hospitals");
ResultSetMetaData rsmd2 = rs2.getMetaData();
int numColumns2 = rsmd2.getColumnCount();

while(rs2.next()) {
	JSONObject obj = new JSONObject();
	for (int i=1; i<numColumns2+1; i++) {
		String column_name = rsmd2.getColumnName(i);
		if(rsmd2.getColumnType(i)==java.sql.Types.INTEGER) {
	         obj.put(column_name, rs2.getInt(column_name));
	    }
		else if(rsmd2.getColumnType(i)==java.sql.Types.VARCHAR) {
	         obj.put(column_name, rs2.getString(column_name));
	    }
	}
	json_arr.put(obj);
}


out.print(json_arr);
out.flush();


//response.setContentType("application/json");
//response.getWriter().write(json_arr.toString().trim());
%>
