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
		<title>Edit Account</title>
       </head>
       <body class="body">
       <%
            String accountID=request.getParameter("accountID");
       		String newusername=request.getParameter("newusername");
       		String newpass=request.getParameter("newpass");
       		String username=request.getParameter("username");
       		String pass=request.getParameter("pass");
       		String type=request.getParameter("type");
            
            try 
            {
                    ApplicationDB db = new ApplicationDB();	
		    		Connection con = db.getConnection();
		   			Statement stmt = con.createStatement();
		   			
		   			if(accountID.equals("0")) {
		   				response.sendRedirect("CustomerRep.jsp?");
		   			}
                    
                    String update = "UPDATE account SET "; 
                    String update1 = "UPDATE account SET ";
                    String update2 = "UPDATE account SET ";
                    String end = " WHERE accountID="+accountID;
                    
                    if(newusername != null) {
                    	String set="username="+"'"+newusername+"'";
                    	update+=set;
                    	update+=end;
                    	int i = stmt.executeUpdate(update);
                    	if(i == 1) {
                    		out.println("Username Update!");
                    		%> <br> <%
                    	}
                    }
                    
                    if(newpass != null) {
                    	String set1="pass="+"'"+newpass+"'";
                    	update1+=set1;
                    	update1+=end;
                    	int i = stmt.executeUpdate(update1);
                    	if(i == 1) {
                    		out.println("Password Update!");
                    		%> <br> <%
                    	}
                    }
                    
                    if(type != null) {
                    	String set2="type="+"'"+type+"'";
                    	update2+=set2;
                    	update2+=end;
                    	int i = stmt.executeUpdate(update2);
                    	if(i == 1) {
                    		out.println("Type Update!");
                    		%> <br> <%
                    	}
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