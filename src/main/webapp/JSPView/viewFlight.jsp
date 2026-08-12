<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.*,Model.Flight" %>
<%@ page import="DAO.flightDAO" %>
<%@ page import="java.sql.*,java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- External CSS -->
      <link rel="stylesheet" href="style.css">
  
  <!-- FontAwesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  
  <title>Aurora Admin | View Flight</title>
  
  
  <style>
  :root {
  --primary-color: #004b75;
  --primary-color-dark:  #0369a1;
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
      color: #333;
    }
    header {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        padding: 20px 50px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #eee;
        z-index: 1000;  /* stays above other content */
      background:#004b75;
      color: white;
      padding: 2px;
      display: flex;
      font-size: 20px;
      font-weight: bold;
      position: fixed;
    }

    .navbar nav ul {
        display: flex;
        list-style: none;
        gap: 700px;
    }


    .container {
        padding-top: 60px;
    }
    .welcome {
        text-decoration: none;
        color: white;
        font-weight: 300;
        transition: color 0.3s;
        text-align: right;
    }
    .admin-panel {
      display: flex;
      height: calc(100vh - px);
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

    /* side bar menu */
    .menu {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    .menu li {
      padding: 10px 20px;
      margin : 5px;
      cursor: pointer;
      font-size: 15px;
    }

    .menu li a{
        text-decoration: none;
        color: #333;
    }
    
    .menu li:hover,
    .menu li.active {
      background: #e6f2fb;
      border-radius: 10px;
      color: #004b75;
      font-weight: bold;
    }
    /* Main content */
    .content {
      padding-left: 51vh;
      flex: 1;
      
    }
    .content h2 {
      margin-top: 0;
      color: #004b75;
    }

    /* Btton */
    .btn {
      padding: 8px 14px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 14px;
      margin: 3px;
      
    }
    .btn-add {
      background: #007bff;
      color: white;
      margin-bottom: 15px;
    }
    .btn-edit { background: #005f99; color: white; }
    .btn-delete { background: #dc3545; color: white; }
    .btn-view { background:  #2a52be; color: white; }
    


    
    /* content title */
      .search-container {
        display: flex;
        align-items: center;
        width: 300px;
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
        font-size: 14px;
        cursor: pointer;
        transition: background 0.3s;
        }

        .search-container button:hover {
        background: #006699;
        }

    .content_title ul {
        display: flex;
        justify-content: space-between; /* space between button & search */
        align-items: center;
        list-style: none;
        padding: 0;
        margin: 0;
        margin-right: 3%;
        gap: 20px; /* space between items */
    }
    
    .content h2{
    	margin-top : 20px;
    }
    /* table */
.table-wrapper {
  width: 100%;                 /* full width of parent */
  max-width: 100%;             /* prevent overflow */
  margin: 0 auto;              /* center wrapper itself */
  overflow-x: auto;            /* scroll horizontally if needed */
  overflow-y: auto;            /* scroll vertically if needed */
  background: #fff;
  box-shadow: 3px 0 8px rgba(0,0,0,0.1);
  padding: 10px;
  border-radius: 8px;
  display: flex;
  justify-content: center;     /* center the table */
}

.table-wrapper table {
  width: 100%;                 /* let table take available space */
  max-width: 1200px;           /* cap width for large screens */
  border-collapse: collapse;
  text-align: center;
}

.table-wrapper th, 
.table-wrapper td {
  padding: 12px;
  border: 1px solid #ddd;
  white-space: nowrap;         /* prevent text wrapping */
}

.table-wrapper {
	 margin-top: 10px; 
  width: 96%;
  height: 130%;
  background: #fff;
  box-shadow: 3px 0 8px rgba(0,0,0,0.1);
  padding: 10px;
  display: flex;             /* make flexbox */
  justify-content: center;   /* center horizontally */
}

.table-wrapper table {
  width: 90%;
  height: min-content;
  border-collapse: collapse;
  min-width: 900px;         /* keeps scroll if too narrow */
  text-align: center;
}


 .flight-table td {
  
  padding: 10px;
  text-align: center;
  border: 1px solid #ddd;
  white-space: nowrap;    /* prevent text wrapping */
}

/* Sticky header */
.flight-table thead th {
  position: sticky;
  top: 0;
  background-color: #004b75;
  color: #fff;
  z-index: 2;
}

/* Zebra rows */
.flight-table tbody tr:nth-child(even) {
  background: #f9f9f9;
}

.flight-table tbody tr:hover {
  background: #eef7ff;
}


    th, td {
      padding: 12px;
      border: 1px solid #ddd;
      text-align: center;
    }
    th {
      background: #004b75;
      color: white;
    }

    /* modal */
#modalTitle {
      text-align: center;
    }
    .modal {
      display: none;
      position: fixed;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(0,0,0,0.6);
      justify-content: center;
      align-items: center;
    }
    .modal-content {
      background: white;
      padding: 20px;
      border-radius: 8px;
      width: 300px;
    }
    .modal-content h3 {
      margin-top: 0;
      color: #004b75;
    }
    .form-group {
      margin-bottom: 10px;
    }
    .form-group label {
      display: block;
      font-size: 14px;
      margin-bottom: 5px;
    }
    .form-group input,
    .form-group select {
      width: 100%;
      padding: 7px;
      border: 1px solid #ccc;
      border-radius: 5px;
    }

    /* Style the select box */
    select {
      padding: 10px 14px;
      font-size: 14px;
      color: #004b75;
      border: 1px solid #004b75;
      border-radius: 6px;
      background-color: #fff;
      appearance: none;
      -webkit-appearance: none;
      -moz-appearance: none;
      background-image: url("data:image/svg+xml;utf8,<svg fill='%23004b75' height='24' viewBox='0 0 24 24' width='24' xmlns='http://www.w3.org/2000/svg'><path d='M7 10l5 5 5-5z'/></svg>");
      background-repeat: no-repeat;
      background-position: right 10px center;
      background-size: 18px;
      cursor: pointer;
    }

    select:hover, select:focus {
      border-color: #006699;
      outline: none;
    }

    option {
      padding: 10px;
      font-size: 14px;
      background: #fff;
      color: #004b75;
    }

    option:checked {
      background: #e6f2fb;
      font-weight: bold;
    }
    .table-wrapper {
  margin-top: 20px; /* form/modal အောက် */
  background: #fff;
  padding: 10px;
  border-radius: 8px;
  overflow-x: auto;
}
  
  .modal {
  display: none; /* show with JS */
  position: fixed;
  top: 0; left: 0;
  width: 100%; height: 100%;
  background: rgba(0,0,0,0.6);
  justify-content: center;
  align-items: center;
  margin-top : 2rem;
  z-index: 100; /* table ၏အပေါ်မှာ */
}


    .modal-content {
      background: #fff;
      border-radius: 10px;
    
      padding: 20px;
      width: 450px;
      max-width: 95%;
      box-sizing: border-box;
 }
    h3 {
      text-align: center;
      margin-bottom: 20px;
      color: #0073e6;
    }
    .row {
      display: flex;
      gap: 25px;
      flex-wrap: wrap;
      margin-bottom: 2px;
    
    }
    .form-group {
      flex: 1;
      display: flex;
      flex-direction: column;
        background-color : blue;
    }
    .form-group label {
      font-size: 13px;
      margin-bottom: 3px;
      color: #333;
    }
    .form-group input,
    .form-group select {
      padding: 6px 8px;
      font-size: 13px;
      border-radius: 5px;
      border: 1px solid #ccc;
    }
  
 .btn {
      padding: 8px 14px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 14px;
      margin: 3px;
      
    }
    .btn-add {
      background: #007bff;
      color: white;
      margin-bottom: 15px;
    }
    .btn-edit { background: #005f99; color: white; }
    .btn-delete { background: #dc3545; color: white; }
    .btn-view { background:  #2a52be; color: white; }

    .table-wrapper {
    width: 96%;                     /* container width */
    max-width: var(--max-width);    /* max width */
    margin: 20px auto;              /* center horizontally */
    padding: 10px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 3px 8px rgba(0,0,0,0.1);
    overflow-x: auto;               /* horizontal scroll if too wide */
    overflow-y: auto;               /* vertical scroll if needed */
}

/* Table inside wrapper */
.table-wrapper table {
    width: 100%;
    min-width: 900px;               /* force scroll if too narrow */
    border-collapse: collapse;
    text-align: center;
    background: #fff;               /* table background */
    box-shadow: inset 0 0 0 #ddd;
   
}

/* Table header */
.table-wrapper th {
    background-color: var(--primary-color);
    color: white;
    padding: 12px;
    position: sticky;
    top: 0;
    z-index: 2;
}

/* Table cells */
.table-wrapper td {
    padding: 12px;
    border: 1px solid #ddd;
}

/* Zebra rows */
.table-wrapper tbody tr:nth-child(even) {
    background: #f9f9f9;
}

/* Hover effect */
.table-wrapper tbody tr:hover {
    background: #eef7ff;
}

/* Responsive */
@media screen and (max-width: 768px) {
    .table-wrapper {
        width: 100%;
        padding: 5px;
    }
    .table-wrapper table {
        font-size: 12px;
    }
}
.search-container {
        display: flex;
        align-items: center;
        width: 300px;
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
        font-size: 14px;
        cursor: pointer;
        transition: background 0.3s;
        }

        .search-container button:hover {
        background: #006699;
        }

    .content_title ul {
        display: flex;
        justify-content: space-between; /* space between button & search */
        align-items: center;
        list-style: none;
        padding: 0;
        margin: 0;
        margin-right: 3%;
        gap: 20px; /* space between items */
        
        }
        .details-grid{
        	margin-top : 20px;
        }
        .details-grid div{
        	padding:5px;
        	
        	
        }
    
</style>
    
</head>
<body>

<header class="navbar">
  <nav>
    <ul>
      <li class="logo"><i class="fa-solid fa-plane-departure"></i> Aurora</li>
      <li class="welcome">Welcome: Admin</li>
    </ul>
  </nav>
</header>

<div class="container">
  <div class="admin-panel">
    
    <!-- Sidebar -->
    <aside class="sidebar">
      <h1>Admin Panel</h1> 
      <ul class="menu">
        <li class="active"><a href="manageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
        <li><a href="manageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
        <li><a href="manageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li><a href="manageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
        <li><a href="managePayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
        <li><a href="managePassengers.jsp"><i class="fa-solid fa-users"></i> Passengers Info</a></li>
        <li><a href="manageUserAccounts.jsp"><i class="fa-solid fa-address-card"></i> Manage Users</a></li>
        <li><a href="manageContactUser.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
        <li><a href="MainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
      </ul>
    </aside>
    
    <!-- Main content -->
    <div class="content">
      <h2>Manage Flights</h2>
      <div class="content_title">
        <ul>
          <li><a href="addFlight.jsp"><button class="btn btn-add">+ Add New Flight</button></a></li>
          <li>
            <div class="search-container">
                <input type="text" name="search" placeholder="Search here..." value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
              
            </div>
          </li>
        </ul>
      </div>

      <div class="table-wrapper">
        <table id="flightTable" class="flight-table">
          <thead>
            <tr>
              <th>Flight ID</th>
              <th>Flight No.</th>
              <th>Origin</th>
              <th>Destination</th>
              <th>Price</th>
              <th>Seats</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <%
            flightDAO flightDAO = new flightDAO();
                                                  String search = request.getParameter("search");
                                                  List<Flight> flights;
                                                  if(search != null && !search.isEmpty()) {
                                                      flights = flightDAO.searchFlights(search);
                                                  } else {
                                                      flights = flightDAO.getAllFlights();
                                                  }

                                                  for(Flight f : flights) {
            %>
            <tr>
              <td><%= f.getFlightID() %></td>
              <td><%= f.getFlightNumber() %></td>
              <td><%= f.getOrigin() %></td>
              <td><%= f.getDestination() %></td>
              <td><%= f.getPrice() %></td>
              <td><%= f.getAvailableSeats() %></td>
              <td>
                <a href="viewFlight.jsp?id=<%= f.getFlightID() %>" class="btn btn-view"><i class="fa-regular fa-eye"></i></a>
                <a href="editFlight.jsp?id=<%= f.getFlightID() %>" class="btn btn-edit"><i class="fa-regular fa-pen-to-square"></i></a>
                <a href="deleteFlight?id=<%= f.getFlightID() %>" class="btn btn-delete" onclick="return confirm('Are you sure to delete this flight?');"><i class="fa-solid fa-trash"></i></a>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<!-- Add/Edit Modal -->
<div class="modal" id="flightModal">
  <div class="modal-content">
    <h3 id="modalTitle">Flight Details</h3>
          <%
    Flight f = (Flight) request.getAttribute("flight");
%>
    <div class="details-grid">
  <div><strong>Flight ID:</strong> <%= f.getFlightID() %></div>
  <div><strong>Flight No:</strong> <%= f.getFlightNumber() %></div>
  <div><strong>Origin:</strong> <%= f.getOrigin() %></div>
  <div><strong>Destination:</strong> <%= f.getDestination() %></div>
  <div><strong>Departure:</strong> <%= f.getDepartureTime() %></div>
  <div><strong>Arrival:</strong> <%= f.getArrivalTime() %></div>
  <div><strong>Price:</strong> $<%= f.getPrice() %></div>
  <div><strong>Seat:</strong> <%= f.getAvailableSeats() %></div>
  <div><strong>Aircraft:</strong> <%= f.getAircraftModel() %></div>
  <div><strong>Airline:</strong> <%= f.getAirlineName() %></div>
  <div><strong>Created At:</strong> <%= f.getDepartureTime() %></div>
  <div><strong>Updated At:</strong> <%= f.getArrivalTime() %></div>
</div>

    <div class="modal-footer">
      <button type="button" class="btn btn-delete" onclick="view()">Close</button>
    </div>
  </div>
</div>

<script>
  function view() {
    window.location.href = "JSPView/manageFlight.jsp";
  }

  function goToManage() {
    window.location.href = "JSPView/manageAirline.jsp";
  }

  // open modal on page load 
  window.onload = function() {
    document.getElementById("flightModal").style.display = "flex";
  }
</script>

</body>
</html>
