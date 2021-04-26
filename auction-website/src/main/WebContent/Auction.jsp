  
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.AuctionSite.*"%>
    
<%@ page language="java" import="com.dbproj.pkg.*"%>
    
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.SimpleDateFormat.*"%>
<%@ page import="java.util.Date.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
			<title>View Auction Page</title>
			<style>
				ol {
				  background: #9b9b9b;
				  padding: 8px;
				}
				
				ol li {
					list-style-type: none;
				}
			</style>
			
			<style type="text/css">	 
				.item-container {
					display: flex;
					flex-direction: row;
					align-items: center;
					background: #ffe5e5;
				  	margin-left: 20px;
				  	margin-bottom: 20px;
				  	padding: 8;
				  	height: 200px;
				}
				
				.container { 
					width:100% ; 
				}
				
				.sub-container-out {
					flex: 1;
				}
				.sub-container {
					display: 'flex';
					flex-direction: 'column';
					padding-left: 20px;
				}
				.right-align-sub-container {
					margin-left: auto;
					margin-right: 20px;
				}
				
				.fit-picture {
			    	width: 200px;
				}
				
				.bid-container {
					display: flex;
					flex-direction: row;
				}
				.bid-form-container {
					background-color: #d3d3d3;
					align-items: center;
					justify: center;
					padding-left: 4px;
					padding-right: 4px;
					padding-bottom: 4px;
					border-radius: 8px;
				}
				.bid-container-left {
					flex: 1;
					margin-left: 24px;
					height: 500px; 
				}
				
				.bid-container-right {
					flex: 1;
					height: 500px; 
					overflow: hidden; 
					overflow-y:scroll; 
				}
				
				.bid-history-item {
					display: flex;
					flex-direction: row;
					background-color: #ffe5e5;
					padding: 8px;
					margin-bottom: 8px;
				}
				.bid-history-item-container {
					flex: 1;
				}
				
				.bid-history-item-sub-container {
					display: 'flex';
					flex-direction: 'column';
					padding-left: 20px;
				}
				
				.header {
					font-size: 16px;
					font-weight: bold;
				}
				
				.description {
					font-size: 14px;
					font-weight: normal;
				}
				
				.warning {
				color: red !important;
				}
				
			</style> 
		</head>

	<body BGCOLOR="#e6e6e6">
	
	<%
		// Global Variables For The Page
		String userName = (String) session.getAttribute("userName");
		String pass = (String) session.getAttribute("pass");
		int accountID = (Integer) session.getAttribute("accountID");
		int itemID = Integer.parseInt(request.getParameter("itemID"));
		boolean globalInAuction = true;
		boolean notCurrentBidder = false;
		boolean notSeller = true;
		double currentBidPriceGlobal = 0;
		double currentIncrementPriceGlobal = 0;
	%>
		<a href="Dashboard.jsp?username=<%=userName%>&pass=<%=pass%>"> <button>Back To Dash Board</button></a> 
		<CENTER>     
			<H2>Auction For Item # <%=itemID%></H2>			
		</CENTER>
	<% 
		try {
			// Get Item Details From SQL
		    ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
		
			int item_id = itemID;
			
			// Query to get information abbout item and auction
			String query = "select * from items i inner join auction a where i.item_id = a.itemID and a.itemID =" + String.valueOf(item_id);
			
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			
			String item_type = null;
			String model = null;
			String color = null;
			int item_year = 0;
			String location = null;
			String transmission = null;
			String mpg = null;
			String miles = null;
			boolean inAuction = false;
			String img = null;
			
			int auctionID = 0;
			int sellerID = 0;
			int buyerInLeadID = 0;
			double initialPrice = 0;
			double currentBidPrice = 0;
			double reservePrice = 0;
			double incrementVal = 0;
			boolean isOpen = false;
			String closeDate = null;
			
			while (rs.next()){
				 item_type = rs.getString("item_type");
				 model = rs.getString("model"); 
				 color = rs.getString("color");
				 item_year = rs.getInt("item_year");
				 inAuction = rs.getBoolean("isOpen");
				 globalInAuction = inAuction;
				 location = rs.getString("location"); 
				 transmission = rs.getString("transmission");
				 mpg = rs.getString("mpg"); 
				 miles = rs.getString("miles");
				closeDate = rs.getString("date");
				
				img = rs.getString("img");
				if ( img.equals("null") ){
					if (item_type.equals("car")){
						img = "https://i.imgur.com/DOVgfjE.png";
					}	else if (item_type.equals("bike")){
						img = "https://i.imgur.com/f0gjT3e.gif";
					}	else if (item_type.equals("truck")){
						img = "https://i.imgur.com/PPtmo88.jpg";
					}
				} 
					
				
				 auctionID = rs.getInt("auctionID");
				 sellerID = rs.getInt("sellerID");
				 notSeller = accountID == sellerID;
				 buyerInLeadID = rs.getInt("buyerInLeaderID");
				 notCurrentBidder = buyerInLeadID == accountID;
				 initialPrice = rs.getFloat("initialPrice");
				 currentBidPrice = rs.getFloat("currentBidPrice");
				 reservePrice = rs.getFloat("reservePrice");
				 incrementVal = rs.getFloat("incrementVal");
				 isOpen = rs.getBoolean("isOpen");
				 
			}	// Create the Pane On Top Which Displays The Items And It's Details
	%>	
			<div class='item-container'>
				
				<div class="sub-container-out">
					<div class='right-align-sub-container'>
						<img class="fit-picture" src= <%= img %> alt="" >
					</div>	
				</div>
				<div class="sub-container-out">
					<div class='sub-container'>
						<div class='description-container'>
							<div class="header"> Seller ID: <a class="description"> <%= String.valueOf(sellerID) %></a></div>
						</div>	
						<div class='description-container'>
							<div class="header"> Current Bid: <a class="description"> $<%= String.valueOf(currentBidPrice) %></a></div>
						</div>
						<div class='description-container'>
							<div class="header"> Current Bidder: <a class="description"> <%= String.valueOf(buyerInLeadID) %></a></div>
						</div>

					</div>		
				</div>
					
				<div class="sub-container-out">
					<div class='sub-container'>
						<div class='description-container'>
							<div class="header"> Model: <a class="description"> <%= model %></a></div>
						</div>
						<div class='description-container'>
							<div class="header"> Color: <a class="description"> <%= color %></a></div>
						</div>
						<div class='description-container'>
							<div class="header"> Year: <a class="description"> <%=  String.valueOf(item_year) %></a></div>
						</div>
					</div>
				</div>

				<div class="sub-container-out">
					<div class='sub-container'>
						<div class='description-container'>
							<div class="header"> Location: <a class="description"> <%= location %></a></div>
						</div>
						<div class='description-container'>
							<div class="header"> Transmission: <a class="description"> <%= transmission %></a></div>
						</div>
						<div class='description-container'>
							<div class="header"> MPG: <a class="description"> <%= mpg %></a></div>
						</div>
						<div class='description-container'>
							<div class="header"> Miles: <a class="description"> <%= miles %></a></div>
						</div>
					</div>
				</div>

				<div class="sub-container-out">
					<div class='sub-container'>						
						<div class='description-container'>
							<div class="header"> In Auction: <a class="description"> <%= inAuction %></a></div>
						</div>
							
						<div class='description-container'>
							<div class="header"> Close Date: <a class="description"> <%= closeDate %></a></div>
						</div>
					</div>
				</div>
				
			</div>
			
		<div class="bid-container">
			<div class="bid-container-left">
		<%
		if ( !notSeller ){
		
			if ( globalInAuction & !notCurrentBidder) {
				currentIncrementPriceGlobal = incrementVal;
				currentBidPriceGlobal = currentBidPrice;
			%>
				<h2> Create A Bid </h2>
				<div class="bid-form-container">
					<div>
					<h3> Current Price To Beat $<%= String.valueOf(currentBidPrice + incrementVal) %> </h3>
						<form method="get">
							<label for="itemID">Item ID:</label><br>
						  	<input type="text" id="itemID" name="itemID" value=<%= itemID%> ><br>
						  	<label for="bidPrice">Bid Price:</label><br>
						  	<input type="text" id="bidPrice" name="bidPrice" value=""><br>
						  	<input type="checkbox" id="automaticBid" name="automaticBid" value="true"> Automatic Bid </input> <br>
						  	<label for="bidUpperLimit">Bid Upper Limit:</label><br>
						  	<input type="text" id="bidUpperLimit" name="bidUpperLimit" value="0"><br>
						  	<input type="submit" value="Place Bid">
						</form>
					</div>
				</div> 
			<% 
			}
			
		}
		
		%>
		</div>
			
			<div class="bid-container-right">
		       <h2> Bid History List </h2>
		<%
	        try {
	        	// Get Bid History Information
				String bidQuery = String.format("select itemID, buyerID, bidID, bidPrice, date, time FROM bid WHERE itemID = %s ORDER BY bidPrice DESC", String.valueOf(item_id));
				ResultSet qrs = stmt.executeQuery(bidQuery);		
			%>
				<ol>
			<%
					while (qrs.next()){
						String buyerID = String.valueOf(qrs.getInt("buyerID"));
						String bidID = String.valueOf(qrs.getInt("bidID"));
						String bidPrice = String.valueOf(qrs.getInt("bidPrice"));
						String date =  qrs.getString("date") ;
						String time = qrs.getString("time");
			%>
						<li>
							<div class="bid-history-item">
							
								<div class="bid-history-item-container">
									<div class="bid-history-item-sub-container">
										<div>
											<div class="header"> Buyer ID: <a class="description"> <%= buyerID %></a></div>
										</div>
										<div>
											<div class="header"> Bid Price: <a class="description"> $<%= bidPrice %></a></div>
										</div>
									</div>
								</div>
								
								<div class="bid-history-item-container">
									<div class="bid-history-item-sub-container">
										<div>
											<div class="header"> Bid ID: <a class="description"> <%= bidID %></a></div>
										</div>
										<div>
											<div class="header"> Date: <a class="description"> <%= date %></a></div>
										</div>
										<div>
											<div class="header"> Time: <a class="description"> <%= time %></a></div>
										</div>
									</div>
								</div>
							</div>
						</li>
			<% 				
			}
			%>
			</ol>
			<%
		        } catch (Exception e){
		        	System.out.print(e);
		        	e.printStackTrace();
		        }
		    %>
			</div>
		</div>
	
	<% 				
		} catch (Exception e) {
			System.err.println(e);
			e.printStackTrace();
	}
	%>

<br/>
	<%
	// Form For The Bidder To Place Bid 
		try {

			int item_id = itemID;						// Get from Previous Page (Item List)
			int buyerID = accountID;						// Get from the currently Signed In User. Again passing in data
			int bidID = 0;
			// Date/Time
			String date = String.valueOf(java.time.LocalDate.now());
		    java.util.Date day = new java.util.Date();
		    String strDateFormat = "HH:mm:ss a";
		    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(strDateFormat);
			String time = String.valueOf(sdf.format(day));
			try {
				// Get the maxBid to create bidID
		    	ApplicationDB db = new ApplicationDB();	
				Connection con = db.getConnection();
				Statement stmt = con.createStatement();
				String query = "select max(bidID) from bid";
				ResultSet rs = stmt.executeQuery(query);
				
				while (rs.next()) {
					bidID = rs.getInt("max(bidID)") + 1;
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			// If Bid Is Valid
			// Check if bidPrice is greater than current price
			if ( request.getParameter("bidPrice") != null ) {
				double bidPrice = Double.parseDouble(request.getParameter("bidPrice"));
				// If bid price is greater than current ask price
					// Get Data From Form
					
					double upperBidLimit = Double.parseDouble(request.getParameter("bidUpperLimit"));
					String automaticBid = request.getParameter("automaticBid");
					boolean automaticBidBool = false;
					
					
					if ( bidPrice < (currentBidPriceGlobal + currentIncrementPriceGlobal )){
						%>
						<div>
							<h3 class="warning">
							Bid Is Less Than Current Ask Price. Try Again!
							</h3>
						</div>
					<% 
					} else {
						// User has picked to use automaticBid
						if ("true".equals(automaticBid)){
							automaticBidBool = true;
						} 
						
						if (automaticBidBool & upperBidLimit == 0 ) {
							%>
								<div>
									<h3 class="warning">
									Add Upper Limit For Automatic Bid
									</h3>
								</div>
							<% 
						} else {
							// Create New Bid
							Bid bid = new Bid( buyerID, item_id,  bidID,  bidPrice,  upperBidLimit,  date,  time, automaticBidBool); 
						 	
							// Add To Automatic Bidder and SQL
							// Create Automatic Bidding System
							AutomaticBidder automaticBidder = new AutomaticBidder(item_id, bidID);
							// Add the current bid with date and time
							automaticBidder.addBid(bid, item_id, date, time);
							// Find who won this round and contact loser
							automaticBidder.findBidWinner();
						}				
					}		
		%>
		<% 
			}
			
		} catch (Exception e){
			e.printStackTrace();
			System.err.println(e);
	}	
//=======================================================================================================================================================================================================================================
	%>

	<%!
		// Class For The Automatic Bid System
		public class AutomaticBidder {
	    private List<Bid> BidList; 
	    private Bid currBid;
	    private Bid newBid;
	    private int itemID;
	    private int bidID = 0;
	    private double currItemPrice;
	    private int buyerInLeaderID;
	    private double buyerInLeaderIDUpperLimit = 0;
	    private double incrementVal;
	    private int reservePrice; 
	    private int sellerID;
	    private boolean firstBid;
	    
	    public AutomaticBidder(int itemID, int bidID){
	        this.BidList = new ArrayList<Bid>();
	        this.itemID = itemID;
	        this.bidID = bidID;
	        getAuctionDetails();
	    }
	    

	    // Create a unique BIDID for this auction
	    public int createBidID(){ // This Code Is Good
	        this.bidID += 1;
	        return this.bidID;
	    }
	    
	    // Set Active Bid Inactive
	    public void setBidInactive(int bidID){
	    	ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			try {
				Statement stmt = con.createStatement();
				
		         String query = "UPDATE bid SET isActive=0 WHERE bidID=?";
		         PreparedStatement ps = con.prepareStatement(query);
		         ps.setInt(1, bidID);
		         ps.executeUpdate();
		        
		    } catch (Exception e){
		    	System.out.println(e);
		    }
	    }
	    
	    // Get details about auction
	    public void getAuctionDetails(){ // This Code Is Good
	    	
	    	ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			// Get Auction Details
			try {
				Statement stmt = con.createStatement();
				String query = "select * from auction where itemID = " + String.valueOf(this.itemID);
				ResultSet rs = stmt.executeQuery(query);
				
				while (rs.next()){
					this.buyerInLeaderID = rs.getInt("buyerInLeaderID");
					this.incrementVal = rs.getInt("incrementVal");
					this.reservePrice = rs.getInt("reservePrice");
					this.currItemPrice = rs.getInt("currentBidPrice");
				}
				
				// Get Bid Details
				query = "SELECT * FROM bid WHERE itemID = " + String.valueOf(this.itemID) + " AND isActive = 1";
				rs = stmt.executeQuery(query);
				// Add only the active bid to the list
				while (rs.next()){
					int buyerID = rs.getInt("buyerID");
					int itemID = rs.getInt("itemID");
					int bidID = rs.getInt("bidID");
					double bidPrice = rs.getFloat("bidPrice");
					double upperBidLimit = rs.getInt("upperBidLimit");
					String date = rs.getString("date");
					String time = rs.getString("time");
					boolean automaticBid = rs.getBoolean("automaticBid");
					Bid bid = new Bid(buyerID, itemID, bidID, bidPrice, upperBidLimit, date, time, automaticBid);
					this.currBid = bid;
				}

			} catch (Exception e){
				e.printStackTrace();
			}
	    }
	    
	    // Add Bid to list
	    public void addBid(Bid bid, int itemID, String date, String time){	// This Code Is Good

	    		this.newBid = bid;
	 	    	ApplicationDB db = new ApplicationDB();	
	 			Connection con = db.getConnection();
	 			
	 			try {
	 				Statement stmt = con.createStatement();
	 				String insert = "INSERT INTO bid(buyerID, itemID, bidID, bidPrice, upperBidLimit, date, time, automaticBid, isActive)" + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	 				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
	 				PreparedStatement ps = con.prepareStatement(insert);
	 				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
	 				ps.setInt(1, bid.getBuyerID());
	 				ps.setInt(2, itemID);
	 				ps.setInt(3, bid.getBidID());
	 				ps.setDouble(4, bid.getCurrPrice());
	 				ps.setDouble(5, bid.getUpperBidLimit());
	 				ps.setString(6, date);
	 				ps.setString(7, time);
	 				ps.setBoolean(8, bid.getAllowAutomaticBidding());
	 				ps.setBoolean(9, true);
	 				ps.executeUpdate();
	 				
	 			} catch (Exception e){
	 				System.out.print(e);
	 			}
	    }
	    // Add Bid to list to SQL
	    public void addBidToSQL(Bid bid, int itemID, String date, String time){	// This Code Is Good

	 	    	ApplicationDB db = new ApplicationDB();	
	 			Connection con = db.getConnection();
	 			
	 			try {
	 				Statement stmt = con.createStatement();
	 				String insert = "INSERT INTO bid(buyerID, itemID, bidID, bidPrice, upperBidLimit, date, time, automaticBid, isActive)" + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	 				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
	 				PreparedStatement ps = con.prepareStatement(insert);
	 				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
	 				ps.setInt(1, bid.getBuyerID());
	 				ps.setInt(2, itemID);
	 				ps.setInt(3, bid.getBidID());
	 				ps.setDouble(4, bid.getCurrPrice());
	 				ps.setDouble(5, bid.getUpperBidLimit());
	 				ps.setString(6, date);
	 				ps.setString(7, time);
	 				ps.setBoolean(8, bid.getAllowAutomaticBidding());
	 				ps.setBoolean(9, true);
	 				ps.executeUpdate();
		 			
	 			} catch (Exception e){
	 				System.out.print(e);
	 			}
	    }
	    
	    // Update the auction in SQL
	    public void updateAuctionDetailsInSQL(double priceToBeat, int buyerID){
            this.currItemPrice = priceToBeat;
            this.buyerInLeaderID = buyerID;
            
	    	ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			try {
				Statement stmt = con.createStatement();
				
		         String query = "UPDATE auction SET buyerInLeaderID=?, currentBidPrice=? WHERE itemID=" + String.valueOf(this.itemID);
		         PreparedStatement ps = con.prepareStatement(query);
		         ps.setInt(1, buyerID);
		         ps.setDouble(2, priceToBeat);
		         ps.executeUpdate();
		        
		    } catch (Exception e){
		    	System.out.println(e);
		    }
		}
	    
	    
	    // Automatic and Manual Bidding 
	    public void findBidWinner(){
	    	// If this is the first bid, then there won't be a curr bid so set this as winner
			if ( this.currBid == null) {
				updateAuctionDetailsInSQL(this.newBid.getCurrPrice(), this.newBid.getBuyerID());
			} else {
				boolean currBidAutomaticBiddingEnabled = this.currBid.getAllowAutomaticBidding();
				boolean newBidAutomaticBiddingEnabled = this.newBid.getAllowAutomaticBidding();
				
				if (!currBidAutomaticBiddingEnabled & !newBidAutomaticBiddingEnabled ) {				// Both Don't Have Automatic Bidding
					if ( this.newBid.getCurrPrice() > ( this.currItemPrice + this.incrementVal ) ) {	// New Bid Is Greater Than Old Bid
						// New Bid Wins
						String msg = "You have been outbid for item " + String.valueOf(this.itemID);
						setWinState(this.newBid.getCurrPrice(), this.newBid.getBuyerID(), this.currBid.getBidID(), this.currBid.getBuyerID(), msg);
					}
				} else if ( currBidAutomaticBiddingEnabled & !newBidAutomaticBiddingEnabled ) {		// Current Bid has automatic Bid
					if (this.newBid.getCurrPrice() < this.currBid.getCurrPrice()){					
						// Old Bid wins because new bid is not automatic and less than curr bid 
						// However this is a situation that would never happen

						String msg = "You have been outbid for item " + String.valueOf(this.itemID);
						setWinState(this.currBid.getCurrPrice(), this.currBid.getBuyerID(), this.newBid.getBidID(), this.newBid.getBuyerID(), msg);
					} else {
						// New Bid Wins But Old Bid Has Automatic
						System.out.println("New bid wins but old bid has automatic");
						// Check if new bid is greater than curr bid's upper limit
						if ( this.newBid.getCurrPrice() > this.currBid.getUpperBidLimit() ){
							System.out.println("Impossible Situation");
							// If new bid is higher, new bid wins
							String msg = "You have been outbid for item " + String.valueOf(this.itemID);
							setWinState(this.newBid.getCurrPrice(), this.newBid.getBuyerID(), this.currBid.getBidID(), this.currBid.getBuyerID(), msg);
						} else {
							System.out.println("New Bid lost to current bid's automatic system");
							// If automatic is higher, then curr bid stays but price is now new bid's price
							String msg = "You have been outbid for item " + String.valueOf(this.itemID);
							setWinState(this.newBid.getCurrPrice(), this.currBid.getBuyerID(), this.newBid.getBidID(), this.newBid.getBuyerID(), msg);
							// Set Curr Bid Inactive
							setBidInactive(this.currBid.getBidID());
							
							// Generate New Bid 
							String date = String.valueOf(java.time.LocalDate.now());
						    java.util.Date day = new java.util.Date();
						    String strDateFormat = "HH:mm:ss a";
						    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(strDateFormat);
							String time = String.valueOf(sdf.format(day));
											
							// Create New Bid For Current Bid With New Price
	                        Bid newBid = new Bid(this.currBid, createBidID(), this.newBid.getCurrPrice() + this.incrementVal, date, time );
							
	                        // Add Bid To SQL
							addBid(newBid, this.itemID, date, time);
						}
					}
				} else if ( !currBidAutomaticBiddingEnabled & newBidAutomaticBiddingEnabled ) {		// New Bid has automatic
					System.out.println(" New bid automatic scenario");
					if (this.newBid.getCurrPrice() < this.currBid.getCurrPrice()){					// New bid which has automatic is less than current bid
						// Old Bid Wins. But a bunch of complicaed shit happens because newBid has automatic bidding
						// Situation that could never occur
					
					} else {
						// New Bid Wins And Old Bid Doesn't Have Automatic	
						String msg = "You have been outbid for item " + String.valueOf(this.itemID);
						setWinState(this.newBid.getCurrPrice(), this.newBid.getBuyerID(), this.currBid.getBidID(), this.currBid.getBuyerID(), msg);
					}
					
				} else {																			// They both have automatic bid
					System.out.println("Both Automatic Siutation");
						double newBidUpperBidLimit = this.newBid.getUpperBidLimit();
						double currBidUpperBidLimit = this.currBid.getUpperBidLimit();
					if ( newBidUpperBidLimit >= currBidUpperBidLimit ){
						// Current Bid loses
						// Update Auction
						String msg = "You have been outbid for item " + String.valueOf(this.itemID);
						setWinState(currBidUpperBidLimit, this.newBid.getBuyerID(), this.currBid.getBidID(), this.currBid.getBuyerID(), msg);
						
						// Set New Bid Inactive To Create Bid That Beat The Current Bid
						setBidInactive(this.newBid.getBidID());
						
						// Generate New Bid For Curr's Losing Bid To Maintain Track
						String date = String.valueOf(java.time.LocalDate.now());
					    java.util.Date day = new java.util.Date();
					    String strDateFormat = "HH:mm:ss a";
					    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(strDateFormat);
						String time = String.valueOf(sdf.format(day));
										
						// Create New Bid For Current Bid With New Price
	                    Bid currNewBid = new Bid(this.currBid, createBidID(), currBidUpperBidLimit, date, time );
						
	                    // Add Curr's Losing Bid To SQL
						addBidToSQL(currNewBid, this.itemID, date, time);	
						setBidInactive(currNewBid.getBidID());
	                    
						// Generate New Bid For Winning Bid For New Bid
						date = String.valueOf(java.time.LocalDate.now());
					    day = new java.util.Date();
					    strDateFormat = "HH:mm:ss a";
					    sdf = new java.text.SimpleDateFormat(strDateFormat);
						time = String.valueOf(sdf.format(day));
										
						// Create New Bid For Current Bid With New Price
	                    Bid newBid = new Bid(this.newBid, createBidID(), currBidUpperBidLimit + this.incrementVal, date, time );
						
	                    // Add Bid To SQL
						addBidToSQL(newBid, this.itemID, date, time);

					} else {		// Current bid's upper limit won
						// New Bid loses
						// Update Auction
						String msg = "You have been outbid for item " + String.valueOf(this.itemID);
						setWinState(newBidUpperBidLimit, this.currBid.getBuyerID(), this.newBid.getBidID(), this.newBid.getBuyerID(), msg);
						
						// Set Curr Bid Inactive To Create Bid That Beat The New Bid
						setBidInactive(this.currBid.getBidID());
						
						// Generate New Bid For New Bid's Losing Bid To Maintain Track
						String date = String.valueOf(java.time.LocalDate.now());
					    java.util.Date day = new java.util.Date();
					    String strDateFormat = "HH:mm:ss a";
					    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(strDateFormat);
						String time = String.valueOf(sdf.format(day));
										
						// Create New Bid For New Bid With New Price
	                    Bid newNewBid = new Bid(this.newBid, createBidID(), newBidUpperBidLimit, date, time );
						
	                    // Add New Bid's Losing Bid To SQL
						addBidToSQL(newNewBid, this.itemID, date, time);	
						setBidInactive(newNewBid.getBidID());
	                    
						// Generate New Bid For Winning Bid For New Bid
						date = String.valueOf(java.time.LocalDate.now());
					    day = new java.util.Date();
					    strDateFormat = "HH:mm:ss a";
					    sdf = new java.text.SimpleDateFormat(strDateFormat);
						time = String.valueOf(sdf.format(day));
										
						// Create New Bid For Current Bid With New Price
	                    Bid newCurrBid = new Bid(this.currBid, createBidID(), newBidUpperBidLimit + this.incrementVal, date, time );
						
	                    // Add Bid To SQL
						addBidToSQL(newCurrBid, this.itemID, date, time);
	                    
					}
				}		
			}
			
			
	    }

	 // Method to change states when winner is determined
	 public void setWinState( double newBidPrice, int newBidBuyerID, int bidToSetInactive, int buyerToAlert, String msg){
			// New Bid Wins
			// Update Auction With Bid Price and ID
			updateAuctionDetailsInSQL(newBidPrice + this.incrementVal, newBidBuyerID);
			// Set the current bid id as inactive
			setBidInactive(bidToSetInactive);
			// Send Alert That Buyer has been outbid
			sendAlert( buyerToAlert, msg );
	 }
	    
	  // Get ID to Create Alert
	  private int getAlertID(){
		  	ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			int alertID = 0;
			try {
				Statement stmt = con.createStatement();
				String query = "select max(alertID) from alert";
				ResultSet rs = stmt.executeQuery(query);
				
				while (rs.next()){
					alertID = rs.getInt("max(AlertID)")+ 1;
				}
				
			} catch (Exception e){
				System.out.println("6");
				System.out.println(e);
			}
			return alertID;
	  }
	  
	  // Method to send alert
	  public void sendAlert(int ID, String msg){
		  ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			try {
				Statement stmt = con.createStatement();
				String date = String.valueOf(java.time.LocalDate.now());
			     java.util.Date day = new java.util.Date();
			     String strDateFormat = "HH:mm:ss a";
			     java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(strDateFormat);
				String time = String.valueOf(sdf.format(day));
				String insert = "INSERT INTO alert(alertID, itemID, accountID, date, time, message)"
						+ "VALUES (?, ?, ?, ?, ?, ?)";
				//Create a Prepared SQL statement allowing you to introduce the parameters of the query
				PreparedStatement ps = con.prepareStatement(insert);
				//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
				ps.setInt(1, getAlertID());
				ps.setInt(2, this.itemID);
				ps.setInt(3, ID);
				ps.setString(4, date);
				ps.setString(5, time);
				ps.setString(6,  msg );
				ps.executeUpdate();
				
			} catch (Exception e){
				System.out.println("7");
				System.err.println(e.getMessage());
				
			}
	  } 
	}
	%>
	</body>
</html>