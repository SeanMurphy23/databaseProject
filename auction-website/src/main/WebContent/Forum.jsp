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
		<title>Forum</title>
       </head>
       <body class="body">
       <br>
       Here are all the forums!
       <br>
       <br>
       <% 
   				String username = request.getParameter("username");
				String pass = request.getParameter("pass");
			
				session.setAttribute("username", username);
				session.setAttribute("pass", pass);
				
            try 
            {
                    ApplicationDB db = new ApplicationDB();	
		    		Connection con = db.getConnection();
		   			Statement stmt = con.createStatement();
		   			        
                    String threads = "SELECT * FROM threads";
                    
                    ResultSet result = stmt.executeQuery(threads);
                    
                    while(result.next()) { %>
                    		<a href="Thread.jsp?threadID=<%=result.getInt("threadID")%>&username=<%=username%>&pass=<%=pass%>"><%=
                    		result.getString("threadTitle")%></a><br>
                    <% }
            } catch(Exception e) {
                    out.print(e);
            }    
       %>
       
        <br>
        <br>
	
		<form method = "get" action="InfoPage.jsp">
					<input type="button" value="Back" onclick=location.href=onclick=location.href="ForumPage.jsp?username=<%=username%>&pass=<%=pass%>">
				
		</form>
		<br>
		
		<input type="button" value="Log Out" onclick=location.href="InfoPage.jsp">
	
		<br>
       </body>
</html>