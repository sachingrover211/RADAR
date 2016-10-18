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

//Runtime run = Runtime.getRuntime();
//Process pr = run.exec("/home/vmeduri/Desktop/FastDownward/src/test_js.sh");

ProcessBuilder pb = new ProcessBuilder(
	      "/home/local/ASUAD/ssengu15/Documents/code/RADAR/src/test_js_new.sh");
	    Process p = pb.start();     // Start the process.
	    p.waitFor(); 

Class.forName("com.mysql.jdbc.Driver"); 
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/radar","root","root");
Statement st= con.createStatement();
ResultSet rs = st.executeQuery("select * from alert");

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
out.print(json_arr);
out.flush();


//response.setContentType("application/json");
//response.getWriter().write(json_arr.toString().trim());
%>
