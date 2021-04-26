<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.dbproj.pkg.*,com.AuctionSite.*"%>
    
 <%@ page import="java.io.*,java.util.*,java.sql.*,javax.servlet.ServletException.*,javax.servlet.annotation.WebServlet.*,javax.servlet.http.HttpServlet.*,javax.servlet.http.HttpServletRequest.*,javax.servlet.http.HttpServletResponse.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
			<title>View Auctions Page</title>
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
					display: flex;
					flex-direction: row;
					align-items: center;
					justify-content: center;
				}
				
				.filter-items {
					flex: 1;
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
					display: 'flex';
					flex-direction: 'column';
					padding-left: 20px;
				}
					
				.description-container {
					marginTop: 8px;
					marginBottom: 8px;	
				}
					
				.outer-sub-container {
					flex: 1;
					float: left;
				}
				
				.view-button {
					margin-left: 10px;
				}
				
				.fit-picture {
				    width: 100px;
				}
				
				.right-align-sub-container{
					margin-left: auto;
					margin-right: 20px;
				}
				
				.button {
					margin-top: 10px;	
				}
				
				.header {
					font-size: 16px;
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
		
	<%
		String userName = (String) session.getAttribute("userName");
		String pass = (String) session.getAttribute("pass");
	
	%>
		<a href="Dashboard.jsp?username=<%=userName%>&pass=<%=pass%>"> <button>Back To Dash Board</button></a> 
			<CENTER>     
				<H2>Browse Auctions</H2>
				<div class="img-container"> 
					<img class="shrink-img" src="https://i.imgur.com/mww1BlG.png" />
				</div>	
					<form  method="get">
						<div class='container'>
							<div class='filter-items'>	
								<H3>Sort Availability </H3>    
									<select name="availability" >  
										<option value="null"> All </option>       
										<option value="open"> Open </option>     
										<option value="closed"> Closed </option>         
									</select>    
							</div>
		
							<div class='filter-items'>	
								<H3>Sort Criteria (Buyer/Seller) </H3>    
									<select name="customerType" >  
										<option value="null"> All </option>       
										<option value="seller"> As Seller </option>     
										<option value="bidder"> As Bidder </option>         
									</select>    
							</div>
							
							<div class='filter-items'>	
								<H3>Order By Criteria</H3>    
									<select name="orderBy" >  
										<option value="null"> Any </option>         
										<option value="lowest"> Lowest Bid Price </option> 
										<option value="highest"> Highest Bid Price </option>     
										<option value="date"> Close Date </option>     
									</select>    
							</div>
						</div>
						<div class="button">
							<input type="submit" value="Submit"/> 
						</div>
					</form> 
			</CENTER>
	<% 
		try {
			
		    ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			int accountID = (Integer) session.getAttribute("accountID");
			// Get All Items From Database
			if ( request.getParameter("availability") != null ){
				String query = "";
				String availability = request.getParameter("availability");
												
				if ( availability.equals("All") ) {					// Get requested item
					// Do Nothing? 
				} else if ( availability.equals("null") ){
					query =  "SELECT a.auctionID, a.itemID, a.sellerID, a.initialPrice, a.currentBidPrice, a.isOpen, a.time, a.date, i.img, i.item_type FROM auction a INNER JOIN items i on i.item_id = a.itemID";
				} else if ( availability.equals("open") ) {
					query = " SELECT a.auctionID, a.itemID, a.sellerID, a.initialPrice, a.currentBidPrice, a.isOpen, a.time, a.date, i.img, i.item_type FROM auction a INNER JOIN items i on i.item_id = a.itemID where isOpen = true";
				} else if ( availability.equals("closed") ){
					query = " SELECT a.auctionID, a.itemID, a.sellerID, a.initialPrice, a.currentBidPrice, a.isOpen, a.time, a.date, i.img, i.item_type FROM auction a INNER JOIN items i on i.item_id = a.itemID where isOpen = false";
				} 
					
				
				String customerType = request.getParameter("customerType");
				
				if ( customerType.equals("bidder") ){
					 if ( availability.equals("null") ){
						query = "SELECT DISTINCT b.itemID, b.buyerID, a.auctionID, a.itemID, a.sellerID, a.initialPrice, a.currentBidPrice, a.isOpen, a.time, a.date, i.img, i.item_type FROM bid b INNER JOIN auction a ON b.itemID = a.itemID INNER JOIN items i ON b.itemID = i.item_ID where buyerID="+ String.valueOf(accountID);
					} else if ( availability.equals("open") ) {
						query = "SELECT DISTINCT b.itemID, a.auctionID, a.itemID, a.sellerID, a.initialPrice, a.currentBidPrice, a.isOpen, a.time, a.date, i.img, i.item_type FROM bid b INNER JOIN auction a ON b.itemID = a.itemID INNER JOIN items i ON b.itemID = i.item_ID where a.isOpen = true and buyerID="+ String.valueOf(accountID);
					} else if ( availability.equals("closed") ){
						query = "SELECT DISTINCT b.itemID, a.auctionID, a.itemID, a.sellerID, a.initialPrice, a.currentBidPrice, a.isOpen, a.time, a.date, i.img, i.item_type FROM bid b INNER JOIN auction a ON b.itemID = a.itemID INNER JOIN items i ON b.itemID = i.item_ID where a.isOpen = false and buyerID="+ String.valueOf(accountID);
					} 
				} else if (customerType.equals("seller")) {
					if ( availability.equals("null") ){
						query += " where sellerID =" + String.valueOf(accountID);
					} else {
						query += " and sellerID =" + String.valueOf(accountID);
					}
				} else {
					// Do Nothing
				}
				
				String orderBy = request.getParameter("orderBy");
				if ( orderBy.equals("lowest") ) {					// Get requested item
					query += " ORDER BY currentBidPrice ASC" ;
				} else if ( orderBy.equals("highest") ){
					query +=  " ORDER BY currentBidPrice DESC";
				} else if ( orderBy.equals("date") ){
					query +=  " ORDER BY date ASC";
				}
				
				
				
				
				Statement stmt = con.createStatement();
				ResultSet rs = stmt.executeQuery(query);
		%>
			<ol>
		<%
				while (rs.next()) {
					String auctionID = String.valueOf(rs.getInt("auctionID"));
					String itemID = String.valueOf(rs.getInt("itemID"));
					String sellerID = String.valueOf(rs.getInt("sellerID"));
					String initialPrice = String.valueOf(rs.getFloat("initialPrice"));
					String currentBidPrice = String.valueOf(rs.getFloat("currentBidPrice"));
					boolean inAuction = rs.getBoolean("isOpen");
					String date = rs.getString("time");
					String time = rs.getString("date");
					String item_type = rs.getString("item_type");
					String img = rs.getString("img");
					if ( img.equals("null") ){
						if (item_type.equals("car")){
							img = "https://i.imgur.com/DOVgfjE.png";
						}	else if (item_type.equals("bike")){
							img = "https://i.imgur.com/f0gjT3e.gif";
						}	else if (item_type.equals("truck")){
							img = "https://i.imgur.com/PPtmo88.jpg";
						}
					} 
					
		%>
						<li> 
							<div class='item-container' >
								<div class="outer-sub-container">
	     							<div class='sub-container'>
											<img class="fit-picture"
											     src=<%= img %>
											     alt="">
									</div>		
								</div>
								
								<div class="outer-sub-container">		
									<div class='sub-container'>
										<div class='description-container'>
											<div class="header"> Item ID: <a class="description"> <%= String.valueOf(itemID) %></a></div> 
										</div>
									</div>			
									<div class='sub-container'>
										<div class='description-container'>
											<div class="header"> Seller ID: <a class="description"> <%= sellerID %></a></div>  
										</div>
									</div>
								</div>
								
								<div class="outer-sub-container">
									<div class='sub-container'>
										<div class='description-container'>
											<div class="header"> Initial Price: <a class="description">$<%= initialPrice %></a></div> 
										</div>
										<div class='description-container'>
											<div class="header"> Current Price: <a class="description">$<%= currentBidPrice %></a></div> 
										</div>
									</div>
								</div>
						
								<div class="outer-sub-container">
									<div class='sub-container'>
										<div class='description-container'>
											<div class="header"> In Auction: <a class="description"> <%= inAuction %></a></div>  
										</div>
										<div class='description-container'>
											<div class="header"> Close Date: <a class="description"> <%= time %></a></div> 
										</div>
									</div>										
								</div>
								 
								 <div class="outer-sub-container-button">
									 <a class="view-button" href="Auction.jsp?itemID=<%=itemID%>"> <button> View Auction</button></a> 
								 </div>
							</div>
						</li>
			<% 
			}
			%>
			</ol> 
			<% 
			}
		} catch (Exception e) {
				e.printStackTrace();
		}
	%>
	
	</body>
</html>