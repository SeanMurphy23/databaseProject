package com.AuctionSite;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.dbproj.pkg.ApplicationDB;

public class ThreadForum {

    private int ThreadID;
    private String ThreadTitle;
    private boolean isOpen;

    public ThreadForum(int ThreadID, String ThreadTitle, boolean isOpen){
        this.ThreadID = ThreadID;
        this.ThreadTitle = ThreadTitle;
        this.isOpen = isOpen;
    }

    public static int generateThreadID() {
    	ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		try {
			Statement stmt = con.createStatement();
			String query = "SELECT MAX(ThreadID) as latest FROM threads;";
			
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