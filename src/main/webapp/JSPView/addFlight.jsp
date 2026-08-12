<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Model.Flight" %>
<%@ page import="DAO.flightDAO" %>
<%@ page import="java.sql.*,java.util.*" %>
<%
// Database connection
    Connection conn = null;
    PreparedStatement psAirline = null, psAircraft = null;
    ResultSet rsAirline = null, rsAircraft = null;

    List<Map<String, String>> airlines = new ArrayList<>();
    List<Map<String, String>> aircrafts = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:2002/frms","root","thin"); // update DB credentials

        // Fetch Airlines
        psAirline = conn.prepareStatement("SELECT airlineID, name FROM Airline");
        rsAirline = psAirline.executeQuery();
        while(rsAirline.next()){
            Map<String,String> a = new HashMap<>();
            a.put("id", rsAirline.getString("airlineID"));
            a.put("name", rsAirline.getString("name"));
            a.put("seats", rsAircraft.getString("totalSeat"));
            airlines.add(a);
        }

        // Fetch Aircrafts
        psAircraft = conn.prepareStatement("SELECT aircraftID, model FROM Aircraft");
        rsAircraft = psAircraft.executeQuery();
        while(rsAircraft.next()){
            Map<String,String> a = new HashMap<>();
            a.put("id", rsAircraft.getString("aircraftID"));
            a.put("model", rsAircraft.getString("model"));
            aircrafts.add(a);
        }

    } catch(Exception e){ e.printStackTrace(); }
    
%>
<% if (request.getAttribute("errorMessage") != null) { %>
    <div style="color: red; font-weight: bold; margin: 10px 0;">
        <%= request.getAttribute("errorMessage") %>
    </div>
<% } %>

<% if (request.getAttribute("message") != null) { %>
    <div style="color: green; font-weight: bold; margin: 10px 0;">
        <%= request.getAttribute("message") %>
    </div>
<% } %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- FontAwesome for icons -->
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
  <!-- FontAwesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <title>Aurora Admin | Add Flight</title>
  <style>
  .modal {
  display: none; /* show with JS */
  position: fixed;
  top: 0; left: 0;
  width: 100%; height: 100%;
  background: rgba(0,0,0,0.6);
  justify-content: center;
    margin-top : 2rem;
  align-items: center;
  z-index: 100; /* table ၏အပေါ်မှာ */
}

.table-wrapper {
  margin-top: 20px; /* form/modal အောက် */
  background: #fff;
  padding: 10px;
  border-radius: 8px;
  overflow-x: auto;
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
         <li class="active"><a href="<%=request.getContextPath()%>/manageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
        <li><a href="<%=request.getContextPath()%>/manageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
        <li><a href="<%=request.getContextPath()%>/manageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li ><a href="<%=request.getContextPath()%>/manageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
        <li><a href="<%=request.getContextPath()%>/managePayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
         <li ><a href="<%=request.getContextPath()%>/passengerInfo.jsp"><i class="fa-solid fa-users"></i> Passenger Information</a></li>
        <li><a href="<%=request.getContextPath()%>/manageUserAccounts.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
        <li><a href="<%=request.getContextPath()%>/manageContactUser.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
  
        <li><a href="<%=request.getContextPath()%>/mainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
      </ul>
    </aside>
    
    <!-- Main content -->
    <div class="content">
      <h2>Manage Flights</h2>
      <div class="content_title">
        <ul>
          <li><a href="${pageContext.request.contextPath}/JSPView/addFlight.jsp"><button class="btn btn-add">+ Add New Flight</button></a></li>
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
<form action="${pageContext.request.contextPath}/flightController" method="post">
<input type="hidden" name="action" value="saveFlights"/>
  <div class="modal" id="flightModal">
    <div class="modal-content">
      <h3 id="modalTitle">Add Flight</h3>

      <div class="row">
        <div class="form-group">
          <label>Flight No.</label>
         
          <input type="text" name="flightNumber" id="flightNo" required>
        </div>
       
      </div>

      <div class="row">
        <div class="form-group">
          <label>Origin</label>
          <select id="origin" name="origin"required>
            <option value="">Select Origin</option>
            <option>Yangon</option>
            <option>Mandalay</option>
            <option>Naypyitaw</option>
            <option>Bagan</option>
            <option>Tacholeik</option>
          </select>
        </div>
        <div class="form-group">
          <label>Destination</label>
          <select id="destination" name="destination" required>
            <option value="">Select Destination</option>
            <option>Yangon</option>
            <option>Mandalay</option>
            <option>Naypyitaw</option>
            <option>Bagan</option>
            <option>Tacholeik</option>
          </select>
        </div>
      </div>



      <div class="row">
        <div class="form-group">
          <label>Departure</label>
			<input type="datetime-local" name="departureTime" required>
        </div>
        <div class="form-group">
          
			<label>Arrival</label>
				<input type="datetime-local" name="arrivalTime" required>
        </div>
      </div>

      <div class="row">
        <div class="form-group">
          <label>Price</label>
     <input type="number" name="price" id="price" required>
        </div>
        <div class="form-group">
          <label>Seats</label>
          <input type="number" id="seats" name="availableSeats" readonly>
        </div>
      </div>

       <div class="row">
              <div class="form-group">
    <label>Aircraft</label>
    <select name="aircraftID" id="aircraftSelect" required>
      <option value="">Select Aircraft Name</option>
      <% for(Map<String,String> a : aircrafts){ %>
          <option value="<%=a.get("id")%>" data-seats="<%=a.get("seats")%>">
              <%=a.get("model")%>
          </option>
      <% } %>
    </select>
</div>
              <div class="form-group">
                <label>Airline</label>
                <select name="airlineID" required>
                  <option value="">Select Airline Name</option>
                  <% for(Map<String,String> a : airlines){ %>
                      <option value="<%=a.get("id")%>"><%=a.get("name")%></option>
                  <% } %>
                </select>
              </div>
            </div>

   <button type="submit" class="btn btn-add">Save</button>
  <button type="button" class="btn btn-delete" onclick="goToManage()">Cancel</button>
    </div>
  </div>
</form>

<script>
  function save() { window.location.href = "JSPView/manageFlight.jsp"; }
  function goToManage() { window.location.href = "${pageContext.request.contextPath}/JSPView/manageFlight.jsp"; }

  window.onload = function() {
    document.getElementById("flightModal").style.display = "flex";
  }

  function search() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let rows = document.querySelectorAll("#flightTable tbody tr");
    rows.forEach(row => {
      let match = Array.from(row.cells).some(cell => cell.textContent.toLowerCase().includes(input));
      row.style.display = match ? "" : "none";
    });
  }
</script>
<script>
  window.onload = function() {
    document.getElementById("flightModal").style.display = "flex";

    const originSelect = document.getElementById("origin");
    const destinationSelect = document.getElementById("destination");

    originSelect.addEventListener("change", function() {
      const selectedOrigin = originSelect.value;

      // Destination options loop
      Array.from(destinationSelect.options).forEach(option => {
        if(option.value === selectedOrigin && selectedOrigin !== "") {
          option.disabled = true; // disable same as origin
        } else {
          option.disabled = false; // enable others
        }
      });
    });
  }

  function goToManage() { window.location.href = "${pageContext.request.contextPath}/JSPView/manageFlight.jsp"; }

  function search() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let rows = document.querySelectorAll("#flightTable tbody tr");
    rows.forEach(row => {
      let match = Array.from(row.cells).some(cell => cell.textContent.toLowerCase().includes(input));
      row.style.display = match ? "" : "none";
    });
  }
  
  
  document.addEventListener("DOMContentLoaded", function() {
	    const aircraftSelect = document.getElementById("aircraftSelect");
	    const seatsInput = document.getElementById("seats");

	    aircraftSelect.addEventListener("change", function() {
	        const selectedOption = aircraftSelect.options[aircraftSelect.selectedIndex];
	        const seats = selectedOption.getAttribute("data-seats");
	        seatsInput.value = seats ? seats : "";
	    });
	});
</script>
</body>
</html>
