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
		<title>Remove Account</title>
       </head>
       <body class="body">
       <%
			String username = request.getParameter("username");
			String pass = request.getParameter("pass");
		
			session.setAttribute("username", username);
			session.setAttribute("pass", pass);
		%>
       <%
            String accountID=request.getParameter("accountID");
            
            try 
            {
                    ApplicationDB db = new ApplicationDB();	
		    		Connection con = db.getConnection();
		   			Statement stmt = con.createStatement();
		   			
		   			if(accountID.equals("0")) {
		   				response.sendRedirect("CustomerRep.jsp?");
		   			}
                    
                    String remove = "DELETE FROM account WHERE accountID="+accountID;
                    
                    int result = stmt.executeUpdate(remove);
                    
                    if(result==1) {
                           out.println("Account Deleted Successfully!");
                     } else {
		     	   			out.println("Account Failed to Delete!");
		     			}
            } catch(Exception e) {
                    out.print(e);
            }    
       %>
       
        <br>
        <br>
	
		<input type="button" value="Back" onclick=location.href="CustomerRep.jsp?username=<%=username%>&pass=<%=pass%>">
	
		<br>
       </body>
</html>