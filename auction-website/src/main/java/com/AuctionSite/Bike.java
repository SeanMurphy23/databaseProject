package com.AuctionSite;

public class Bike extends Item {
    
    public Bike(int itemID, String modelNumber,  int year, String color, String img, String location, String transmission, String mpg, String miles){
        super(itemID, "bike", modelNumber, year, color, img, location, transmission, mpg, miles );
    }

    @Override
    public int getItemID(){
        return super.getItemID();
    }

    public String getItemType() {
    	return super.getItemType();
    }
    
    @Override
    public void addToSQL(){
        super.addToSQL();
    }
    
}
