<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

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
		.action-row-container{
			display: flex;
			flex-direction: row;
			position: center;
			transform: translateX(25%);
		}
		.action-container {
			background: #c9c9c9;
			height: 100px;
			width: 150px;
			margin: 6px;
			border-radius: 40px;
			padding: 16px;
		}

		.heading-text {
			text-align: center;
		}
		
		.button {
				 position: relative;
   				 top: 20%;
    			 transform: translateY(-50%);
		}		
						
	</style> 
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	</head>
	
	<title>Forum</title>
	
	<body class="body">
		<%
			String username = request.getParameter("username");
			String pass = request.getParameter("pass");
		
			session.setAttribute("username", username);
			session.setAttribute("pass", pass);
		%>
		
		<div class="welcome_header">
			<div class ="header">
				<h2>
				Welcome to the Forum!
				</h2>
			</div>
		</div>
		
		<div class="action-row-container">
					
			<div class="action-container" style="cursor: pointer;" onclick=location.href="Forum.jsp?username=<%=username%>&pass=<%=pass%>">
					<div>
						<h3 class="heading-text">Browse Forums</h3>
					</div>
			</div>
			
			<div class="action-container" style="cursor: pointer;" onclick=location.href="AddThread.jsp?username=<%=username%>&pass=<%=pass%>">
					<div>
						<h3 class="heading-text">Create a Forum</h3>
					</div>
			</div>
			
			<div class="action-container" style="cursor: pointer;" onclick=location.href="SearchPage.jsp?username=<%=username%>&pass=<%=pass%>">
					<div >
						<h3 class="heading-text">Search Forum</h3>
					</div>
			</div>			
		</div>
		<br>
			<div class="button" style="cursor: pointer;" onclick=location.href="Dashboard.jsp?username=<%=username%>&pass=<%=pass%>">
					<div >
						<h3 class="heading-text">Return</h3>
					</div>
			</div>	
			<div class="button" style="cursor: pointer;" onclick=location.href="InfoPage.jsp">
					<div >
						<h3 class="heading-text">Log Out</h3>
					</div>
			</div>
		
	</body>
</html>