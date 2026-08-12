<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
    import="java.sql.*, java.util.*,Model.Aircraft,DAO.aircraftDAO" %>
<%
    String id = request.getParameter("id");
    Aircraft aircraft = null;

    List<Map<String,String>> aircrafts = new ArrayList<>();

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:2002/frms","root","thin");

        // Fetch all aircrafts for table
        String sqlAll = "SELECT ac.aircraftID, ac.model, ac.totalSeat, ac.status, al.name AS airlineName, ac.createdAt, ac.updatedAt " +
                        "FROM Aircraft ac LEFT JOIN Airline al ON ac.airlineID = al.airlineID ORDER BY ac.aircraftID DESC";
        pst = conn.prepareStatement(sqlAll);
        rs = pst.executeQuery();

        while(rs.next()){
            Map<String,String> ac = new HashMap<>();
            ac.put("id", rs.getString("aircraftID"));
            ac.put("model", rs.getString("model"));
            ac.put("seats", rs.getString("totalSeat"));
            ac.put("status", rs.getString("status"));
            ac.put("airlineName", rs.getString("airlineName"));
            ac.put("createdAt", rs.getString("createdAt"));
            ac.put("updatedAt", rs.getString("updatedAt"));
            aircrafts.add(ac);

            // If id matches, store in Aircraft object for modal
            if(id != null && id.equals(rs.getString("aircraftID"))){
                aircraft = new Aircraft();
                aircraft.setAircraftID(rs.getInt("aircraftID"));
                aircraft.setModel(rs.getString("model"));
                aircraft.setTotalSeat(rs.getInt("totalSeat"));
                aircraft.setStatus(rs.getString("status"));
                aircraft.setAirlineName(rs.getString("airlineName"));
                aircraft.setCreatedAt(rs.getTimestamp("createdAt"));
                aircraft.setUpdatedAt(rs.getTimestamp("updatedAt"));
            }
        }

    } catch(Exception e){
        e.printStackTrace();
    } finally {
        try { if(rs != null) rs.close(); if(pst != null) pst.close(); if(conn != null) conn.close(); } 
        catch(Exception ex){ ex.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- External CSS -->
  <link rel="stylesheet" href="css/style.css">

  <!-- FontAwesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <title>Aurora Admin | Add Aircraft</title>
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
      <li><a href="ManageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
      <li><a href="ManageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
      <li class="active"><a href="ManageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
      <li><a href="ManageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
      <li><a href="ManagePayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
      <li><a href="ManagePassengers.jsp"><i class="fa-solid fa-users"></i> Passengers Information</a></li>
      <li><a href="ManageUserAccounts.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
      <li><a href="ManageContactUser.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
      <li><a href="MainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
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

<div class="modal" id="flightModal">
  <div class="modal-content">
    <h3>Aircraft Details</h3>
    <% if(aircraft != null){ %>
      <p><strong>Aircraft ID:</strong> <%= aircraft.getAircraftID() %></p>
      <p><strong>Model:</strong> <%= aircraft.getModel() %></p>
      <p><strong>Seats:</strong> <%= aircraft.getTotalSeat() %></p>
      <p><strong>Airline:</strong> <%= aircraft.getAirlineName() %></p>
      <p><strong>Status:</strong> <%= aircraft.getStatus() %></p>
       <p><strong>Created At:</strong> <%= aircraft.getCreatedAt() %></p>
  <p><strong>Updated At:</strong> <%= aircraft.getUpdatedAt() %></p>
    <% } else { %>
      <p>No aircraft selected.</p>
    <% } %>
    <button class="btn btn-delete" onclick="goBack()">Close</button>
  </div>
   
</div>

<script>
  // Show modal if aircraft is selected
  window.onload = function() {
    <% if(aircraft != null){ %>
      document.getElementById("flightModal").style.display = "flex";
    <% } %>
  }
  function goBack(){ window.location.href="JSPView/manageAircraft.jsp"; }
</script>

</body>
</html>
