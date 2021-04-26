<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.dbproj.pkg.*,com.AuctionSite.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>


<body>
	<%
	try {
		
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the InfoPage.jsp
		String username = request.getParameter("username");
		String pass = request.getParameter("pass");
		
		//craft query
		String select = "SELECT count(*) FROM account WHERE username=\"" + username + "\" or pass=\"" + pass + "\";";

		//Run the query against the database.
		ResultSet result = stmt.executeQuery(select);
		
%>
		
		<h3><%
			result.next();
			if(result.getString("count(*)").equals("1")){
				%>Username or password already taken
				<br>
				
				<form method = "get" action="InfoPage.jsp">
					<input type="button" value="Back" onclick=location.href="InfoPage.jsp">
				
				</form>
				
				
				<%
			}else if(username.length() < 30 && pass.length() < 30){
				
				%>Created new customer account<%
				
				String insert = "INSERT INTO account(accountID, username, pass, type)"
						+ "VALUES (?, ?, ?, ?)";
				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
				PreparedStatement ps = con.prepareStatement(insert);

				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
				int customerID = Customer.generateCustomerID();
				ps.setInt(1, customerID);
				ps.setString(2, username);
				ps.setString(3, pass);
				ps.setString(4, "customer");
				//Run the query against the DB
				ps.executeUpdate();
				%>
				
				<br>
				
				<form method = "get" action="InfoPage.jsp">
					<input type="button" value="Back" onclick=location.href="InfoPage.jsp">
				
				</form>
				
				<%
			}else{
				%>Registration Failed
				<form method = "get" action="InfoPage.jsp">
					<input type="button" value="Back" onclick=location.href="InfoPage.jsp">
				
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