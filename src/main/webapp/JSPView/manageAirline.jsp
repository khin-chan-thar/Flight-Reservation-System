<%@ page import="java.util.*,DAO.airlineDAO,Model.Airline" %>
<%
    airlineDAO dao = new airlineDAO();
    List<Airline> list = dao.listAirlines();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <title>Aurora Admin | Manage Airline</title>
  <style>
   .msg-Success {
        color: green;
        font-weight: bold;
        margin-bottom: 10px;
    }
    .msg-Failed {
        color: red;
        font-weight: bold;
        margin-bottom: 10px;
    }
    .message-success {
      color: green;
      font-weight: bold;
      margin-left: 15px;
    }
    .message-error {
      color: red;
      font-weight: bold;
      margin-left: 15px;
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
        <li><a href="<%=request.getContextPath()%>/JSPView/manageFlight.jsp"><i class="fa-solid fa-plane-departure"></i> Manage Flight</a></li>
        <li class="active"><a href="<%=request.getContextPath()%>/JSPView/manageAirline.jsp"><i class="fa-solid fa-plane"></i> Manage Airline</a></li>
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
      <h2>Manage Airlines</h2>
      <div class="content_title">
        <ul>
          <li>
            <a href="ManageAirline-Form.jsp?action=add">
              <button class="btn btn-add">+ Add New Airline</button>
            </a>
        <!--this is for showing message  -->
        
        <li><%
		    String msg = (String) session.getAttribute("msg");
		    String msgType = (String) session.getAttribute("msgType");
		    if(msg != null){%>
		<div class="msg-<%= msgType %>"><%= msg %></div>
<%
        session.removeAttribute("msg");
        session.removeAttribute("msgType");
    }
%></li>

 <!--this is for showing message  -->
          
          <li>
            <div class="search-container">
              <input type="text" id="searchInput" placeholder="Search here...">
				<button type="button" onclick="searchMessages()">
  				<i class="fa-solid fa-magnifying-glass"></i>
				</button>
            </div>
          </li>
         <%--  <li>
            <%
              String message = (String) session.getAttribute("message");
              if(message != null){
            %>
              <span id="msg" class="<%= message.contains("Failed") ? "message-error" : "message-success" %>">
                <%= message %>
              </span>
            <%
                session.removeAttribute("message"); // show once
              }
            %>
          </li> --%>
        </ul>
      </div>

      <div class="table-wrapper">
        <table id="flightTable">
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
                  <!-- View -->
                  <a href="ManageAirline-Form.jsp?action=view&id=<%= a.getAirlineID() %>" class="btn btn-view" style="text-decoration: none;">
                    <i class="fa-regular fa-eye"></i>
                  </a>
                  <!-- Update -->
                  <a href="ManageAirline-Form.jsp?action=update&id=<%=a.getAirlineID()%>" class="btn btn-edit" style="text-decoration: none;">
                    <i class="fa-regular fa-pen-to-square"></i>
                  </a>
                  <!-- Delete -->
                  <form action="/FlightReservationSystem/airlineController" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="<%=a.getAirlineID()%>"/>
                    <button type="submit" class="btn btn-delete" >
                      <i class="fa-solid fa-trash"></i>
                    </button>
                  </form>
                </td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>
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
	  let rows = document.querySelectorAll('#flightTable tbody tr');

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
	});
  


  // Auto-hide message after 3 seconds
  window.onload = function() {
    const msg = document.getElementById("msg");
    if (msg) {
      setTimeout(() => {
        msg.style.display = "none";
      }, 3000);
    }
  };
</script>

</body>
</html>
  