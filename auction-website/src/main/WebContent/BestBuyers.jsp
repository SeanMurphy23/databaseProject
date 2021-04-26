<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.AuctionSite.*"%>
<%@ page import="java.util.stream.Collectors" %>
<%@ page language="java" import="com.dbproj.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*,javax.servlet.ServletException.*,javax.servlet.annotation.WebServlet.*,javax.servlet.http.HttpServlet.*,javax.servlet.http.HttpServletRequest.*,javax.servlet.http.HttpServletResponse.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
     	<style type="text/css">
		.body {
			background-color: #ffe5e5;
		}
		</style>
    	</head>
	<body class="body">
		<br>
		Best-Buyers
		<br>
		<br>
			<%
			String username = request.getParameter("username");
			String pass = request.getParameter("pass");
		
			session.setAttribute("username", username);
			session.setAttribute("pass", pass);
			%>
      		<%
        	try {
          
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
		
			String BestSelling = "SELECT a.buyerInLeaderID, SUM(a.currentBidPrice) AS total FROM items i inner join auction a WHERE i.item_ID = a.itemID and a.isOpen = false GROUP BY a.buyerInLeaderID ORDER BY total DESC LIMIT 5";
	
			ResultSet result = stmt.executeQuery(BestSelling);
			
			out.println("Buyer ID" + "&emsp;" + "&emsp;"+"&emsp;"+"&emsp;" +"Spent");	
			
			%> <br> <%
					
			while(result.next()) {
				int sum = result.getInt("total");
				if(sum < 0) {
					continue;
				}
				String itemID = result.getString("buyerInLeaderID");
				if(itemID == null) {
					itemID="No sales";
				}
				
				out.println(itemID + "&emsp;"+"&emsp;"+"&emsp;" + "&emsp;" + "&emsp;" + "&emsp;"+"&emsp;" + "&emsp;"+sum);
				%> <br> <%
			} 
		    }catch(Exception ex) 
		    {
			out.print(ex);
		    }
			
		%>
		<br>
			
		<input type="button" value="Return" onclick=location.href="AdminPage.jsp?username=<%=username%>&pass=<%=pass%>">	
							
	</body>
</html>    