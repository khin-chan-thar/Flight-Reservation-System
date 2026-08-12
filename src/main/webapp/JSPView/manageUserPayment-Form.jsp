<%@ page import="java.util.*, DAO.paymentDAO, Model.Payment" %>
<%
    paymentDAO dao = new paymentDAO();
    List<Payment> list = dao.getAllPayments(); // fetch all payments
   
    String action = request.getParameter("action");
    Payment payment = new Payment();
    Payment payment1 = new Payment();
    if ("view".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        payment = dao.getPaymentById(id);
        payment1 = dao.getPaymentById1(id);
        //List<UserPayment> userPayments = dao.listPaymentsByUserId(id);
        
       // payment.setFullName(payment.getFullName());
       
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <title>Aurora Admin | Manage User Payments</title>
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
        <li><a href="ManageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
        <li><a href="ManageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
        <li><a href="ManageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li><a href="ManageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
        <li class="active"><a href="ManageUserPayment.jsp"><i class="fa-solid fa-ticket"></i> Manage User Payments</a></li>
        <li><a href="ManagePassengers.jsp"><i class="fa-solid fa-users"></i> Passengers Information</a></li>
        <li><a href="manageUserAcc.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
        <li><a href="ManageContactUser.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
        <li><a href="MainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
      </ul>
    </aside>

    <!-- Main content -->
    <div class="content">
      <h2>Manage User Payments</h2>
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

      <!-- Payment Table -->
      <div class="table-wrapper">
        <table>
          <thead>
            <tr>
              <th>Payment ID</th>
              <th>Booking Code</th>
              <th>User</th>
              <th>Amount</th>
              <th>Method</th>
              <th>Transaction ID</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <% for(Payment p : list) { %>
              <tr>
                <td><%= p.getPaymentID() %></td>
                <td><%= p.getBookingCode() %></td>
                <td><%= p.getFullName() %></td>
                <td><%= p.getAmount() %></td>
                <td><%= p.getPaymentMethod() %></td>
                <td><%= p.getTransactionID() %></td>
                <td><%= p.getStatus() %></td>
                <td>
                  <a href="ManageUserPayment.jsp?action=view&id=<%= p.getPaymentID() %>" class="btn btn-view"><i class="fa-regular fa-eye"></i></a>

                  <% if("Pending".equalsIgnoreCase(p.getStatus())) { %>
                    <form action="/FlightReservationSystem/userPaymentController" method="post" style="display:inline;">
                      <input type="hidden" name="action" value="approve"/>
                      <input type="hidden" name="id" value="<%= p.getPaymentID() %>"/>
                      <button type="submit" class="btn btn-approve"><i class="fa-solid fa-check"></i></button>
                    </form>
                    <form action="/FlightReservationSystem/userPaymentController" method="post" style="display:inline;">
                      <input type="hidden" name="action" value="reject"/>
                      <input type="hidden" name="id" value="<%= p.getPaymentID() %>"/>
                      <button type="submit" class="btn btn-reject"><i class="fa-solid fa-xmark"></i></button>
                    </form>
                  <% } %>
                </td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>

      <!-- Modal for View -->
      <% if ("view".equals(action)) { %>
        
        <div class="modal" id="paymentModal" style="display:flex;">
          <div class="modal-content">
            <h3>View Payment</h3>
            <p><strong>Payment ID:</strong> <%= payment.getPaymentID() %></p>
            <p><strong>Booking ID:</strong> <%= payment.getBookingID() %></p>
             <p><strong>User:</strong> <%= payment1.getFullName() %></p>
            <p><strong>User ID:</strong> <%= payment.getUserID() %></p>
            <p><strong>Amount:</strong> <%= payment.getAmount() %></p>
            <p><strong>Method:</strong> <%= payment.getPaymentMethod() %></p>
            <p><strong>Status:</strong> <%= payment.getStatus() %></p>
            <p><strong>Payment Date:</strong> <%= payment.getPaymentDate() != null ? payment.getPaymentDate() : "N/A" %></p>
            <button class="btn btn-delete" onclick="closeModal()">Close</button>
          </div>
        </div>
       
      <% } %>

    </div>
  </div>
</div>

<script>
function closeModal() {
  window.location.href = "manageUserPayment.jsp";
}

function search() {
  const input = document.getElementById("searchInput").value.toLowerCase();
  const rows = document.querySelectorAll("table tbody tr");
  rows.forEach(row => {
    row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
  });
}
</script>
</body>
</html>
