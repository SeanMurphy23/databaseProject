package com.AuctionSite;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

import com.dbproj.pkg.ApplicationDB;

public class Auction {
    private BidSystem bidSystem;        // Does all of the Automatic Bidding Stuff
    private int auctionID;              // Auction ID For Reference
    private int sellerID;               // Seller ID For The Person The Item Belongs To
    private int buyerInLeadID;          // Keep track of which buyer is in the lead
    private int itemID;                 // Which Item is this auction for?
    private double initialPrice;        // The initial price of the auction
    private double currentBidPrice;     // What is the current price of the item
    private double reservePrice;        // If currentBidPrice is less than reserPrice, item will not be sold
    private double incrementVal;        // What's the incrmement val for the next bid
    private boolean isOpen;             // Is this auction still open? 
    private String closeTime;           // When does this auction end?
    private String closeDate;			//what day does this auction end?
    

    public Auction( int auctionID, double initialPrice, double reservePrice, int sellerID, int itemID, String closeTime, String closeDate, double incrementVal ){
        this.auctionID = auctionID;
        this.initialPrice = initialPrice; 
        this.reservePrice = reservePrice;
        this.incrementVal = incrementVal;
        this.sellerID = sellerID;
        this.itemID = itemID;
        this.closeTime = closeTime;
        this.isOpen = true;
        this.closeDate = closeDate;
        this.bidSystem = new BidSystem( initialPrice, incrementVal );
    }

    public void addBid( Bid bid ){
        if ( bid.getCurrPrice() < this.currentBidPrice & !bid.getAllowAutomaticBidding() & this.currentBidPrice > bid.getUpperBidLimit()) {  // Check if this is a valid bid to place. If it has automatic bidding and if the upper limit is greater than the current price
            System.out.println( "Bid price is less than current bid price" );
        } else {
            System.out.println( "Bid has succesfully been placed for buyer ID " + bid.getBuyerID() );
            this.bidSystem.addBidToList(bid);
            List<Integer> customerToAlert = this.bidSystem.calculateCurrentPrice();     // Get customers that lost due to automatic bidding 
            System.out.println( "These customers have lost and we must send them an alert " + customerToAlert );
            getCurrentLead();
        }
        System.out.println( "\n" );
    }

    // Create a unique Bid ID for the Bid System
    public int createBidID(){
        return this.bidSystem.createBidID();
    }

    // Finds which buyer is in lead and their bid price
    private void getCurrentLead(){
        this.buyerInLeadID = getBuyerInLeadID();
        this.currentBidPrice = getCurrentBidPrice();
    }

    public void closeAuction(){         // When the close time of the auction hits the time, then it is over and we trigger this function
        this.isOpen = false;
        getCurrentLead();
        if (this.reservePrice < this.currentBidPrice){
            //sendAlertToCustomer();
            // Reserve met so item was sold
        } else {
            //sendAlertToCustomer();
            // Reserve not met so item was not sold
        }
    }

    // Get the ID of the buyer in the lead
    private int getBuyerInLeadID(){
        int buyerInLead = this.bidSystem.getBuyerInLeadID();
        System.out.println("This is the current buyer in lead " + buyerInLead );
        return buyerInLead;
    }

    // Get the current bid price to display to the user
    private double getCurrentBidPrice(){
        double currPrice = this.bidSystem.getCurrItemPrice();
        System.out.println("This is the current bid price " + currPrice );
        return currPrice;
    }
    
    public static int generateAuctionID() {
    	ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		try {
			Statement stmt = con.createStatement();
			String query = "SELECT MAX(auctionID) as latest FROM auction;";
			
			ResultSet result = stmt.executeQuery(query);
			
			result.next();
			
			int id = result.getInt("latest");
			return id+1;
		}catch(Exception E) {
			E.printStackTrace();
		return -1;
	}
		
    }


    public static void main(String[] args) {
        String closeTime = "9:00";
        String closeDate = "10/15/2021";

        // Create the auction item and place it on the auction. This will also add it to the SQL table
        Auction auction = new Auction(1, 100, 500, 1, 666, closeTime, closeDate, 50);

        // Let's say the buyer has found an item that they like. itemID # 666

        int itemIDForBid = 666;
        String date = "10/11/2021";
        String time = "9:00 AM";

        // Bid joshBid = new Bid(  2, itemIDForBid,  BID_ID,  BID_PRICE,  UPPER_BID_LIMIT,  date,  time, automaticBid); // Buyer is Josh 
        // Bid shaBid = new Bid(  3, itemIDForBid,  auction.createBidID(),  100, 2000, date,  time, true); // Buyer is Sha. Since Sha's upper bid limit is biggest, he should win
        // Bid benBid = new Bid(  4, itemIDForBid,  auction.createBidID(),  300,  900,  date,  time, false); // Buyer is Ben 
        // Bid evanBid = new Bid(  5, itemIDForBid,  auction.createBidID(),  300,  1000,  date,  time, true); // Buyer is Evan 

        // Param Order: BuyerID, ItemID, BID_ID, Bid_Price, Upper_Limit, Date, Time, Automatic Bidding Set

    // ============================ TEST CASES ======================================================

        // // ================= Case 1 where Automatic Bid vs Non Auto Bid =====================
        // Bid joshBid = new Bid( 2, itemIDForBid,  auction.createBidID(),  200,  1000,  date,  time, true); // Buyer is Josh 
        // Bid benBid = new Bid( 4, itemIDForBid,  auction.createBidID(),  300,  900,  date,  time, false); // Buyer is Ben auction.addBid(joshBid);
        // auction.addBid(joshBid);
        // auction.addBid(benBid);
        // auction.getBuyerInLeadID();
        // auction.getCurrentBidPrice();
        // // Item price is 100. Josh places bid of 200. He is the lead bidder. Ben comes and places bid of 300. He out bids Josh.
        // // However Josh has automatic bidding set so his bid will rebid at 350 (50 is the increment price). Josh wins. 
        // // He is in the lead, the current bid price is $350. We store Ben's id in a list to contact that he has been outbid
        // // ================================================================================

        // // ================= Case 2 where Automatic Bid vs Automatic Bid =====================
        // Bid joshBid = new Bid( 2, itemIDForBid,  auction.createBidID(),  200, 600,  date,  time, true); // Buyer is Josh 
        // Bid shaBid = new Bid(  3, itemIDForBid,  auction.createBidID(),  250, 500, date,  time, true); // Buyer is Sha. Since Sha's upper bid limit is biggest, he should win
        // auction.addBid(joshBid);
        // auction.addBid(shaBid);
        // auction.getBuyerInLeadID();
        // auction.getCurrentBidPrice();
        // // // Item price is 100. Josh places bid of 200. He is the lead bidder. Sha comes and places bid of 250. He out bids Josh.
        // // // However Josh has automatic bidding set so his bid will rebid at 300 (50 is the increment price). 
        // // // Sha also has automatic bidding so he will rebid. Since Josh's upper limit is higher than Sha's, Josh will win the bid
        // // ================================================================================


        // ================= Case 3 where Automatic Bid vs Automatic Bid then another Automatic Bidder then Manual Bidder =====================
        Bid joshBid = new Bid( 2, itemIDForBid,  auction.createBidID(),  200, 1000,  date,  time, true); // Buyer is Josh 
        Bid shaBid = new Bid(  3, itemIDForBid,  auction.createBidID(),  250, 500, date,  time, true); // Buyer is Sha. Since Sha's upper bid limit is biggest, he should win
        Bid evanBid = new Bid(  5, itemIDForBid,  auction.createBidID(),  550,  800,  date,  time, true); // Buyer is Evan 
        Bid benBid = new Bid( 4, itemIDForBid,  auction.createBidID(),  1100,  1000,  date,  time, false); // Buyer is Ben  
        Bid niharBid = new Bid( 6, itemIDForBid,  auction.createBidID(),  900,  1200,  date,  time, true); // Buyer is Ben  
        auction.addBid(joshBid);
        auction.addBid(shaBid);
        auction.getBuyerInLeadID();
        auction.getCurrentBidPrice();
        // Josh wins over Sha here
        auction.addBid(evanBid);
        // Josh wins over Evan here. Bid price becomes 850
        auction.addBid(benBid);
        // Ben who does not have automatic bids. Josh tries to catch up but loses. Ben wins
        auction.addBid(niharBid);
        // Nihars' bid is less than the current price, but his automatic bid upper limit is greater so we let it pass and nihar wins
        auction.getBuyerInLeadID();
        auction.getCurrentBidPrice();
        // ================================================================================

	}
}
