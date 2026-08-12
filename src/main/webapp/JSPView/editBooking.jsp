<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.sql.Timestamp,DAO.flightDAO,DAO.bookingDAO,Model.Booking,Model.Flight" %>
 <%@ page import="java.util.*,Model.Booking,DAO.bookingDAO" %>

<%
String bookingIDStr = request.getParameter("bookingID");
Booking booking = null;

if (bookingIDStr != null) {
    int bookingID = Integer.parseInt(bookingIDStr);
    bookingDAO bookingDao = new bookingDAO();
    booking = bookingDao.getBookingByID(bookingID);
}

// Check if form is submitted
String action = request.getParameter("action");

    if ("update".equals(action) && booking != null) {
        int newFlightID = Integer.parseInt(request.getParameter("flightID"));

        bookingDAO dao = new bookingDAO();
        if (dao.updateBookingFlight(booking.getBookingID(), newFlightID)) {
            response.sendRedirect("manageBooking.jsp");
        } else {
            out.println("<p style='color:red'>Update failed!</p>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- FontAwesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" type="text/css" href="style.css">
<title>Aurora Admin | Edit Booking</title>
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

/* Body and Header */
body {
  margin: 0;
  font-family: Arial, sans-serif;
  background: var(--extra-light);
  color: var(--text-dark);
}

header.navbar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background: var(--primary-color);
  color: var(--white);
  padding: 10px 50px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 20px;
  font-weight: bold;
  z-index: 1000;
}

header.navbar ul {
  display: flex;
  list-style: none;
  gap: 700px;
  margin: 0;
  padding: 0;
}

header.navbar .welcome {
  font-weight: 300;
  text-align: right;
}

/* Container */
.container {
  padding-top: 80px;
}

.admin-panel {
  display: flex;
}

/* Sidebar */
.sidebar {
  width: 250px;
  background: var(--white);
  box-shadow: 3px 0 8px rgba(0,0,0,0.1);
  padding: 20px 10px;
  margin-left: 20px;
  border-radius: 12px;
  position: fixed;
}

.sidebar h1 {
  text-align: center;
  color: var(--primary-color);
  font-size: 18px;
  margin-bottom: 20px;
}

.menu {
  list-style: none;
  padding: 0;
  margin: 0;
}

.menu li {
  padding: 12px 20px;
}

.menu li a {
  text-decoration: none;
  color: var(--text-dark);
}

.menu li:hover,
.menu li.active {
  background: #e6f2fb;
  border-radius: 10px;
  color: var(--primary-color);
  font-weight: bold;
}

/* Content */
.content {
  flex: 1;
  padding-left: 51vh;
}

.content_title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-right: 3%;
  gap: 20px;
}

.search-container {
  display: flex;
  align-items: center;
  width: 300px;
  background: var(--white);
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
  color: var(--white);
  border: none;
  padding: 10px 20px;
  cursor: pointer;
}

.search-container button:hover {
  background: var(--primary-color-dark);
}

/* Table */
.table-wrapper {
  width: 96%;
  margin: 20px auto;
  overflow: auto;
  background: var(--white);
  box-shadow: 3px 0 8px rgba(0,0,0,0.1);
  border-radius: 8px;
  padding: 10px;
}

.table-wrapper table {
  width: 100%;
  min-width: 900px;
  border-collapse: collapse;
  text-align: center;
}

.table-wrapper th,
.table-wrapper td {
  padding: 12px;
  border: 1px solid #ddd;
  white-space: nowrap;
}

.table-wrapper th {
  background: var(--primary-color);
  color: var(--white);
  position: sticky;
  top: 0;
}

.table-wrapper tbody tr:nth-child(even) {
  background: #f9f9f9;
}

.table-wrapper tbody tr:hover {
  background: #eef7ff;
}

/* Buttons */
.btn {
  padding: 8px 14px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  margin: 3px;
}

.btn-add { background: #007bff; color: var(--white); }
.btn-edit { background: #005f99; color: var(--white); }
.btn-delete { background: #dc3545; color: var(--white); }
.btn-view { background: #2a52be; color: var(--white); }

/* Modal */
.modal {
  display: none;
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.6);
  justify-content: center;
  align-items: center;
}

.modal-content {
  background: var(--white);
  padding: 20px;
  border-radius: 8px;
  width: 300px;
}

.modal-content h3 {
  text-align: center;
  color: var(--primary-color);
  margin-top: 0;
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
  border-radius: 5px;
  border: 1px solid #ccc;
}

/* Select Arrow */
select {
  padding: 10px 14px;
  font-size: 14px;
  color: var(--primary-color);
  border: 1px solid var(--primary-color);
  border-radius: 6px;
  background-color: var(--white);
  appearance: none;
  background-image: url("data:image/svg+xml;utf8,<svg fill='%23004b75' height='24' viewBox='0 0 24 24' width='24' xmlns='http://www.w3.org/2000/svg'><path d='M7 10l5 5 5-5z'/></svg>");
  background-repeat: no-repeat;
  background-position: right 10px center;
  background-size: 18px;
  cursor: pointer;
}

select:hover, select:focus {
  border-color: var(--primary-color-dark);
  outline: none;
}

option {
  padding: 10px;
  font-size: 14px;
  background: var(--white);
  color: var(--primary-color);
}

option:checked {
  background: #e6f2fb;
  font-weight: bold;
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
    <aside class="sidebar">
      <h1>Admin Panel</h1>
      <ul class="menu">
         <li><a href="<%=request.getContextPath()%>/manageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
        <li><a href="<%=request.getContextPath()%>/manageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
        <li><a href="<%=request.getContextPath()%>/manageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li class="active"><a href="<%=request.getContextPath()%>/manageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
        <li><a href="<%=request.getContextPath()%>/managePayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
        <li>
  <a   href="passengerInfoController"><i class="fa-solid fa-users"></i> Passenger Information</a>
</li>
        <li><a href="<%=request.getContextPath()%>/manageUserAccounts.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
        <li><a href="<%=request.getContextPath()%>/manageContactUser.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
  
        <li><a href="<%=request.getContextPath()%>/mainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
      </ul>
    </aside>

    <div class="content">
      <div class="content_title">
        <h2>Manage Booking</h2>
        <div class="search-container">
          <input type="text" id="searchInput" placeholder="Search here...">
          <button onclick="search()"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
      </div>

      <div class="table-wrapper">
        <table id="flightTable">
          <thead>
            <tr>
              <th>Booking ID</th>
              <th>User ID</th>
              <th>Flight ID</th>
              <th>Booking Date</th>
              
              <th>Price</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
             <tbody>
            <%
            bookingDAO daoo = new bookingDAO();
                                                List<Booking> bookings = daoo.getAll();
                                                  for(Booking b : bookings){
            %>
            <tr>
              <td><%=b.getBookingID()%></td>
              <td><%=b.getUserID()%></td>
              <td><%=b.getFlightID()%></td>
              <td><%=b.getBookingDate()%></td>
      
              <td><%=b.getTotalCost()%></td>
              <td><%=b.getStatus()%></td>
                        <td>
                <a href="${pageContext.request.contextPath}/JSPView/viewBooking.jsp?bookingID=<%=b.getBookingID()%>" class="btn btn-view"><i class="fa-regular fa-eye"></i></a>
                <a href="${pageContext.request.contextPath}/JSPView/editBooking.jsp?bookingID=<%=b.getBookingID()%>" class="btn btn-edit"><i class="fa-regular fa-pen-to-square"></i></a>
                
              </td>
            </tr>
            <%
            }
            %>
          </tbody>
          
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- Modal -->

<div class="modal" id="bookingModal">
  <div class="modal-content">
    <h3>Edit Booking (Booking ID: <%=booking.getBookingID()%>)</h3>

    <form  method="post">
      <input type="hidden" name="action" value="update">

      
      <div class="form-group">
        <label>Booking ID</label>
        <input type="text" name="bookingID" value="<%=booking.getBookingID()%>" readonly>
      </div>

    
      <div class="form-group">
        <label>User ID</label>
        <input type="text" name="userID" value="<%=booking.getUserID()%>" readonly>
      </div>

   

<div class="form-group">
  <label>FlightID</label>
  <%
  if("Pending".equalsIgnoreCase(booking.getStatus())) {
  %>
    <select name="flightID" required>
      <%
      DAO.flightDAO fdao = new DAO.flightDAO();
                    List<Flight> flights = fdao.getAllFlights();
                    for (Flight f : flights) {
      %>
        <option value="<%= f.getFlightID() %>" 
          <%= (f.getFlightID() == booking.getFlightID()) ? "selected" : "" %>>
          <%= f.getFlightNumber() %> | <%= f.getOrigin() %> → <%= f.getDestination() %> ($<%= f.getPrice() %>)
        </option>
      <% } %>
    </select>
  <% } else { %>
    <input type="text" value="<%= booking.getFlightID() %>" readonly>
    <input type="hidden" name="flightID" value="<%= booking.getFlightID() %>">
  <% } %>
</div>
      
      <div class="form-group">
       <input type="date" name="bookingDate" value="<%= booking.getBookingDate() %>" disabled>

      </div>


      <div class="form-group">
        <label>Total Cost</label>
        <input type="number" name="totalCost" value="<%= booking.getTotalCost() %>" disabled>
      </div>

      <!-- Status (readonly) -->
      <div class="form-group">
        <label>Status</label>
        <input type="text" name="status" value="<%= booking.getStatus() %>" readonly>
      </div>

      <button type="submit" class="btn btn-add">Save</button>
      <button type="button" class="btn btn-delete" onclick="window.location.href='${pageContext.request.contextPath}/JSPView/manageBooking.jsp'">Cancel</button>
    </form>
  </div>
</div>
<script>
window.onload = function(){
    document.getElementById("bookingModal").style.display = "flex";
};
</script>

<script>
function closeModal(){
    document.getElementById("bookingModal").style.display="none";
}

// optional: open modal automatically if bookingID is in URL
window.onload = function() {
    var bookingModal = document.getElementById("bookingModal");
    if (bookingModal) {
        bookingModal.style.display = "flex";
    }
};

</script>
<script>
function save() { window.location.href="manageBooking.html"; }
function goToManage() { window.location.href="manageBooking.html"; }

</script>
</body>
</html>
