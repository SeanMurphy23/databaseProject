package com.AuctionSite;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.dbproj.pkg.ApplicationDB;

public class ItemList {
    private List<Item> itemList;

    public ItemList(){
        this.itemList = new ArrayList<Item>();   
    }

    public void addItemToList(Object obj, String itemType){
    	System.out.println("Added To Lost");
        Item item = null;
        if (itemType.equals("bike")){
            item = (Bike) obj;
        } else if (itemType.equals("truck")){
            item = (Truck) obj;
        } else if (itemType.equals("car")){
            item = (Car) obj;
        }
        this.itemList.add(item);
    }
    
    //Proposed alternate version
    public void addItemToTheList(Item item) {
    	Item theItem = (Item) item;
    	this.itemList.add(theItem);
    	
    }

    public List<Item> getItemList(){
    	System.out.println("ItemList GetItemList");
    	getItemsFromSQL();
    	return this.itemList;
    }
    
    public void getItemsFromSQL(){
    	ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		try {
			
			String query = "SELECT * FROM items";
			
			//Create a Prepared SQL statement allowing you to introduce the parameters of the query
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			
			while (rs.next()) {
				String item_type = rs.getString("item_type");
				String model = rs.getString("model");
				int item_id = rs.getInt("item_id");
				int item_year = rs.getInt("item_year");
				String color = rs.getString("color");
				String img = rs.getString("img");
				String location = rs.getString("location");
				String transmission = rs.getString("transmission");
				String mpg = rs.getString("mpg");
				String miles = rs.getString("miles");

		        if (item_type.equals("bike")){
		            Bike bike = new Bike(item_id, model, item_year, color,  img, location, transmission, mpg, miles);
		            addItemToList(bike,"bike");
		        } else if (item_type.equals("truck")){
		            Truck truck = new Truck(item_id, model, item_year, color, img, location, transmission, mpg, miles);
		            addItemToList(truck,"truck");
		        } else if (item_type.equals("car")){
		            Car car = new Car(item_id ,model, item_year, color, img, location, transmission, mpg, miles );
		            addItemToList(car,"car");
		        }
				
			}

		
		}catch(Exception E) {
			E.printStackTrace();
		}
    }
    
    public void removeItemFromList(Item item){
        // Code to remove item to list
    }

    public void storeAuctionToSQL(){
        // Remove Item From SQL
    }

    public void removeItemFromSQL(Item item){
        // Remove Item From SQL Table
    }
    
    public boolean isEmpty() {
    	return this.itemList.isEmpty();
    }

    //needed a diff accessor
    public List<Item> getCurrentList(){
    	return this.itemList;
    }


}
