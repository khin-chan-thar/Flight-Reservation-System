<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*,Model.Flight" %>
<%@ page import="DAO.flightDAO" %>

<% if(request.getAttribute("errorMessage") != null) { %>
    <div style="color: red; font-weight: bold; margin: 10px 0;">
        <%= request.getAttribute("errorMessage") %>
    </div>
<% } %>

<% if(request.getParameter("success") != null) { %>
    <div style="color: green; font-weight: bold; margin: 10px 0;">
        Flight saved successfully!
    </div>
<% } %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Aurora Admin | Manage Flight</title>
  
  <!-- External CSS -->
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/style.css">
  <!-- FontAwesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  
  <style>
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
      padding: 25px;
      margin-top: 0;
      font-size: 18px;
      color: #004b75;
      text-align: center;
      padding: 20px 20px;
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
    
     .container {
        padding-top: 60px;
    }
    
       .content h2{
    	margin-top : 20px;
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
  margin-top: 10px; /* form/modal အောက် */
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
    .button-row {
      display: flex;
      justify-content: flex-end;
      gap: 20px;
      margin-top: 10px;
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

     .search-container button{
        background-color: #004b75;color: white;
        border: none;
        padding: 10px 20px;
        font-size: 20px;
        cursor: pointer; 
        border-radius: 0 25px 25px 0; 
        margin-left: 30px;
        transition: background 0.3s;}

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
        <li class="active"><a href="<%=request.getContextPath()%>/JSPView/manageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
        <li><a href=" <%=request.getContextPath()%>/JSPView/manageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
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
      <h2>Manage Flight</h2>
      <div class="content_title">
        <ul>
          <li ><a href="${pageContext.request.contextPath}/JSPView/addFlight.jsp"><button class="btn btn-add">+ Add New Flight</button></a></li>
          <%-- Error message span --%>
                    <span style="min-width: 100px; line-height: 0.5;">
<%
    if(request.getAttribute("errorMessage") != null){
%>
    <span style="color: red;"><%= request.getAttribute("errorMessage") %></span>
<%
    } else if(request.getAttribute("successMessage") != null){
%>
    <span style="color: green;"><%= request.getAttribute("successMessage") %></span>
<%
    }
%>
</span>
         
       <li >   
          
            <div class="search-container" style="height: 40px;">
              <form method="get" action="<%=request.getContextPath()%>/JSPView/manageFlight.jsp">
                <input type="text" name="search" id="searchInput" placeholder="Search here..." value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">
                <button type="submit" style="height: 60px;"><i class="fa-solid fa-magnifying-glass"></i></button>
              </form>
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
    <a href="${pageContext.request.contextPath}/flightController?action=view&id=<%= f.getFlightID() %>" class="btn btn-view" style="text-decoration: none;">
        <i class="fa-regular fa-eye"></i>
    </a>
    <a href="${pageContext.request.contextPath}/flightController?action=edit&id=<%= f.getFlightID() %>" class="btn btn-edit" style="text-decoration: none;">
        <i class="fa-regular fa-pen-to-square"></i>
    </a>
    <a href="${pageContext.request.contextPath}/flightController?action=delete&id=<%= f.getFlightID() %>" class="btn btn-delete" style="text-decoration: none;"
       onclick="return confirm('Are you sure to delete this flight?');">
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

</body>
</html>
