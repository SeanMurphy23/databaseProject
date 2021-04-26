package com.AuctionSite;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.dbproj.pkg.ApplicationDB;

public class Post {

	private int PostID;
    private int ThreadID;
    private String PostMadeBy;
	private String Message;

    public Post(int PostID,int ThreadID, String Message, String PostMadeBy){
        this.ThreadID = ThreadID;
        this.PostID = PostID;
        this.Message = Message;
        this.PostMadeBy = PostMadeBy;
    }

    public static int generatePostID() {
    	ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		try {
			Statement stmt = con.createStatement();
			String query = "SELECT MAX(postID) as latest FROM posts";
			
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