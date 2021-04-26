package com.AuctionSite;

import com.dbproj.pkg.ApplicationDB;
//import com.dbproj.pkg.Connection;
//import com.dbproj.pkg.ResultSet;
//import com.dbproj.pkg.Statement;
import java.sql.*;

public class Item {
    protected int itemID; 
    protected String itemType;
    protected String model;
    protected int year;
    protected String color; 
    protected String img;
    protected String location;
    protected String transmission;
    protected String mpg;
    protected String miles;

    public Item( int itemID, String itemType, String model, int year, String color, String img, String location, String transmission, String mpg, String miles){
        this.itemID = itemID;
        this.itemType = itemType;
        this.model = model;
        this.year = year;
        this.color = color;
        this.img = img;
        this.location = location;
        this.transmission = transmission;
        this.mpg = mpg;
        this.miles = miles;
    }

    public int getItemID(){
        return this.itemID;
    }

    public void addToSQL(){
    	ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
        try {
            Statement stmt = con.createStatement();
  
            String insert = "INSERT INTO items(item_type, model, item_id, item_year, color, img, location, transmission, mpg, miles)"
                    + "VALUES (?, ?, ?, ?,?,?,?,?,?,?)";
            //Create a Prepared SQL statement allowing you to introduce the parameters of the query
            PreparedStatement ps = con.prepareStatement(insert);

            //Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
            ps.setString(1, this.itemType);
            ps.setString(2, this.model);
            ps.setInt(3, this.itemID);
            ps.setInt(4, this.year);
            ps.setString(5, this.color);
            ps.setString(6,this.img);
            ps.setString(7, this.location);
            ps.setString(8, this.transmission);
            ps.setString(9,this.mpg);
            ps.setString(10,this.miles);
            //Run the query against the DB
            ps.executeUpdate();
        }catch(Exception E) {
            E.printStackTrace();
        }
    }

    public void removeFromSQL(){
        // Code to remove item from SQL
    }
    
    public String getItemType() {
    	return this.itemType;
    }
    
    public String getModelNumber() {
    	return this.model;
    }
    
    public int getYear() {
    	return this.year;
    }
    
    public String getColor() {
    	return this.color;
    }
    
    public String getImg(){
        return this.img;
    }
    
    public String getLocation() {
    	return this.location;
    }

    public String getTransmission() {
    	return this.transmission;
    }

    public String getMPG() {
    	return this.mpg;
    }

    public String getMiles() {
    	return this.miles;
    }
    public static int generateItemID() {
    	ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		try {
			Statement stmt = con.createStatement();
			String query = "SELECT MAX(item_id) as latest FROM items;";
			
			ResultSet result = stmt.executeQuery(query);
			
			result.next();
			
			int id = result.getInt("latest");
			return id+1;
		}catch(Exception E) {
			E.printStackTrace();
		return -1;
	}
		
    }
    
    public String toString() {
    	String output = "";
    	output += "Type: " + this.itemType + ", ";
    	output += "ID: " + this.itemID + ", ";
    	output += "Model: " + this.model + ", ";
    	output += "Year: " + this.year + ", ";
    	output += "Color: " + this.color;
    	return output;
    }

}
