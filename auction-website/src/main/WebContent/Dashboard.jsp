<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.dbproj.pkg.*,com.AuctionSite.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>






<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css">
	.body {
		background-color: #ffe5e5;
	}
	.welcome-header : {
		display: flex;
		flex-direction: row;
	}
	.header {
		text-align: center;
	}
	.option {
		text-align: center;
		
		}
	.dashboard-container {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		
	}
	
	.action-row-container{
		display: flex;
		flex-direction: row;
	}
	
	
	.action-container {
		background: #c9c9c9;
		height: 180px;
		width: 200px;
		margin: 8px;
		border-radius: 24px;
		padding: 16px;
	}
	
	.heading-text {
		text-align: center;
		margin-top: -1px;
		margin-bottom: -20px;
	}
		
	.img-container {
		margin-left: auto;
		margin-right: auto;
	}
					
	.img {
		height: 200px;
		width: 200px;
	}
	
	.shrink-img {
		margin-top: 40px;
		height: 120px;
		width: 120px;
		margin-left: 40px;
	}
	
	.customer-service-container {
		height: 250px;
		width: 450px;
		background: #c9c9c9;
		border-radius: 24px;
	}
	.log-out-button-container{
		margin-top: 50px;
	}
</style> 
	
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Dashboard</title>
</head>
<body class="body">
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
		
		session.setAttribute("userName", username);
		session.setAttribute("pass", pass);
		//craft query
		String select = "SELECT count(*) FROM account WHERE username=\"" + username + "\" and pass=\"" + pass + "\";";
	
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(select);
	%>
	<h3>
	<%
		result.next();
		if(result.getString("count(*)").equals("1")){
	%>
	<%
			String newQuery = "SELECT * FROM account WHERE username=\"" + username + "\";";
			//result.next();
			result = stmt.executeQuery(newQuery);
			result.next();
			
			String accountType = result.getString("type");
			
			if(accountType.equals("admin")) {
				response.sendRedirect("AdminPage.jsp?username="+username +"&pass="+pass);
			}
			
			if(accountType.equals("customerRep")) {
				response.sendRedirect("CustomerRep.jsp?username="+username +"&pass="+pass);
			}
	%> 
				
			<div class="welcome-header">
				<div class="header">
					<h2>
						Hello <%=username %>!
					</h2>
				</div>
			</div>
					

			<div class="welcome-header">
				<div class="option">
					<h2>
						Select An Option
					</h2>
				</div>
			</div>
				
							
			<div class="dashboard-container">
			
			<% ItemList itemList = new ItemList();
				session.setAttribute("itemList", itemList);
				int accountID = result.getInt("accountID");
				session.setAttribute("accountID", accountID);%>

			<div class="action-row-container">
				
				<div class="action-container" method = "get" action="InfoPage.jsp" style="cursor: pointer;" onclick=location.href="CreateAuctionPage.jsp">
					<div >
						<h3 class="heading-text"> Add Item </h3>
					</div>
					<div class="img-container"> 
						<img class="img" src="https://i.imgur.com/wK8PLiM.png" />
					</div>
				</div>
				
			
				<div class="action-container" method = "get" action="InfoPage.jsp" style="cursor: pointer;" onclick=location.href="AlertPage.jsp">
					
					<div>
						<h3 class="heading-text"> View Alerts </h3>
					</div>
					<div class="img-container"> 
						<img class="img" src="https://i.imgur.com/872aemL.png" />
					</div>
					
				</div>
			
			</div>
								
			<div class="action-row-container">
				<div class="action-container" method = "get" action="InfoPage.jsp" style="cursor: pointer;" onclick=location.href="BrowseItems.jsp">
					<div>
						<h3 class="heading-text"> View Items </h3>
					</div>
					<div class="img-container"> 
						<img class="img" src="https://i.imgur.com/ybxg3v2.png" />
					</div>
				</div>
				
				<div class="action-container" method = "get" action="InfoPage.jsp" style="cursor: pointer;" onclick=location.href="BrowseAuctions.jsp">
					<div>
						<h3 class="heading-text"> View Auctions </h3>
					</div>
					<div class="img-container"> 
						<img class="shrink-img" src="https://i.imgur.com/mww1BlG.png" />
					</div>
				</div>
			</div>
			
			<div class="welcome-header">
				<div class="option">
					<h2>
						Need To Contact Customer Service?
					</h2>
				</div>
			</div>
			
			
					<div class="action-container">
						<div class="option" method ="get" action="InfoPage.jsp" style="cursor: pointer;" onclick=location.href="ForumPage.jsp?username=<%=username%>&pass=<%=pass%>">
							<h3 class="heading-text"> Contact Customer Service </h3>
						</div>
						<div class="img-container"> 
							<img class="shrink-img" src="https://i.imgur.com/4epk93E.png" />
						</div>
					</div>

				<div class="log-out-button-container">
					<a href="InfoPage.jsp"> <button>Log Out</button></a> 
				</div>
											
			</div>

					
		<%		
		} else{
		%>Invalid Login
			<br>
			<form method = "get" action="InfoPage.jsp">
				<input type="button" value="Back" onclick=location.href="InfoPage.jsp">
			</form>	
		<%		
		}
		%>
	</h3>
		
	<% } catch (Exception ex) {
			ex.printStackTrace();
			out.print("Login failed :()");
	}
	%>
</body>
</html>
