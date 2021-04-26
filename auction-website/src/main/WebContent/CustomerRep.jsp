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
		<style type="text/css">
		.body {
			background-color: #ffe5e5;
		}
		</style>
	</head>
	<body class ="body">
		<% 
   				String username = request.getParameter("username");
				String pass = request.getParameter("pass");
			
				session.setAttribute("username", username);
				session.setAttribute("pass", pass);
		%>
	<br>
	REMOVE AUCTION:
	<br>
		<form method="get" action="RemoveAuction.jsp">
					<label for="AuctionID">Auction ID:</label><br>
					<input type="text" id="AuctionID" name="AuctionID">
					<input type="hidden" id="username" value=<%=username%> name="username">
        			<input type="hidden" id="pass" value=<%=pass%> name="pass">
					<input type="submit" value="Remove Auction">
		</form>
	<br>
	REMOVE BID:
	<br>
		<form method="get" action="RemoveBid.jsp">
				<label for="BidID">Bid ID:</label><br>   
				<input type="text" id=BidID name="BidID">
				<input type="hidden" id="username" value=<%=username%> name="username">
        		<input type="hidden" id="pass" value=<%=pass%> name="pass">
				<input type="submit" value="Remove Bid">
		</form>
	<br>
	REMOVE ACCOUNT:
	<br>
		<form method="get" action="RemoveAccount.jsp">
				<label for="accountID">Account ID:</label><br>   
				<input type="text" id ="accountID" name="accountID">
				<input type="hidden" id="username" value=<%=username%> name="username">
        		<input type="hidden" id="pass" value=<%=pass%> name="pass">
				<input type="submit" value="Remove Account">
		</form>
	<br>
	EDIT ACCOUNT:
	<br>
		<form method="get" action="EditAccount.jsp">    
			<label for="accountID">Account ID:</label><br>   
			<input type="text" id ="accountID" name="accountID"><br>
			<label for="newusername">New Username:</label><br> <input type="text" id ="newusername" name="newusername"><br>
			<label for="newpass">New Password:</label><br> <input type="text" id = "newpass" name="newpass"><br>
			<label for="type">Change Type:</label><br><input type="text" id="type" name="type"><br>
			<input type="hidden" id="username" value=<%=username%> name="username">
        	<input type="hidden" id="pass" value=<%=pass%> name="pass">
			<br>
			<input type="submit" value="Edit Account">
		</form>
	<br>
	
	ACCESS FORUM:
	
	<br>
	
	<form method="get" action="InfoPage" onclick=location.href="ForumPage.jsp?username=<%=username%>&pass=<%=pass%>">
		<input type="button" value="Forum" onclick=location.href="ForumPage.jsp?username=<%=username%>&pass=<%=pass%>">
	</form>
	<br>
	<input type="button" value="Log Out" onclick=location.href="InfoPage.jsp">
	
	</body>

</html>