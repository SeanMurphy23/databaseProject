package com.AuctionSite;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.dbproj.pkg.ApplicationDB;

public class Customer extends Person {

    private int accountNumber;
    private boolean isBuyer;
    private boolean isSeller;
    private int customerID;
    private int customerBalance;


    public Customer(String firstName, String lastName, String SSN, String email, String address, int accountNumber, boolean isBuyer, boolean isSeller, int customerID, int customerBalance){
        super( firstName,  lastName,  SSN,  email, address);
        this.accountNumber = accountNumber;
        this.isBuyer = isBuyer;
        this.isSeller = isSeller;
        this.customerID = customerID;
        this.isBuyer = isBuyer;
        this.isSeller = isSeller;
    }


    // public Bid createBid(){
    //     return new Bid();
    // }

    public Item createItem(int itemID, String modelNumber, boolean inAuction, int year, String color, int miles, String itemType ){
        Item item;
        if (itemType.equals("Bike")){
            item = new Bike(itemID, modelNumber, inAuction, year, color);
            return item;
        } else if (itemType.equals("Truck")){
            item = new Truck(itemID,modelNumber, inAuction, year, color, miles);
            return item;
        } else if (itemType.equals("Car")){
            item = new Car(itemID,modelNumber, inAuction, year, color, miles);
            return item;
        }
        return null;
    }

    /**
    public int getBuyerID(){
        return this.buyerID;
    }

    public int getSellerID(){
        return this.sellerID;
    }**/
    
    public static int generateCustomerID() {
    	ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		try {
			Statement stmt = con.createStatement();
			String query = "SELECT MAX(accountID) as latest FROM account;";
			
			ResultSet result = stmt.executeQuery(query);
			
			result.next();
			
			int id = result.getInt("latest");
			return id+1;
		}catch(Exception E) {
			E.printStackTrace();
		return -1;
	}
		
    }

}
