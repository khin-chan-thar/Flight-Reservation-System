<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*, java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="style.css">
  <!-- FontAwesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <title>Aurora Admin | Manage Booking</title>
  <style>
  

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
    <!-- Sidebar -->
    <aside class="sidebar">
      <h1>Admin Panel</h1> 
     <ul class="menu">
        <li><a href="<%=request.getContextPath()%>/JSPView/manageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
        <li><a href=" <%=request.getContextPath()%>/JSPView/manageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li class="active"><a href="<%=request.getContextPath()%>/JSPView/manageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageUserPayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
            <li>
    <a  href="<%=request.getContextPath()%>/passengerInfoController"><i class="fa-solid fa-users"></i> Passenger Information</a>
</li>
<li><a href="<%=request.getContextPath()%>/JSPView/manageUserAcc.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/adminReplyMessage.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/mainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
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
              // Connect to DB and fetch bookings
              try {
                  Class.forName("com.mysql.cj.jdbc.Driver");
                  Connection con = DriverManager.getConnection("jdbc:mysql://localhost:2002/frms", "root", "thin");

                  String sql = "SELECT bookingID,bookingCode, userID, flightID, bookingDate, totalCost, status FROM Booking";
                  PreparedStatement ps = con.prepareStatement(sql);
                  ResultSet rs = ps.executeQuery();

                  while (rs.next()) {
                      int bookingID = rs.getInt("bookingID");
                      String bookingCode = rs.getString("bookingCode");
                      int userID = rs.getInt("userID");
                      int flightID = rs.getInt("flightID");
                      String bookingDate = rs.getString("bookingDate");
                      double price = rs.getDouble("totalCost");
                      String status = rs.getString("status");
            %>
            <tr>
              <td><%= bookingID %></td>
              <td><%= bookingCode %></td>
              <td><%= userID %></td>
              <td><%= flightID %></td>
              <td><%= bookingDate %></td>
             
              <td><%= price %></td>
              <td><%= status %></td>
              <td>
                <a href="${pageContext.request.contextPath}/JSPView/viewBooking.jsp?bookingID=<%= bookingID %>" class="btn btn-view"><i class="fa-regular fa-eye"></i></a>
                <a href="${pageContext.request.contextPath}/JSPView/editBooking.jsp?bookingID=<%= bookingID %>" class="btn btn-edit"><i class="fa-regular fa-pen-to-square"></i></a>
                
              </td>
            </tr>
            <%
                  }
                  con.close();
              } catch (Exception e) {
                  out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
              }
            %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
  function searchBooking() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let rows = document.querySelectorAll("#bookingTable tbody tr");
    rows.forEach(row => {
      let text = row.innerText.toLowerCase();
      row.style.display = text.includes(input) ? "" : "none";
    });
  }

function searchBooking() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let rows = document.querySelectorAll("#bookingTable tbody tr");

    rows.forEach(row => {
        // Get relevant columns
        let bookingCode = row.cells[1].innerText.toLowerCase(); // Booking Code
        let status = row.cells[6].innerText.toLowerCase();      // Status
        let bookingDate = row.cells[4].innerText.toLowerCase(); // Booking Date

        // Check if input matches any of these
        if (bookingCode.includes(input) || status.includes(input) || bookingDate.includes(input)) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
}
</script>
</body>
</html>
    