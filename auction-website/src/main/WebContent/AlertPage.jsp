<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.dbproj.pkg.*,com.AuctionSite.*"%>
    
<%@ page language="java" import="com.dbproj.pkg.*"%>
    
<%@ page import="java.io.*,java.util.*,java.sql.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
			<title>View Items Page</title>
			<style>
				ol {
				  background: #9b9b9b;
				  padding: 20px;
				}
				
				ol li {
					list-style-type: none;
				}
			</style>
			
			<style type="text/css">	 
				.container { 
					width:100% ; 
					margin-bottom: 200px;
					background-color: lightblue;
				}
					
				.align-left { 	
					float: left ; 
					width:50% ; 
				}
					
				.align-right { 
					float: right ;
					width:50% ; 
				 }
				
				.item-container {
					display: flex;
					flex-direction: row;
					align-items: center;
					background: #ffe5e5;
				  	margin-left: 20px;
				  	margin-bottom: 20px;
				  	padding: 8;
				  	height: 100px;
				}
				
				.sub-container {
					display: flex;
					flex-direction: column;
					padding-left: 20px;
				}
				.outer-container {
					flex: 1;
				}
				
				.sub-container-date-time {
					flex: 1;
					
				}
				
				.sub-container-message {
					flex: 2;
					margin-right: 12px;
					margin-left: 12px;
				}
				
				.description-container {
					marginTop: 8px;
					marginBottom: 8px;
					
				}
				
				.fit-picture {
				    width: 100px;
				}
				
				.right-align-sub-container{
					margin-left: auto;
					margin-right: 20px;
				}
				
				.header {
					font-size: 14px;
					font-weight: bold;
				}
				
				.description {
					font-size: 14px;
					font-weight: normal;
				}
				
				.shrink-img {
					height: 90px;
					width: 90px;
				}
				
			</style> 

		</head>

	<body BGCOLOR="#e6e6e6">
		<% 	String userName = (String) session.getAttribute("userName");
			String pass = (String) session.getAttribute("pass");
		%>
	<a href="Dashboard.jsp?username=<%=userName%>&pass=<%=pass%>"> <button>Back To Dash Board</button></a> 
	
		<CENTER>     
			<H2>Your Alerts</H2>
			<div> 
				<img class="shrink-img" src="https://i.imgur.com/872aemL.png" />
			</div>
			<div class='container'>
				<form  method="get">
					<div class='align-left'>	
						<H3>Sort By Viewed </H3>    
							<select name="availability" >  
								<option value="null"> All </option>          
							</select>    
					</div>
						
					<div class='align-right'>	
						<H3>Sort By Criteria</H3>    
							<select name="sortBy" >  
    							<option value="newest"> Newest Alert </option>        
								<option value="oldest"> Oldest Alert </option> 
							</select>    
						<input type="submit" value="Submit"/> 
					</div>

				</form> 
			</div>



		</CENTER>
	  
	<% 
		try {
 
		    ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
 
			int id = (Integer) session.getAttribute("accountID");	
 	
			
			if (  request.getParameter("availability") != null ){

				String query = " select * from alert where accountID =" + String.valueOf(id);
				
				String availabilityType = request.getParameter("availability");
				
				String sortBy = request.getParameter("sortBy");
				
				if ( sortBy.equals("oldest") ) {
					query += " ORDER BY date ASC, time ASC";
				} else if ( sortBy.equals("newest") ){
					query += " ORDER BY date DESC, time DESC";
				}
				
				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
				Statement stmt = con.createStatement();
				ResultSet rs = stmt.executeQuery(query);
				
		%>
			<ol>
				<%
				while (rs.next()) {
					String alertID = String.valueOf(rs.getInt("alertID"));
					String itemID = String.valueOf(rs.getInt("itemID"));
					String message = rs.getString("message");
					String date = rs.getString("date");
					String time = rs.getString("time");
					%>
						<li  > 
								<div class='item-container' >	
									<div class="outer-container"> 
										<div class='sub-container'>
											<div class='description-container'>
												<div class="header"> Alert ID: <a class="description"> <%= alertID %></a></div>
											</div>
											<div>
												<div class="header"> Item ID: <a class="description"> <%= itemID %></a></div>
											</div>
										</div>			
									 </div>
									
									
									<div class="outer-container">
										<div class='sub-container-date-time'>
											<div class='description-container'>
												<div class="header"> Date: <a class="description"> <%= date %></a></div>
											</div>
											<div>
												<div class="header"> Time: <a class="description"> <%= time %></a></div>
											</div>
										</div>		
									</div>
									<div class='sub-container-message'>
										<div class='description-container'>
											<div class="header"> Message: <a class="description"> <%= message %></a></div>
										</div>
									</div>		
											
									<div class='right-align-sub-container'> 
										<a href="Auction.jsp?itemID=<%=itemID%>"> <button>View Item</button></a> 
									</div>
									
								</div>
								</div>
						</li>
					<% 
				}
				%>
			</ol> 
			<% 
			
			}
			
		} catch (Exception ex) {
				System.err.println(ex);
				out.print("Unable To Get Data");
		}
	%>
	
	</body>
</html>


