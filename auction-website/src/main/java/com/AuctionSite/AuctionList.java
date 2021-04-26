package com.AuctionSite;

import java.util.ArrayList;
import java.util.List;

public class AuctionList {
    private List<Auction> auctionList;

    public AuctionList(){
        this.auctionList = new ArrayList<Auction>();   
    }

    public void addToAuction(Auction auction){
        this.auctionList.add(auction);
        storeAuctionToSQL();
    }

    public void removeFromAuction(Item item){
        // Code to remove item to list
    }

    public void storeAuctionToSQL(){
        // Store Auction Item To SQL
    }

    public void removeAuctionFromSQL(Auction auction){
        // Remove Auction From SQL Table
    }

}
