package com.AuctionSite;

public class Person {
    
    protected String firstName;
    protected String lastName; 
    protected String SSN;
    protected String email;
    protected String address;
    
    
    public Person(String firstName, String lastName, String SSN, String email, String address ){
        this.firstName = firstName;
        this.lastName = lastName;
        this.SSN = SSN;
        this.email = email;
        this.address = address;
    }


}
