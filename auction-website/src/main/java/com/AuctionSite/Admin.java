package com.AuctionSite;

public class Admin extends Person {
    private int adminID;

    public Admin(String firstName, String lastName, String SSN, String email, String address, int adminID){
        super( firstName,  lastName,  SSN,  email, address);
        this.adminID = adminID;
    
    }
}
