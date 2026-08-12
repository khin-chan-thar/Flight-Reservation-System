
  
  <%@ page import="java.util.*,DAO.airlineDAO,Model.Airline" %>
<%
    airlineDAO dao = new airlineDAO();
    List<Airline> list = dao.listAirlines();

    String action = request.getParameter("action");
    Airline airline = new Airline();
    if ("update".equals(action) || "view".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        airline = dao.getAirlineById(id);
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <title>Aurora Admin | Manage Airline</title>
</head>
<body>

<header class="navbar">
  <nav>
    <ul>
      <li class="logo"><i class="fa-solid fa-plane-departure"></i> Aurora</li>
      <li class="welcome">Welcome :</li>
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
        <li class="active"><a href="ManageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
        <li><a href="ManageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li><a href="ManageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
        <li><a href="ManagePayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
        <li><a href="ManagePassengers.jsp"><i class="fa-solid fa-users"></i> Passengers Information</a></li>
        <li><a href="manageUserAcc.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
        <li><a href="adminReplyMessage.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
        <li><a href="MainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
      </ul>
    </aside>

    <!-- Main content -->
    <div class="content">
      <h2>Manage Airlines</h2>

      <div class="content_title">
        <ul>
          <li><a href="ManageAirline.jsp?action=add"><button class="btn btn-add">+ Add New Airline</button></a></li>
          <li>
            <div class="search-container">
              <input type="text" id="searchInput" placeholder="Search here...">
              <button onclick="search()"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
          </li>
        </ul>
      </div>

      <div class="table-wrapper">
        <table id="airlineTable">
          <thead>
            <tr>
              <th>Airline ID</th>
              <th>Name</th>
              <th>Code</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <% for(Airline a : list){ %>
              <tr>
                <td><%=a.getAirlineID()%></td>
                <td><%=a.getName()%></td>
                <td><%=a.getCode()%></td>
                <td><%=a.getStatus()%></td>
                <td>
                  <a href="ManageAirline.jsp?action=view&id=<%= a.getAirlineID() %>" class="btn btn-view"><i class="fa-regular fa-eye"></i></a>
                  <a href="ManageAirline.jsp?action=update&id=<%= a.getAirlineID() %>" class="btn btn-edit"><i class="fa-regular fa-pen-to-square"></i></a>
                  <form action="/FlightReservationSystem/airlineController" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="<%=a.getAirlineID()%>"/>
                    <button type="submit" class="btn btn-delete" onclick="return confirm('Are you sure?');"><i class="fa-solid fa-trash"></i></button>
                  </form>
                </td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>


    <!-- Modal for add/update/view -->
    <% if (action != null) { %>
    <div class="modal" id="airlineModal" style="display:flex; justify-content:center; align-items:center;">
      <div class="modal-content">
        <h3>
          <%= "add".equals(action) ? "Add New Airline" : ("update".equals(action) ? "Update Airline" : "View Airline") %>
        </h3>

        <% if ("view".equals(action)) { %>
          <p><strong>Airline ID:</strong> <%= airline.getAirlineID() %></p>
          <p><strong>Name:</strong> <%= airline.getName() %></p>
          <p><strong>Code:</strong> <%= airline.getCode() %></p>
         
          <p><strong>Status:</strong> <%= airline.getStatus() %></p>
          <button class="btn btn-delete" onclick="closeModal()">Close</button>
        <% } else { %>
  <!-- Form with validation -->

  <% String error = (String) request.getParameter("error"); %>
  <% if (error != null) { %>
      <p style="color:red; font-weight:bold; text-align:center;"><%= error %></p>
  <% } %>

  <form action="/FlightReservationSystem/airlineController" method="post">
    <input type="hidden" name="action" value="<%= action %>"/>
    <% if ("update".equals(action)) { %>
      <input type="hidden" name="id" value="<%= airline.getAirlineID() %>"/>
    <% } %>

    <div class="form-group">
      <label>Name</label>
      <input type="text" name="name" 
             value="<%= airline.getName() != null ? airline.getName().trim() : "" %>" 
             minlength="3" maxlength="50" required>
    </div>
    <div class="form-group">
      <label>Code</label>
      <input type="text" name="code" 
             value="<%= airline.getCode() != null ? airline.getCode().trim() : "" %>" 
             pattern="[A-Z]{2,3}" 
             title="Code must be 2–3 uppercase letters (e.g. UA, SIA)" required>
    </div>
   
    <div class="form-group">
      <label>Status</label>
      <select name="status" required>
        <option value="Active" <%= "Active".equals(airline.getStatus()) ? "selected" : "" %>>Active</option>
        <option value="Inactive" <%= "Inactive".equals(airline.getStatus()) ? "selected" : "" %>>Inactive</option>
      </select>
    </div>

    <button type="submit" class="btn btn-add"><%= "add".equals(action) ? "Add Airline" : "Update Airline" %></button>
    <button type="button" class="btn btn-delete" onclick="closeModal()">Cancel</button>
  </form>
<% } %>

      </div>
    </div>
    <% } %>

  </div>
</div>

<script>
  function closeModal() {
    window.location.href = "manageAirline.jsp";
  }
</script>

</body>
</html>
  