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
		<title>Post Thread</title>
	</head>
	<body class ="body">
	<%
	try {
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String username = request.getParameter("username");
		String pass = request.getParameter("pass");
	
		session.setAttribute("username", username);
		session.setAttribute("pass", pass);

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the InfoPage.jsp
		String ThreadTitle = request.getParameter("ThreadTitle");
		
		//craft query
		String select = "SELECT count(*) FROM threads WHERE threadTitle="+"'"+ThreadTitle+"'";

		//Run the query against the database.
		ResultSet result = stmt.executeQuery(select);
%>
		
		<h3><%
			result.next();
			if(result.getString("count(*)").equals("1")){
				%>Title already taken
				<br>
				
				<form method = "get" action="InfoPage.jsp">
					<input type="button" value="Back" onclick=location.href="AddThread.jsp?username=<%=username%>&pass=<%=pass%>">				
					</form>
				
				
				<%
			}else if(ThreadTitle.length() < 300){
				
				%>Created new Thread<br><% 
				
				String insert = "INSERT INTO threads(threadID, threadTitle,threadMadeBy, isOpen)"
						+ "VALUES (?, ?,?,?)";
				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
				PreparedStatement ps = con.prepareStatement(insert);

				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
				int ThreadID = ThreadForum.generateThreadID();
				ps.setInt(1, ThreadID);
				ps.setString(2, ThreadTitle);
				ps.setString(3,username);
				ps.setBoolean(4, true);
				
				//Run the query against the DB
				ps.executeUpdate();
				%>
				
				<br>
				
				<form method = "get" action="InfoPage.jsp">
					<input type="button" value="Back" onclick=location.href="ForumPage.jsp?username=<%=username%>&pass=<%=pass%>">
				</form>
				
				<%
			}else{
				%>Creation Failed
				<form method = "get" action="InfoPage.jsp">
					<input type="button" value="Back" onclick=location.href="Forum.jsp?username=<%=username%>&pass=<%=pass%>">
				</form>
		
			<%
			}
	} catch (Exception ex) {
		out.print(ex);
		out.print("Login failed :()");
	}
				
		
	
%>
</body>
</html>