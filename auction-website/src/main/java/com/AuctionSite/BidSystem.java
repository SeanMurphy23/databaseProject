package com.AuctionSite;
import java.util.ArrayList;
import java.util.List;

// This is where the automatic bid system stuff will happen
// Each auction has this bid system built into it.
// This system has all the bids for the item that is being bid on
// There can really only be two bids at a time because calculations are instantaneous.
// If there are two non automatic bids, the greater one wins.
// If there is one automatic, one manual, if manual > upper limit of automatic, it wins. Otherwise automatic wins
// Finalls if there are two automatic, the one with the greater upper limit wins.
// Say there are three bidders, well we compare the first two and then the last one. 
public class BidSystem {    
    private List<Bid> BidList; 
    private double currItemPrice;
    private int buyerInLeadID;
    private int bidID = 0;
    private double incrementVal;


    public BidSystem(double initialPrice, double incrementVal){
        this.BidList = new ArrayList<Bid>();
        this.currItemPrice =  initialPrice;
        this.incrementVal = incrementVal;
        // TODO FIND ALL BIDS RELATED TO THIS AUCTION AND POPULATE THE ARRAY 
    }

    // Will be used to check history of Bids
    public List<Bid> getBidList(){
        return this.BidList;
    }

    // Add Bid to list
    public void addBidToList(Bid bid){
        BidList.add(bid);
        // TODO Add bid to SQL 
    }

    // Automatic Bidding 
    public List<Integer> calculateCurrentPrice(){
        List<Integer> customerToContact = new ArrayList<Integer>();
        boolean keepGoing = true ;                                                                  // Keep Going terminates when there is only one active bid
        while ( keepGoing ){
            for ( int i = 0; i < this.BidList.size(); i++ ) {                                       // For every single active bid
                Bid bid = this.BidList.get(i);
                if ( bid.getIsActive() & bid.getBuyerID() != this.buyerInLeadID ){                  // Active Bid Unless The Active Bid Is The Current Leading Bid
                    double bidPrice = bid.getCurrPrice();                                           // Get the bid price
                    double priceToBeat = this.currItemPrice + this.incrementVal;                    // Find the price that needs to be beaten 
                    System.out.println("This is the price to beat " + priceToBeat);
                    System.out.println("This is " + bid.getBuyerID() + "'s Bid price " + bid.getCurrPrice());

                    if ( bidPrice >= priceToBeat ) {    // Bid is greater than current price. 
                        System.out.println("Bid is greater than current price. Setting as new bid price");
                        double newBidPrice = Math.max( bidPrice , priceToBeat );        // Set the new bid price as which ever is larger -> Probably always bidPrice
                        this.currItemPrice = newBidPrice;                               // Set as new price for auction and save the buyer ID
                        this.buyerInLeadID = bid.getBuyerID();
                    } else {                            // Bid is less than current price
                        
                        System.out.println("Checking for automatic bidding for " + bid.getBuyerID() + ": " + bid.getAllowAutomaticBidding());
                        System.out.println("Checking bid upper limit " + bid.getUpperBidLimit() + ", Price To Beat: " + priceToBeat);
                        
                        if ( bid.getAllowAutomaticBidding() & bid.getUpperBidLimit() >= priceToBeat ){        // If bidder has automatic bid set and upper limit is greater than price to beat
                            System.out.println("Bid is less than current price. Automatic bidding is set. Setting this bid inactive and creating new bid... \n");
                            // Generate New Bid 
                            String date = "4/10/21";
                            String time = "1:00 AM";

                            // Use copy constructor to create new bid with buyer credentials but different price
                            bid.setInActive(); 
                            Bid newBid = new Bid(bid, createBidID(), priceToBeat, date, time );
                            addBidToList(newBid);

                            // Set current bid winner
                            this.currItemPrice = priceToBeat;
                            this.buyerInLeadID = bid.getBuyerID();

                        } else {                                    // Bid lost. Close it and add buyer ID to list of customers to notify     
                            System.out.println("Bid is less than current price. Setting bid inactive and adding customer to list to contact \n");
                            customerToContact.add(bid.getBuyerID());
                        }
                        bid.setInActive();      // Within this scope, we need to set the current bid as inactive (Created new bid or lost)
                    }
                }
            }

            int numActiveBids = 0;                              // Check how many active bids are there
            for ( int j = 0; j < this.BidList.size(); j++ ){
                Bid bidToCheck = this.BidList.get(j);
                if ( bidToCheck.getIsActive() ){
                    numActiveBids += 1;
                }
            }

            if ( numActiveBids <= 1 ){                        // There should only be one active bid (buyerInLeadID)
                keepGoing = false;                          // Break loop if that is the case. Otherwise keep going (Automatic Bidding)
            }

        }
        System.out.println("\n");

        return customerToContact;
    }

    // Get the current bid price
    public double getCurrItemPrice(){
        return this.currItemPrice;
    }

    // Get the buyer who holds the current bid price
    public int getBuyerInLeadID(){
        return this.buyerInLeadID;
    }

    // Create a unique BIDID for this auction
    public int createBidID(){
        this.bidID += 1;
        return this.bidID;
    }

    // Not sure when this would happen but this is to remove a bid from auction
    public void removeBidFromList(Bid bid){
        // TODO Add functionality to remove item from bid list
        // Remove bid from SQL 
    }

}
