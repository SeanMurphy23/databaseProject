package com.AuctionSite;

import java.util.List;

public class AuctionSite {

    private AuctionList auctionList;        // Maybe we can combine auction and item list into one. Each item can have all the auction stuff inside it?????
    private ItemList itemList;
    private int auctionID = 0;

    public AuctionSite(){
        // Create a new bidding system and hold a list of all items
        // Auction holds all the auction 
        // ItemList holds the items that the user can choose from
        super();
        this.auctionList = new AuctionList();
        this.itemList = new ItemList();
    }

    public void addToAuction(Auction auction){
        this.auctionList.addToAuction(auction);
    }

    public void addToItemList(Object obj, String itemType){
    	System.out.println("Added");
        this.itemList.addItemToList(obj, itemType);
    }

    public List<Item> getItemList() {
    	return this.itemList.getItemList();
    }
    
    public int getAuctionID(){
        this.auctionID += 1;
        return this.auctionID;
    }

    public Auction getAuction(int itemID){
        // Code To Find Auction
        return null;
    }
/*
	public static void main(String[] args) {
        // When the auction site starts, collect data from SQL and populate BidSystem and ItemList
        // Get a list of all the items that are active from the item table in SQL and place them into the itemList in JAVA
            // We want to do this so the user can view all the available items.
            // If we want, we could allow the user to search through Java instead of SQL. 
        // Get a list of all the items that are active from the auction table in SQL and place them into the auctionList in JAVA
            // This will initalize the bidding system for each auction and set up any alerts that need to be sent to users

        AuctionSite auctionSite = new AuctionSite();
        
        // The user will log in with username and password
        // If succesfful, the information we get from SQL will be placed as a Customer Object in Java. 
        // Let's say this is the table we get from the USER TABLE

        String firstName = "Louis";
        String lastName = "Shinohara";
        String SSN  = "999-99-9999";
        String email = "louis@gmail.com";
        String address = "999 Central Ave, New Brunswick NJ, 07652";
        int accountNumber = 12345;
        boolean isBuyer = true;
        boolean isSeller = true;
        int buyerID = 12345;
        int sellerID = 12345;
        int customerBalance = 999;

        // Create Person Object
        Customer customer = new Customer( firstName,  lastName,  SSN,  email,  address,  accountNumber,  isBuyer,  isSeller,  buyerID,  sellerID,  customerBalance);

        // Now we can either create an item for auction or create a bid for an auction.
        // Let's say that this person will create an item and start an auction
        
        // Creating an item to place for auction
        // Let the user fill out a form on the page
        // When they click enter, we will collect the information from the page and call java code
        // Let's say that this is what we collected
        String itemType = "Bike";
        int itemID = 31312421;
        String modelNumber = "Haro";
        boolean inAuction = true;
        int year = 1994;
        String color = "Black";

        // Create the item and store it in the auction site
        Bike item = new Bike(itemID, modelNumber, inAuction, year, color );
        auctionSite.addToItemList(item, itemType);
        
        int auctionID = auctionSite.getAuctionID();     // Returns a unique auction ID
        int initialPrice = 100;
        int sellersID = customer.getSellerID();
        String closeTime = "9:00";
        int incrementVal = 10;
        int reservePrice = 500;

        // Create the auction item and place it on the auction. This will also add it to the SQL table
        Auction auction = new Auction(auctionID, initialPrice, reservePrice, sellersID, itemID, closeTime, incrementVal);
        auctionSite.addToAuction(auction);


        // Now that there is an item on the auction, let's say a buyer wants to place a bid on an auction
        // The buyer will use the itemList in the AuctionSite class to view all items.
        // The itemList in this class will be initalized with all the items in the database when the app first starts
        // ????? My question is should we query each item from database???
            // I feel like that would be a lot of queries which we would have to write
            // If we could get all the items and store it in Java, searching through Java would be simple
            // And we should only modify it in the SQL when there are major changes such as adding or removing. 
        
        // Let's say the buyer has found an item that they like. itemID # 31312421

        int itemIDForBid = 31312421;
        int BID_ID = 421412; // Some random number
        double MAX_BID = 1000;
        int BUYER_ID = customer.getBuyerID();
        double UPPER_BID_LIMIT = 2000;
        String date = "10/11/2021";
        String time = "9:00 AM";
        double CURR_PRICE = 200;
        boolean allowAutomaticBidding = true;


        Bid bid = new Bid(  BUYER_ID, itemID,  BID_ID,  CURR_PRICE,  UPPER_BID_LIMIT,  date,  time, allowAutomaticBidding);

        // Now that the bid has been created, let's find the auction using the itemID in the auction list
        Auction auctionInstance = auctionSite.getAuction(itemIDForBid);
        System.out.println("Test");

        // We have found the auction associated with the itemID. Let's add the bid to that auction
        // auctionInstance.addBid(bid);

        // Now that the bid has been placed, the user must wait for an alert from the automatic bidding system


	}

*/
    
}
