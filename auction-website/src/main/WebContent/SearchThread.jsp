<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.dbproj.pkg.*,com.AuctionSite.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create Forum</title>
<head>
		<style type="text/css">
		.body {
			background-color: #ffe5e5;
		}
		</style>
		<title>Search Thread</title>
	</head>
	<body class ="body">
	<br>
	Results
	<br>
	<br>
	<%
	String username = request.getParameter("username");
	String pass = request.getParameter("pass");

	session.setAttribute("username", username);
	session.setAttribute("pass", pass);	
	
	try {
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the InfoPage.jsp
		String keyword = request.getParameter("keywords");
		
		//craft query
		String select = "SELECT * FROM threads WHERE threadTitle LIKE "+"'%"+keyword+"%'";

		//Run the query against the database.
		ResultSet result = stmt.executeQuery(select);
%>
		
		<%  while(result.next()) { %>
		<a href="thread.jsp?threadID=<%=result.getInt("threadID")%>&username=<%=username%>&pass=<%=pass%>"><%=
		result.getString("threadTitle")%></a><br>
			<% 				}
		
	} catch (Exception ex) {
		out.print(ex);
		out.print("Login failed :()");
	}	%>
	
	<br>
	<form method = "get" action="InfoPage.jsp">
				<input type="button" value="Return" onclick=location.href="SearchPage.jsp?username=<%=username%>&pass=<%=pass%>">
		</form>
	<br>
	
</body>
</html>