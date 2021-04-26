<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.dbproj.pkg.*,com.AuctionSite.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>


<body>
	<%
			String itemType = request.getParameter("type");
			String model = request.getParameter("model");
			String miles = request.getParameter("miles");
			String year = request.getParameter("year");
			String color = request.getParameter("color");
			
			itemType = itemType.toLowerCase();
			
			if(itemType.equals("bike") || itemType.equals("bicycle")){
				int id = Item.generateItemID();
				Item newItem = new Item(id, "bike", "2", false, 1999, "red");
				%> Bike created with id: "<%=id %>" <%
			}else if(itemType.equals("car")){
			
			}else if(itemType.equals("truck")){
			
			}else{
				%>Invalid Item Type "<%=itemType%>"<%
			}
		
		
		%>
</body>

</html>