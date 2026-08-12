<%@page import="DAO.paymentDAO"%>
<%@page import="Model.Payment"%>
<%@ page import="java.util.*, DAO.paymentDAO, Model.Payment" %>
<%
    paymentDAO dao = new paymentDAO() ;
    List<Payment> list = dao.getAllPayments();

    String action = request.getParameter("action");
    Payment payment = new Payment();
    if ("view".equals(action) || "approve".equals(action) || "reject".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        payment = dao.getPaymentById(id);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Admin | Manage User Payments</title>
</head>
<style>
	  /* table */

.table-wrapper {
  width: 95%;         /* fixed width */
  height: 120%;          /* fixed height */
  overflow-x: auto;       /* horizontal scrollbar if needed */
  overflow-y: auto;       /* vertical scrollbar if needed */
  background: #fff;
  box-shadow: 3px 0 8px rgba(0,0,0,0.1);
  padding: 10px;
}

.flight-table {
  width: 100%;
  border-collapse: collapse;
  min-width: 1000px;      /* force horizontal scrollbar if narrow screen */
}

 .flight-table td {
  padding: 10px;
  text-align: center;
  border: 1px solid #ddd;
  font-size: 10px;
  white-space: nowrap;    /* prevent text wrapping */
}

/* Sticky header */
.flight-table thead th {
  position: sticky;
  top: 0;
  font-size: 14px;
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
      font-size: 14px;
      text-align: center;
    }
    th {
      background: #004b75;
      font-size: 14px;
      color: white;
    }
	
</style>
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
        <!-- Sidebar (same as Airline JSP) -->
        <aside class="sidebar">
            <h1>Admin Panel</h1>
             <ul class="menu">
        <li><a href="<%=request.getContextPath()%>/JSPView/manageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
        <li><a href=" <%=request.getContextPath()%>/JSPView/manageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
        <li class="active"><a href="<%=request.getContextPath()%>/JSPView/manageUserPayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
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
            <h2>Manage User Payments</h2>
			<div class="content_title">
        <ul>
          <li></li>
          <li>
            <div class="search-container">
              <input type="text" id="searchInput" placeholder="Search here...">
				<button type="button" onclick="searchMessages()">
  				<i class="fa-solid fa-magnifying-glass"></i>
				</button>
            </div>
          </li>
        </ul>
      </div>
            <div class="table-wrapper">
                <table id="paymentTable">
                    <thead>
                        <tr>
                            <th>Payment ID</th>
                            <th>User </th>
                            <th>Booking Code</th>
                            <th>Amount</th>
                            <th>Pay Method</th>
                            <th>Trasaction ID</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Payment p : list) { %>
                            <tr>
                                <td><%= p.getPaymentID() %></td>
                                <td><%= p.getFullName() %></td>
                                <td><%= p.getBookingCode() %></td>
                                <td><%= p.getAmount() %></td>
                                <td><%= p.getPaymentMethod() %></td>
                                <td><%= p.getTransactionID() %></td>
                                <td><%= p.getStatus() %></td>
                                <td>
                                    <!-- View -->
                                    <a href="manageUserPayment-Form.jsp?action=view&id=<%= p.getPaymentID() %>" class="btn btn-view"><i class="fa-regular fa-eye"></i></a>
                                    
                                    <!-- Approve -->
                                    <% if("Pending".equalsIgnoreCase(p.getStatus())) { %>
                                        <form action="/FlightReservationSystem/paymentController" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="approve"/>
                                            <input type="hidden" name="id" value="<%= p.getPaymentID() %>"/>
                                            <button type="submit" class="btn btn-approve"><i class="fa-solid fa-check"></i></button>
                                        </form>
                                    <% } else {%>
                                    <form action="/FlightReservationSystem/paymentController" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="approve"/>
                                            <input type="hidden" name="id" value="<%= p.getPaymentID() %>"/>
                                            <button type="submit" class="btn btn-approve" disabled><i class="fa-solid fa-check"></i></button>
                                        </form>
                                        <%} %>

                                    <!-- Reject -->
                                    <% if("pending".equalsIgnoreCase(p.getStatus())) { %>
                                        <form action="/FlightReservationSystem/paymentController" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="reject"/>
                                            <input type="hidden" name="id" value="<%= p.getPaymentID() %>"/>
                                            <button type="submit" class="btn btn-reject"><i class="fa-solid fa-xmark"></i></button>
                                        </form>
                                    <% } else {%>
                                     <form action="/FlightReservationSystem/paymentController" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="approve"/>
                                            <input type="hidden" name="id" value="<%= p.getPaymentID() %>"/>
                                            <button type="submit" class="btn btn-reject" disabled><i class="fa-solid fa-xmark"></i></button>
                                        </form>
                                        <%} %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Modal for view payment -->
            <% if(action != null && "view".equals(action)) { %>
                <div class="modal" id="paymentModal" style="display:flex;">
                    <div class="modal-content">
                        <h3>Payment Details</h3>
                        <p><strong>Payment ID:</strong> <%= payment.getPaymentID() %></p>
                        <p><strong>User ID:</strong> <%= payment.getUserID() %></p>
                        <p><strong>Booking ID:</strong> <%= payment.getBookingCode() %></p>
                        <p><strong>Amount:</strong> <%= payment.getAmount() %></p>
                        <p><strong>Status:</strong> <%= payment.getStatus() %></p>
                        <p><strong>Method:</strong> <%= payment.getPaymentMethod() %></p>
                        
                        <p><strong>Payment Date:</strong> <%= payment.getPaymentDate() %></p>
                        <button class="btn btn-delete" onclick="closeModal()">Close</button>
                    </div>
                </div>
            <% } %>

        </div>
    </div>
</div>

<script>
function searchMessages(){
	  var input = document.getElementById('searchInput').value.toLowerCase();
	  var rows = document.querySelectorAll('#messageTable tbody tr');
	  rows.forEach(row => {
	    row.style.display = row.innerText.toLowerCase().includes(input) ? '' : 'none';
	  });
	}
	  // Search filter
	  function searchMessages() {
		  let input = document.getElementById('searchInput').value.toLowerCase();
		  let rows = document.querySelectorAll('#paymentTable tbody tr');

		  rows.forEach(row => {
		    let rowText = row.innerText.toLowerCase();
		    row.style.display = rowText.includes(input) ? '' : 'none';
		  });
		}

		// Trigger search when pressing Enter inside the input
		document.getElementById("searchInput").addEventListener("keypress", function(event) {
		  if (event.key === "Enter") {
		    event.preventDefault(); // prevent form submit if inside a form
		    searchMessages();
		  }
		})
    function closeModal() {
        window.location.href = "manageUserPayment.jsp";
    }
</script>
</body>
</html>
