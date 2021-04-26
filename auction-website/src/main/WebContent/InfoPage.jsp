<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.dbproj.pkg.*,com.AuctionSite.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.sql.*,java.text.SimpleDateFormat.*"%>
<%@ page import="java.util.Date.*"%>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css">
	.body {
		background-color: #ffe5e5;
	}	 
	.app-body {
		display: flex;
		flex-direction: row;
		justify-content: space-around;
	  	margin-left: 20px;
	  	margin-bottom: 20px;
	  	padding: 8;
	  	height: 200px;
	}
	.img-container {
		display: flex;
		flex-direction: row;
	}
	.img {
		height: 350px;
		width: 450px;
		margin-left: auto;
		margin-right: auto;
		margin-bottom: 32px;
	}
	.login-form {
		float: left;
		margin-top: 16px;
		background: #c9c9c9;
		padding: 16px;
		border-radius: 16px;
	}	
	.register-form{
		float: right;
		margin-top: 16px;
		background: #c9c9c9;
		padding: 16px;
		border-radius: 16px;
	}
	.header {
	text-align: center;
	
	}
	.button{
		margin-top: 16px;
	}
</style> 
</head>
	<body class='body'>
	<div class="header">
		<h2>
		Spring 2021 Database Ebay Application
		</h2>
	</div>

	<div class="header">
		<h4>
			Group #46: Joshua Hymowitz, Ushio Shinohara, Isaac Perez 
		</h4>
		<%
			// =================================================================================================== 
			// ============================ UN COMMENT HERE TO END AUCTIONS TO SELECTED DATE =====================
			// ===================================================================================================
			// INSERT DATE HERE TO SIMULATE CLOSING AUCTIONS UP TO THIS DATE
			//String todayDate = "2021-04-24";
			//AutoAuction autoAuction= new AutoAuction(todayDate);
			//autoAuction.findAuctionsToClose();
		%>
	</div>
	
	<div class="img-container">
		<img class="img" src="https://i.imgur.com/LE0gJqp.jpg" />
	</div>
			
	<div class="app-body">
		<div class="login-form">
			<h3>
			LOGIN: 
			</h3>
			<form method="get" action="Dashboard.jsp">
				<table>
					<tr>    
						<td>Username</td><td><input type="text" name="username"></td>
					</tr>
					<tr>
						<td>Password</td><td><input type="text" name="pass"></td>
					</tr>
				</table>
				<input class="button" type="submit" value="Login">
			</form>
		</div>
	
		<div class="register-form">
			<h3>
				Register: 
			</h3> 
			<form method="get" action="Register.jsp">
				<table>
					<tr>    
						<td>Username</td><td><input type="text" name="username"></td>
					</tr>
					<tr>
						<td>Password</td><td><input type="text" name="pass"></td>
					</tr>
				</table>
				<input type="submit" value="Register">
			</form>
		</div>
	</div>

	<%!
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
					
					java.text.SimpleDateFormat sdformat = new java.text.SimpleDateFormat("yyyy-MM-dd");
					java.util.Date formattedCurrDate = null;
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
						// For each auction, check the date. If it is less than the curr date, close it
						while (rs.next()){
							int itemID = rs.getInt("itemID");
							int sellerID = rs.getInt("sellerID");
							int buyerInLeaderID = rs.getInt("buyerInLeaderID");
							double currentBidPrice = rs.getFloat("currentBidPrice");
							double reservePrice = rs.getFloat("reservePrice");
							String date = rs.getString("date");
							java.util.Date formattedAuctionEndDate = sdformat.parse(date);
							// Date has passed
							System.out.println("Stuff working til here");
							System.out.println(formattedAuctionEndDate);
							System.out.println(formattedCurrDate);
							System.out.println(formattedAuctionEndDate.compareTo(formattedCurrDate) < 0);
							if ( formattedAuctionEndDate.compareTo(formattedCurrDate) < 0 ) {
								// Check Reserve Price and send alert
								checkReserveMet(reservePrice, currentBidPrice, itemID, buyerInLeaderID, sellerID);
								// Close Auction
								updateAuctionDetailsInSQL(itemID);
							}
						}
							
					} catch (Exception e){
						e.printStackTrace();
					}
			}
			
				// Check if reserve has been met for the auction to close
			  public void checkReserveMet(double reservePrice, double currItemPrice, int itemID, int buyerInLeaderID, int sellerID){
				  System.out.println("Sent Alert To Buyer " + String.valueOf(buyerInLeaderID) + " and " + "Seller " + String.valueOf(sellerID) + " about Item # " + String.valueOf(itemID));
				  if ( reservePrice <= currItemPrice ){
					  String msgForWinner = "Congrats. You have won item " + String.valueOf(itemID);
					  sendAlert(buyerInLeaderID, msgForWinner, itemID);
				  } else {
					  String reservePriceNotMetMsg = "Reserve price was not been met for " + String.valueOf(itemID) + ". Item not purchased.";
					  sendAlert(buyerInLeaderID, reservePriceNotMetMsg, itemID);
							  
					  String msgToSeller = "Reserve price was not been met for " + String.valueOf(itemID) + ". Item not sold.";
					  sendAlert(sellerID, msgToSeller, itemID);
				  }
			  }
		
			    // Update the auction in SQL
			    public void updateAuctionDetailsInSQL(int itemID){
			    	ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();
					try {
						Statement stmt = con.createStatement();
						
						 // Close auction in auction table
				         String query = "UPDATE auction SET isOpen = 0 WHERE itemID=" + String.valueOf(itemID);
				         PreparedStatement ps = con.prepareStatement(query);
				         ps.executeUpdate();
				         
				         
				    } catch (Exception e){
				    	System.out.println(e);
				    }
				}
			    
			   // Send the buyer and seller alerts about the auction results
			  public void sendAlert(int ID, String msg, int itemID){
				  ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();
					try {
						Statement stmt = con.createStatement();
						String date = String.valueOf(java.time.LocalDate.now());
					     java.util.Date day = new java.util.Date();
					     String strDateFormat = "HH:mm:ss a";
					     java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(strDateFormat);
						String time = String.valueOf(sdf.format(day));
						String insert = "INSERT INTO alert(alertID, itemID, accountID, date, time, message)"
								+ "VALUES (?, ?, ?, ?, ?, ?)";
						//Create a Prepared SQL statement allowing you to introduce the parameters of the query
						PreparedStatement ps = con.prepareStatement(insert);
						//Add parameters of the query. Start with 1, the 0-parameter is the INSERT statement itself
						ps.setInt(1, getAlertID());
						ps.setInt(2, itemID);
						ps.setInt(3, ID);
						ps.setString(4, date);
						ps.setString(5, time);
						ps.setString(6,  msg );
						ps.executeUpdate();	
					} catch (Exception e){
						System.out.println("7");
						System.err.println(e.getMessage());
						
					}
			  }
			  
			  private int getAlertID(){
				  	ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();
					int alertID = 0;
					try {
						Statement stmt = con.createStatement();
						String query = "select max(alertID) from alert";
						ResultSet rs = stmt.executeQuery(query);
						
						while (rs.next()){
							alertID = rs.getInt("max(AlertID)")+ 1;
						}
						
					} catch (Exception e){
						System.out.println("6");
						System.out.println(e);
					}
					return alertID;
			  }
		}
	%>
	</body>
</html>