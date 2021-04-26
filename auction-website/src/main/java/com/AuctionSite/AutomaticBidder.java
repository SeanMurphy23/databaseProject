package com.AuctionSite;
import com.dbproj.pkg.*;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;


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
			
	         String query = "UPDATE auction SET buyerInLeaderID=?, currentBidPrice=? WHERE itemID=" + String.valueOf(this.itemID);;
	         PreparedStatement ps = con.prepareStatement(query);
	         ps.setInt(1, buyerID);
	         ps.setDouble(2, priceToBeat);
	         ps.executeUpdate();
	        
	    } catch (Exception e){
	    	System.out.println(e);
	    }
	}
    
    
    // Automatic Bidding 
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

    
 public void setWinState( double newBidPrice, int newBidBuyerID, int bidToSetInactive, int buyerToAlert, String msg){
		// New Bid Wins
		// Update Auction With Bid Price and ID
		updateAuctionDetailsInSQL(newBidPrice + this.incrementVal, newBidBuyerID);
		// Set the current bid id as inactive
		setBidInactive(bidToSetInactive);
		// Send Alert That Buyer has been outbid
		sendAlert( buyerToAlert, msg );
 }
    
    
  public void checkReserveMet(){
	  if ( this.reservePrice <= this.currItemPrice ){
		  String msgForWinner = "Congrats. You have won item " + String.valueOf(this.itemID);
		  sendAlert(this.buyerInLeaderID, msgForWinner);
	  } else {
		  String reservePriceNotMetMsg = "Reserve price was not been met for " + String.valueOf(this.itemID) + ". Item not purchased.";
		  sendAlert(this.buyerInLeaderID, reservePriceNotMetMsg);
				  
		  String msgToSeller = "Reserve price was not been met for " + String.valueOf(this.itemID) + ". Item not sold.";
		  sendAlert(this.sellerID, msgToSeller);
	  }
  }
	   
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