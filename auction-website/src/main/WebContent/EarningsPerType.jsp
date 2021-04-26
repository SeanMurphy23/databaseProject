<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.AuctionSite.*"%>
<%@ page import="java.util.stream.Collectors" %>
<%@ page language="java" import="com.dbproj.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<style type="text/css">
		.body {
			background-color: #ffe5e5;
		}
		</style>
		<title>Earnings Per Type</title>
       </head>
       <body class="body">
	<br>
	Earnings Per Type
	<br>
	<br>
		 	<%
			String username = request.getParameter("username");
			String pass = request.getParameter("pass");
		
			session.setAttribute("username", username);
			session.setAttribute("pass", pass);
		%>
		
       <%
        	try 
			{
          
				ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();
				Statement stmt = con.createStatement();
		
				//craft query
				String totalEarningsCar = "SELECT SUM(a.currentBidPrice - a.initialPrice) as 'Total Earnings Car' FROM items i inner join auction a WHERE i.item_id = a.itemID and i.item_type = 'car' and a.isOPen = false";
	
				//Run the query against the database.
				ResultSet result = stmt.executeQuery(totalEarningsCar);
					
				if(result.next()) {
					String sum = result.getString("Total Earnings Car");
					if(sum == null) {
						sum="0";
					}
					out.println("Total Earnigs Car:"+"&nbsp" + "&nbsp" + sum);
				} else {
					out.println("No Earnings for Type Car");
				}
						
				%> <br> <br><%
						
				Statement stmt1 = con.createStatement();
		
				//craft query
				String totalEarningsTruck = "SELECT SUM(a.currentBidPrice - a.initialPrice) as 'Total Earnings Trucks' FROM items i inner join auction a WHERE i.item_id = a.itemID and i.item_type = 'truck' and a.isOPen = false";
	
				//Run the query against the database.
				ResultSet result1 = stmt1.executeQuery(totalEarningsTruck);
					
				if(result1.next()) {
					String sum1 = result1.getString("Total Earnings Trucks");
					if(sum1 == null) {
						sum1="0";
					}
					out.println("Total Earnigs Trucks:" +"&nbsp" + "&nbsp" + sum1);
				} else {
					out.println("No Earnings for Trucks");
				}
					
				%> <br> <br><%
						
				Statement stmt2 = con.createStatement();
		
				//craft query
				String totalEarningsBike = "SELECT SUM(a.currentBidPrice - a.initialPrice) as 'Total Earnings Bikes' FROM items i inner join auction a WHERE i.item_id = a.itemID and i.item_type = 'bike' and a.isOPen = false";
	
				//Run the query against the database.
				ResultSet result2 = stmt2.executeQuery(totalEarningsBike);
					
				if(result2.next()) {
					String sum2 = result2.getString("Total Earnings Bikes");
					if(sum2 == null) {
						sum2="0";
					}
					out.println("Total Earnings Bikes: " + sum2);
				} else {
					out.println("No Earnings for Bikes");
				}
						
				%> <br> <br> <%
					
			} catch(Exception ex) {
					out.print(ex);
				}				
		%>
	       <br>
	       <br>
	       <input type="button" value="Return" onclick=location.href="AdminPage.jsp?username=<%=username%>&pass=<%=pass%>">
	       <br>
      
</body>
</html>    