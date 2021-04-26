<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.dbproj.pkg.*,com.AuctionSite.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>


<body>
	<%
			String username = request.getParameter("username");
			String pass = request.getParameter("pass");
			String newusername = request.getParameter("newusername");
			String newpass = request.getParameter("newpass");
		
			session.setAttribute("username", username);
			session.setAttribute("pass", pass);
			session.setAttribute("newusername", newusername);
			session.setAttribute("newpass", newpass);
	%>
	<%
	try {
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the InfoPage.jsp	
		//craft query
		String select = "SELECT count(*) FROM account WHERE username=\"" + newusername + "\" or pass=\"" + newpass + "\";";

		//Run the query against the database.
		ResultSet result = stmt.executeQuery(select);
%>
		
		<%
			result.next();
			if(result.getString("count(*)").equals("1")){
				%>Username or password already taken
				<br>
				<br>
	
				<input type="button" value="Back" onclick=location.href="AdminPage.jsp?username=<%=username%>&pass=<%=pass%>">
				
				
				<%
			}else if(username.length() < 30 && pass.length() < 30){
				
				%>Created new customer account<%
				
				String insert = "INSERT INTO account(accountID, username, pass, type, logged_in)"
						+ "VALUES (?, ?, ?, ?, ?)";
				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
				PreparedStatement ps = con.prepareStatement(insert);

				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
				int customerID = Customer.generateCustomerID();
				ps.setInt(1, customerID);
				ps.setString(2, newusername);
				ps.setString(3, newpass);
				ps.setString(4, "customerRep");
				ps.setBoolean(5, false);
				//Run the query against the DB
				ps.executeUpdate();
				%>
				
				<br>
				<br>
				
				<input type="button" value="Back" onclick=location.href="AdminPage.jsp?username=<%=username%>&pass=<%=pass%>">
				
				<%
			}else{
				%>Registration Failed
				<input type="button" value="Back" onclick=location.href="AdminPage.jsp?username=<%=username%>&pass=<%=pass%>">
			<%
			}
	} catch (Exception ex) {
		out.print(ex);
		out.print("Login failed :()");
	}
				
		
	
%>
</body>



</html>