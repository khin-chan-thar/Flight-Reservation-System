<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>

<%
    // Database connection
    Connection conn = null;
    PreparedStatement psAirline = null, psAircraft = null;
    ResultSet rsAirline = null, rsAircraft = null;

    List<Map<String,String>> airlines = new ArrayList<>();
    List<Map<String,String>> aircrafts = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:2002/frms","root","thin");

        // Fetch Airlines
        psAirline = conn.prepareStatement("SELECT airlineID, name FROM Airline");
        rsAirline = psAirline.executeQuery();
        while(rsAirline.next()){
            Map<String,String> a = new HashMap<>();
            a.put("id", rsAirline.getString("airlineID"));
            a.put("name", rsAirline.getString("name"));
            airlines.add(a);
        }

        // Fetch Aircrafts
        psAircraft = conn.prepareStatement("SELECT aircraftID, model, totalSeat, status FROM Aircraft");
        rsAircraft = psAircraft.executeQuery();
        while(rsAircraft.next()){
            Map<String,String> ac = new HashMap<>();
            ac.put("id", rsAircraft.getString("aircraftID"));
            ac.put("model", rsAircraft.getString("model"));
            ac.put("seats", rsAircraft.getString("totalSeat"));
            ac.put("status", rsAircraft.getString("status"));
            aircrafts.add(ac);
        }
    } catch(Exception e){
        e.printStackTrace();
    } finally {
        if(rsAirline != null) rsAirline.close();
        if(rsAircraft != null) rsAircraft.close();
        if(psAirline != null) psAirline.close();
        if(psAircraft != null) psAircraft.close();
        if(conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- External CSS -->
  <link rel="stylesheet" href="style.css">
  

  <!-- FontAwesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  
  <title>Aurora Admin | Add Aircraft</title>
  <style>
  .modal {
  display: none; /* show with JS */
  position: fixed;
  top: 0; left: 0;
  width: 100%; height: 100%;
  background: rgba(0,0,0,0.6);
  justify-content: center;
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
      <li class="logo">
        <i class="fa-solid fa-plane-departure"></i> Aurora
      </li>
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
        <li class="active"><a href="<%=request.getContextPath()%>/JSPView/manageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li ><a href="<%=request.getContextPath()%>/JSPView/manageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/managePayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
         <li ><a href="<%=request.getContextPath()%>/JSPView/passengerInfo.jsp"><i class="fa-solid fa-users"></i> Passenger Information</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageUserAccounts.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageContactUser.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
  
        <li><a href="<%=request.getContextPath()%>/JSPView/mainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
    </ul>
  </aside>

  <!-- Main content -->
  <div class="content">
    <h2>Manage Aircraft</h2>
    <div class="content_title">
        <ul>
            <li><button class="btn btn-add" onclick="openModal()">+ Add New Aircraft</button></li>
            <li>
                <div class="search-container">
                    <input type="text" id="searchInput" placeholder="Search here...">
                    <button onclick="search()"><i class="fa-solid fa-magnifying-glass"></i></button>
                </div>
            </li>
        </ul>
    </div>

    <!-- Aircraft Table -->
    <div class="table-wrapper">
      <table id="aircraftTable" class="aircraft-table">
        <thead>
          <tr>
            <th>Aircraft ID</th>
            <th>Model</th>
            <th>Seats</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
  <% for(Map<String,String> ac : aircrafts){ %>
    <tr>
      <td><%= ac.get("id") %></td>
      <td><%= ac.get("model") %></td>
      <td><%= ac.get("seats") %></td>
      <td><%= ac.get("status") %></td>
      <td>
    <a href="viewAircraft.jsp?id=<%= ac.get("id") %>" class="btn btn-view">
          <i class="fa-regular fa-eye"></i>
        </a>
        <a href="editAircraft.jsp?id=<%= ac.get("id") %>" class="btn btn-edit">
          <i class="fa-regular fa-pen-to-square"></i>
        </a>
        <a href="deleteAircraft?id=<%= ac.get("id") %>" class="btn btn-delete" 
           onclick="return confirm('Are you sure you want to delete this aircraft?');">
          <i class="fa-solid fa-trash"></i>
        </a>  
      </td>
    </tr>
  <% } %>
</tbody>
        
      </table>
    </div>
  </div>
</div>
</div>

<!-- Add/Edit Aircraft Modal -->
<div class="modal" id="flightModal">
  <div class="modal-content">
    <h3 id="modalTitle">Add Aircraft</h3>
    <form action="${pageContext.request.contextPath}/aircraftController" method="post">
      <div class="form-group">
        <label>Aircraft Model</label>
        <input type="text" name="model" required>
      </div>
      <div class="form-group">
        <label>Seats</label>
        <input type="number" name="totalSeat" required>
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
      <div class="form-group">
        <label>Status</label>
        <select name="status" required>
          <option value="">Select Status</option>
          <option value="Active">Active</option>
          <option value="Disabled">Disabled</option>
          <option value="Suspended">Suspended</option>
          <option value="Closed">Closed</option>
        </select>
      </div>
      <div class="form-buttons">
        <button type="submit" class="btn btn-add">Save</button>
          <a href="manageAircraft.jsp" class="btn btn-delete">Cancel</a>
      </div>
    </form>
  </div>
</div>

<script>
function openModal() {
  document.getElementById("flightModal").style.display = "flex";
}

function closeModal() {
  document.getElementById("flightModal").style.display = "none";
}

// Open modal on page load
window.onload = function() {
  openModal();
};
</script>

</body>
</html>
