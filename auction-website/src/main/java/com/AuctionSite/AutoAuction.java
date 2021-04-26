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

public class AutoAuction {
	private String currDate;
    
	
	public AutoAuction(String currDate) {
		this.currDate = currDate;
	}
	
	public void findAuctionsToClose() {
		// Go through all the auctions

			// Find auctions that are open
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			SimpleDateFormat sdformat = new SimpleDateFormat("yyyy-MM-dd");
			Date formattedCurrDate = null;
			try {
				formattedCurrDate = sdformat.parse(this.currDate);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			// Get Auction Details
			try {
				Statement stmt = con.createStatement();
				String query = "select * from auction where isOpen = 1";	// Getting open auctions
				ResultSet rs = stmt.executeQuery(query);
				
				while (rs.next()){
					int itemID = rs.getInt("itemID");
					int sellerID = rs.getInt("sellerID");
					int buyerInLeaderID = rs.getInt("buyerInLeaderID");
					String date = rs.getString("date");
					Date formattedAuctionEndDate = sdformat.parse(date);
					if ( formattedAuctionEndDate.compareTo(formattedCurrDate) < 0 ) {
						
					}
				}
					
			} catch (Exception e){
				e.printStackTrace();
			}
		
		// For each auction, check the date. If it is less than the curr date, close it
		
		// Check Reserve Price
		
		// Notify winner and seller
		
		// Modify auction to close
		
		//
	}
	
	
}
