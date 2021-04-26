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
		<title>Earnings Per Item</title>
    	</head>
	<body class ="body">
		<br>
		Earnings Per Item
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
		
			String totalEarningsItem = "SELECT i.item_ID, SUM(a.currentBidPrice - a.initialPrice) as 'Total Earnings' FROM items i inner join auction a WHERE i.item_id = a.itemID and a.isOPen = false GROUP BY i.item_id";
	
			ResultSet result = stmt.executeQuery(totalEarningsItem);
			
			out.println("ItemID" + "&emsp;" + "&emsp;"+"&emsp;"+"&emsp;" +"Earnings");	
			
			%> <br> <%
					
			while(result.next()) {
				String sum = result.getString("Total Earnings");
				if(sum == null) {
					sum ="0";
				}
				String itemID = result.getString("item_ID");
				if(itemID == null) {
					itemID="-1";
				}
				out.println(itemID + "&emsp;"+"&emsp;"+"&emsp;" + "&emsp;" + sum);
				%> <br> <%
			}
		}
		catch(Exception ex) {
			out.print(ex);
		}
		
		%>
		<br>
		<br>		
		<input type="button" value="Return" onclick=location.href="AdminPage.jsp?username=<%=username%>&pass=<%=pass%>">							
		<br>
	</body>
</html>    