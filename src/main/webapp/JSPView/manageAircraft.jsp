<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*,Model.Aircraft" %>
<%@ page import="DAO.aircraftDAO" %>
<% if(request.getAttribute("errorMessage") != null) { %>
    <div style="color: red; font-weight: bold; margin: 10px 0;">
        <%= request.getAttribute("errorMessage") %>
    </div>
<% } %>

<% if(request.getAttribute("successMessage") != null) { %>
    <div style="color: green; font-weight: bold; margin: 10px 0;">
        <%= request.getAttribute("successMessage") %>
    </div>
<% } %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Aurora Admin | Manage Aircraft</title> 
  
  <!-- External CSS -->
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
  <!-- FontAwesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        <li class="active"><a href=" <%=request.getContextPath()%>/JSPView/manageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
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
          
      <h2>Manage Aircraft</h2>
      <div class="content_title">
        <ul>
          <li ><a href="${pageContext.request.contextPath}/JSPView/addAircraft.jsp"><button class="btn btn-add">+ Add New Aircraft</button></a></li>
          <%-- Error message span --%>
       <span style="color:red; margin-left:10px;">
        <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
    </span>
    <!-- Show success message beside button -->
    <span style="color:green; margin-left:10px;">
        <%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "" %>
    </span>

         
       <li >   
          
            <div class="search-container">
              <form method="get" action="${pageContext.request.contextPath}/JSPView/manageAircraft.jsp">
                <input type="text" name="search" id="searchInput" placeholder="Search here..." value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
              </form>
            </div>
          </li>
        </ul>
      </div>

      <div class="table-wrapper">
        <table id="aircraftTable" class="aircraft-table">
          <thead>
            <tr>
              <th>Aircraft ID</th>
              <th>Model</th>
              <th>Seats</th>
              <th>Airline ID</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <%
            aircraftDAO dao = new aircraftDAO();
                          String search = request.getParameter("search");
                          List<Aircraft> aircrafts;
                          if(search != null && !search.isEmpty()) {
                              aircrafts = dao.getAllAircraft().stream()
                                             .filter(a -> a.getModel().toLowerCase().contains(search.toLowerCase()))
                                             .toList();
                          } else {
                              aircrafts = dao.getAllAircraft();
                          }

                          for(Aircraft a : aircrafts) {
            %>
            <tr>
              <td><%= a.getAircraftID() %></td>
              <td><%= a.getModel() %></td>
              <td><%= a.getTotalSeat() %></td>
              <td><%= a.getAirlineID() %></td>
              <td><%= a.getStatus() %></td>
              <td>
                <a href="${pageContext.request.contextPath}/aircraftController?action=view&id=<%= a.getAircraftID() %>" class="btn btn-view" style="text-decoration: none;">
                    <i class="fa-regular fa-eye"></i>
                </a>
                <a href="${pageContext.request.contextPath}/aircraftController?action=edit&id=<%= a.getAircraftID() %>" class="btn btn-edit" style="text-decoration: none;">
                    <i class="fa-regular fa-pen-to-square"></i>
                </a>
                <a href="${pageContext.request.contextPath}/aircraftController?action=delete&id=<%= a.getAircraftID() %>" class="btn btn-delete" style="text-decoration: none;" onclick="return confirm('Are you sure to delete this aircraft?');">
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
