	<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.util.*,Model.Passenger" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Aurora Admin | Passenger Info</title>
  <link rel="stylesheet" href="style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root {
      --primary-color: #004b75;
      --primary-color-dark: #0369a1;
      --text-dark: #333333;
      --text-light: #767268;
      --extra-light: #f3f4f6;
      --white: #ffffff;
      --max-width: 1200px;
    }

    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: #f4f6f9;
      color: var(--text-dark);
    }

  header {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 62px;                /* navbar size အမြင့်ကြီး */
  background: var(--primary-color);
  color: white;
  font-size: 22px;
  font-weight: bold;
  padding: 0 50px;
  display: flex;
  align-items: center;         /* vertical center */
  justify-content: center;     /* အရင် default အလယ် center */
  z-index: 1000;
}/* Logo ကို ဘယ်ဘက်မှာ fix */
header .logo {
  position: absolute;
  left: 50px;                  /* ဘယ်ဘက် 50px */
  font-size: 20px;
  font-weight: bold;
}

/* Welcome text အလယ် */
header .admin {
  font-weight: 250;
  text-align: center;
}

    /* Panel */
    .admin-panel {
      display: flex;
      padding-top: 70px;
    }

    /* Sidebar */
   .sidebar {
      width: 240px;
      background: #fff;
      box-shadow: 3px 0 8px rgba(0,0,0,0.1);
      padding: 20px 10px;
      margin-left: 5px;
      height: fit-content;
      border-radius: 12px;
      position: fixed;
      
    }
    .admin-panel h1 {
        flex: 1;
      margin-top: 0;
      font-size: 18px;
      color: #004b75;
      text-align: center;
      padding: 10px 20px;
    }
    .sidebar h1 {
      text-align: center;
      color: var(--primary-color);
      margin-bottom: 20px;
    }
    .menu { list-style: none; padding: 0; margin: 0; }

      .menu li {
      padding: 10px 20px;
      margin : 5px;
      cursor: pointer;
      font-size: 15px;
    }
    .menu li a { text-decoration: none; color: #333; display: block; }
    .menu li:hover, .menu li.active { background: #e6f2fb; border-radius: 10px; color: var(--primary-color); font-weight: bold; }

    /* Content */
    .content {
      margin-left: 260px;
      padding: 20px;
      flex: 1;
    }

    .content h2 { color: var(--primary-color); margin-top: 0; }

    /* Search bar */
    .search-container {
      display: flex;
      align-items: center;
      width: 320px;
      background: #fff;
      border: 1px solid var(--primary-color);
      border-radius: 25px;
      overflow: hidden;
    }
    .search-container input {
      flex: 1;
      border: none;
      outline: none;
      padding: 10px 14px;
      font-size: 14px;
      color: var(--text-dark);
    }
    .search-container button {
      background: var(--primary-color);
      color: white;
      border: none;
      padding: 10px 20px;
      cursor: pointer;
    }
    .search-container button:hover { background: #006699; }

    /* Table wrapper */
    .table-wrapper {
      width: 96%;
      margin: 20px auto;
      overflow-x: auto;
      background: #fff;
      box-shadow: 3px 0 8px rgba(0,0,0,0.1);
      padding: 10px;
      border-radius: 8px;
    }
    table {
      width: 100%;
      min-width: 900px;
      border-collapse: collapse;
      text-align: center;
    }
    th, td {
      padding: 12px;
      border: 1px solid #ddd;
    }
    th {
      background: var(--primary-color);
      color: white;
      position: sticky;
      top: 0;
      z-index: 2;
    }
    tbody tr:nth-child(even) { background: #f9f9f9; }
    tbody tr:hover { background: #eef7ff; }

    @media screen and (max-width: 768px) {
      .content { margin-left: 0; }
      .sidebar { display: none; }
      .table-wrapper { width: 100%; padding: 5px; }
      table { font-size: 12px; }
    }
  </style>
</head>
<body>


<header>
  <div class="logo"><i class="fa-solid fa-plane-departure"></i> Aurora</div>
  <div class="admin">Welcome: Admin</div>
</header>
<div class="admin-panel">

  <!-- Sidebar -->
  <aside class="sidebar">
    <h1>Admin Panel</h1>
     <ul class="menu">
        <li><a href="<%=request.getContextPath()%>/JSPView/manageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
        <li><a href=" <%=request.getContextPath()%>/JSPView/manageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageUserPayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
            <li class="active">
    <a  href="<%=request.getContextPath()%>/passengerInfoController"><i class="fa-solid fa-users"></i> Passenger Information</a>
</li>
<li><a href="<%=request.getContextPath()%>/JSPView/manageUserAcc.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/adminReplyMessage.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/mainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
      </ul>  </aside>

  <!-- Main Content -->
  <div class="content">
    <div class="content_title" style="display:flex; justify-content:space-between; align-items:center;">
      <h2>Manage Passenger Information</h2>
      <div class="search-container">
        <input type="text" id="searchInput" placeholder="Search here...">
        <button onclick="searchTable()"><i class="fa-solid fa-magnifying-glass"></i></button>
      </div>
    </div>

    <div class="table-wrapper">
      <table id="passengerTable" border="1">
    <thead>
      <tr>
        <th>ID</th>
        <th>Booking ID</th>
        <th>Full Name</th>
       <th>Gender</th>
		<th>Age</th>
        <th>Passport/NRC</th>
       <th>Ticket Number</th>
		
      </tr>
    </thead>
    <tbody>
 
      <%
      @SuppressWarnings("unchecked")
        List<Passenger> passengers = (List<Passenger>) request.getAttribute("passengerList");
        if (passengers != null && !passengers.isEmpty()) {
            for (Passenger p : passengers) {
      %>
        <tr>
          <td><%= p.getPassengerID() %></td>
			<td><%= p.getBookingID() %></td>
			<td><%= p.getFullName() %></td>
			<td><%= p.getGender() %></td>
			<td><%= p.getAge() %></td>
			<td><%= p.getPassportOrNRC() %></td>
			<td><%= (p.getTicketNumber() != null && !p.getTicketNumber().isEmpty()) ? p.getTicketNumber() : "N/A" %></td>
        </tr>
      <%
            }
        } else {
      %>
        <tr><td colspan="7">No passengers found.</td></tr>
      <%
        }
      %>
    </tbody>
  </table>
    </div>
  </div>
</div>

<script>
  function searchTable() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const rows = document.querySelectorAll("#passengerTable tbody tr");
    rows.forEach(row => {
      row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
  }
  
</script>

</body>
</html>
