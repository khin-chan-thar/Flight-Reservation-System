 <%@ page import="java.util.*, DAO.userDAO, Model.User" %>
<%
    userDAO dao = new userDAO();
    List<User> list = dao.getAllUsers();
    String action = request.getParameter("action");
    User user = new User();
    if ("update".equals(action) || "view".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        user = dao.getUserById(id);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <title>Aurora Admin | Manage User Accounts</title>
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
          <li><a href="ManageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
          <li><a href="ManageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
          <li><a href="ManageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
          <li><a href="ManagePayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
          <li><a href="ManagePassengers.jsp"><i class="fa-solid fa-users"></i> Passengers Information</a></li>
          <li class="active"><a href="manageUserAcc.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
          <li><a href="ManageContactUser.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
          <li><a href="MainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
        </ul>
      </aside>

      <!-- Main content -->
      <div class="content">
        <h2>Manage User Accounts</h2>
        <div class="content_title">
          <ul>
            <li></li>
            <li>
              <div class="search-container">
                <input type="text" id="searchInput" placeholder="Search here...">
                <button onclick="search()"><i class="fa-solid fa-magnifying-glass"></i></button>
              </div>
            </li>
          </ul>
        </div>

        <!-- Table -->
        <div class="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>User ID</th>
                <th>User Name</th>
                <th>Email</th>
                <th>PhoneNumber</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <% for(User u : list){ %>
              <tr>
                <td><%= u.getUserID() %></td>
                <td><%= u.getFullName() %></td>
                <td><%= u.getEmail() %></td>
                <td><%=u.getPhoneNumber()%></td>
                <td><%= u.getStatus() %></td>
                <td>
                  <a href="manageUserAcc.jsp?action=view&id=<%= u.getUserID() %>" class="btn btn-view"><i class="fa-regular fa-eye"></i></a>
        
                  <form action="/FlightReservationSystem/userController" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="<%= u.getUserID() %>"/>
                    <button type="submit" class="btn btn-delete" onclick="return confirm('Are you sure?');"><i class="fa-solid fa-trash"></i></button>
                  </form>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Modal (Add/Update/View) -->
      <% if (action != null) { %>
  
     <div class="modal" id="userModal" style="display:flex;">
        <div class="modal-content">
          <h3>
            <%= "add".equals(action) ? "Add New User" : ("update".equals(action) ? "Update User" : "View User") %>
          </h3>
          <% if ("view".equals(action)) { %>
            <p><strong>User ID:</strong> <%= user.getUserID() %></p>
            <p><strong>Name:</strong> <%= user.getFullName() %></p>
            <p><strong>Email:</strong> <%= user.getEmail() %></p>
            <p><strong>Status:</strong> <%= user.getStatus() ? "Active" : "Inactive" %></p>
            
            <button class="btn btn-delete" onclick="closeModal()">Close</button>
          <% } else { %>
            <form action="/FlightReservationSystem/userController" method="post">
              <input type="hidden" name="action" value="<%= action %>"/>
              <% if ("update".equals(action)) { %>
                <input type="hidden" name="id" value="<%= user.getUserID() %>"/>
              <% } %>
              <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" value="<%= user.getFullName() != null ? user.getFullName() : "" %>" required>
              </div>
              <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required>
              </div>
              <div class="form-group">
                <label>Status</label>
                <input type="text" name="status" value="<%= user.getStatus() != false ? user.getStatus() : "Active" %>" required>
              </div>
              <button type="submit" class="btn btn-add"><%= "add".equals(action) ? "Add User" : "Update User" %></button>
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
      window.location.href = "manageUserAcc.jsp";
    }
  </script>
</body>
</html>
 