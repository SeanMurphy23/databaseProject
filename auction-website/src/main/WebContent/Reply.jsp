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
		<title>Reply</title>
       </head>
       <body class="body">
       <br>
       Replying to Thread
       <br>
       <br>
       <% 
   				String username = request.getParameter("username");
				String pass = request.getParameter("pass");
				String threadID = request.getParameter("ThreadID");
				String Message = request.getParameter("Message");
				session.setAttribute("username", username);
				session.setAttribute("pass", pass);
				session.setAttribute("ThreadID", threadID);
				session.setAttribute("Message", Message);
		%>
		<%
				
            try 
            {
            		ApplicationDB db = new ApplicationDB();	
	    			Connection con = db.getConnection();
	   	    				
    				String insert = "INSERT INTO posts(postID,threadID, Message,PostMadeBy)"
    						+ "VALUES (?,?,?, ?)";
    				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
    				PreparedStatement ps = con.prepareStatement(insert);

    				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
    				int PostID = Post.generatePostID();
    				ps.setInt(1,PostID);
   					ps.setString(2,threadID);
    				ps.setString(3,Message);
    				ps.setString(4,username);
    
    				//Run the query against the DB
    				if(ps.executeUpdate() > 0) {
    					%> Reply Submitted! <% 
    				}
    				else {
    					%> Reply Failed! <% 
    					}
    				%>	
    			<%
            } catch(Exception e) {
                    out.print(e);
            }    
       %>
       
        <br>
        <br>
	
		<form method = "get" action="InfoPage.jsp">
					<input type="button" value="Back" onclick=location.href=onclick=location.href="Thread.jsp?threadID=<%=threadID%>&username=<%=username%>&pass=<%=pass%>">
				
		</form>
		<br>
		
		<form method = "get" action="InfoPage.jsp">
					<input type="button" value="Return to Forum Page" onclick=location.href=onclick=location.href="ForumPage.jsp?username=<%=username%>&pass=<%=pass%>">
				
		</form>
		<br>
		
		<input type="button" value="Log Out" onclick=location.href="InfoPage.jsp">
	
		<br>
       </body>
</html>