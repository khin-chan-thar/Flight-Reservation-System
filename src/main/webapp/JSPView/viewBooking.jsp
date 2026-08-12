<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>

<%
    // Fetch bookingID from URL
    String bookingIDParam = request.getParameter("bookingID");
    int bookingID = bookingIDParam != null ? Integer.parseInt(bookingIDParam) : 0;

    String bookingCode = "", bookingDate = "", status = "";
    double totalCost = 0;
    int userID = 0, flightID = 0;
    Map<String,String> flightDetails = new HashMap<>();
    List<Map<String,String>> passengers = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:2002/frms","root","thin");

        PreparedStatement psBooking = con.prepareStatement("SELECT * FROM Booking WHERE bookingID=?");
        psBooking.setInt(1, bookingID);
        ResultSet rsBooking = psBooking.executeQuery();
        if(rsBooking.next()){
            bookingCode = rsBooking.getString("bookingCode");
            userID = rsBooking.getInt("userID");
            flightID = rsBooking.getInt("flightID");
            bookingDate = rsBooking.getString("bookingDate");
            status = rsBooking.getString("status");
            totalCost = rsBooking.getDouble("totalCost");
        }
        rsBooking.close(); psBooking.close();

        PreparedStatement psFlight = con.prepareStatement("SELECT flightNumber, origin, destination FROM Flight WHERE flightID=?");
        psFlight.setInt(1, flightID);
        ResultSet rsFlight = psFlight.executeQuery();
        if(rsFlight.next()){
            flightDetails.put("flightNumber", rsFlight.getString("flightNumber"));
            flightDetails.put("origin", rsFlight.getString("origin"));
            flightDetails.put("destination", rsFlight.getString("destination"));
        }
        rsFlight.close(); psFlight.close();

        PreparedStatement psPassenger = con.prepareStatement("SELECT fullName, gender, age FROM Passenger WHERE bookingID=?");
        psPassenger.setInt(1, bookingID);
        ResultSet rsPassenger = psPassenger.executeQuery();
        while(rsPassenger.next()){
            Map<String,String> p = new HashMap<>();
            p.put("fullName", rsPassenger.getString("fullName"));
            p.put("gender", rsPassenger.getString("gender"));
            p.put("age", rsPassenger.getString("age"));
            passengers.add(p);
        }
        rsPassenger.close(); psPassenger.close();
        con.close();
    } catch(Exception e){ out.println("Error: "+e.getMessage()); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Booking | View Details</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
/* Modal styles */
.modal {
    display:flex; position:fixed; top:0; left:0; right:0; bottom:0;
    background: rgba(0,0,0,0.4); justify-content:center; align-items:center;
    z-index:1000;
}
.modal-content {
    background:#fff; padding:20px; border-radius:12px; width:450px;
    max-height:80%; overflow-y:auto; box-shadow:0 5px 15px rgba(0,0,0,0.3);
}
.modal-content h3 { text-align:center; color:#004b75; margin-bottom:15px; }
.passenger-card { border:1px solid #ddd; padding:5px 5px; border-radius:5px; background:#f9f9f9; margin-bottom:5px; font-size:0.9em; }


</style>
</head>
<body>

<header class="navbar"> 
    <nav>
        <ul>
            <li class="logo"><i class="fa-solid fa-plane-departure"></i> Aurora</li>
            <li class="welcome">Welcome : Admin</li>
        </ul>
    </nav>
</header>

<div class="container">
    <div class="admin-panel">
        <aside class="sidebar">
            <h1>Admin Panel</h1> 
            <ul class="menu">
                <li><a href="ManageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
                <li><a href="ManageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
                <li><a href="ManageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
                <li class="active"><a href="ManageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
                <li><a href="ManagePayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
           <li>
  <a  href="passengerInfoController"><i class="fa-solid fa-users"></i> Passenger Information</a>
</li>
                <li><a href="ManageUserAccounts.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
                <li><a href="ManageContactUser.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
                <li><a href="MainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
            </ul>
        </aside>
        
        
         <!-- Main content -->
    <div class="content">
      <div class="content_title">
        <ul>
          <li><h2>Manage Booking</h2></li>
          <li>
            <div class="search-container">
              <input type="text" id="searchInput" placeholder="Search here...">
              <button onclick="searchBooking()"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
          </li>
        </ul>
      </div>
      <br>
      
      
      
            <!-- Background table -->
            <div class="table-wrapper">
                <table id="bookingTable" class="flight-table">
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Booking Code</th>
                            <th>User ID</th>
                            <th>Flight ID</th>
                            <th>Booking Date</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/frms","root","root");
                            String sql = "SELECT bookingID,bookingCode,userID,flightID,bookingDate,totalCost,status FROM Booking";
                            PreparedStatement ps = con.prepareStatement(sql);
                            ResultSet rs = ps.executeQuery();
                            while(rs.next()){
                                int bID = rs.getInt("bookingID");
                                String bCode = rs.getString("bookingCode");
                                int uID = rs.getInt("userID");
                                int fID = rs.getInt("flightID");
                                String bDate = rs.getString("bookingDate");
                                double price = rs.getDouble("totalCost");
                                String st = rs.getString("status");
                    %>
                        <tr>
                            <td><%=bID%></td>
                            <td><%=bCode%></td>
                            <td><%=uID%></td>
                            <td><%=fID%></td>
                            <td><%=bDate%></td>
                            <td><%=price%></td>
                            <td><%=st%></td>
                            <td>
                <a href="viewBooking.jsp?bookingID=<%= bookingID %>" class="btn btn-view"><i class="fa-regular fa-eye"></i></a>
                <a href="EditBooking.jsp?bookingID=<%= bookingID %>" class="btn btn-edit"><i class="fa-regular fa-pen-to-square"></i></a>
                
              </td>
                        </tr>
                    <%
                            }
                            con.close();
                        } catch(Exception e){ out.println("<tr><td colspan='8'>Error: "+e.getMessage()+"</td></tr>"); }
                    %>
                    </tbody>
                </table>
            </div>

            <!-- Modal overlay -->
            <div class="modal">
                <div class="modal-content">
                    <h3>Booking Details</h3>
                 <p><i class="fa-solid fa-code"></i><strong>Booking Code:</strong> <%= bookingCode %></p>
        <p><i class="fa-solid fa-user"></i><strong>User ID:</strong> <%= userID %></p>
        <p><i class="fa-solid fa-plane-departure"></i><strong>Flight Number:</strong> <%= flightDetails.get("flightNumber") %></p>
        <p><i class="fa-solid fa-location-dot"></i><strong>Origin:</strong> <%= flightDetails.get("origin") %></p>
        <p><i class="fa-solid fa-location-dot"></i><strong>Destination:</strong> <%= flightDetails.get("destination") %></p>
        
        <p><i class="fa-solid fa-calendar"></i><strong>Booking Date:</strong> <%= bookingDate %></p>
        <p><i class="fa-solid fa-money-bill-wave"></i><strong>Price:</strong> <%= totalCost %></p>
        <p><i class="fa-solid fa-circle-check"></i><strong>Status:</strong> <%= status %></p>
                 
                    <h4>Passengers</h4>
                    <% for(Map<String,String> p : passengers){ %>
                        <div class="passenger-card">
                            <p><i class="fa-solid fa-user"></i> <strong>Name:</strong> <%= p.get("fullName") %></p>
                            <p><i class="fa-solid fa-venus-mars"></i> <strong>Gender:</strong> <%= p.get("gender") %></p>
                            <p><i class="fa-solid fa-calendar-day"></i><strong>Age:</strong> <%= p.get("age") %></p>
                        </div>
                    <% } %>
                    <button  class="btn btn-delete"  onclick="window.location.href='${pageContext.request.contextPath}/JSPView/manageBooking.jsp'">Close</button>
                </div>
            </div>

        </div>
    </div>
</div>

</body>
</html>
