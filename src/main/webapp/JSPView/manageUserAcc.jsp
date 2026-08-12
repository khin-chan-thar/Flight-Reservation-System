<%@page import="Model.User"%>
<%@ page import="java.util.*,DAO.airlineDAO,Model.Airline,DAO.userDAO" %>
<%


userDAO userdao = new userDAO();
List<User> list = userdao.getAllUsers();

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
 <style type="text/css">
     .msg-Success {
        color: green;
        font-weight: bold;
        margin-bottom: 10px;
    }
    .msg-Failed {
        color: red;
        font-weight: bold;
        margin-bottom: 10px;
  </style>
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
        <li><a href=" <%=request.getContextPath()%>/JSPView/manageAircraft.jsp"><i class="fa-solid fa-plane-up"></i> Manage Aircraft</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageBooking.jsp"><i class="fa-solid fa-file-invoice"></i> Manage Booking</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/manageUserPayment.jsp"><i class="fa-solid fa-ticket"></i> Manage Payment</a></li>
            <li>
    <a  href="<%=request.getContextPath()%>/passengerInfoController"><i class="fa-solid fa-users"></i> Passenger Information</a>
</li>
<li class="active"><a href="<%=request.getContextPath()%>/JSPView/manageUserAcc.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/adminReplyMessage.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/mainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
      </ul>
    </aside>

    <!-- Main content -->
    <div class="content">
      <h2>Manage User</h2>
      <div class="content_title">
        <ul>
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
          <!-- for search -->
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
	  	 <table id="manageUserTable">
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
          <% for(User a : list){ %>
            <tr>
              <td><%=a.getUserID()%></td>
              <td><%=a.getFullName()%></td>
              <td><%=a.getEmail()%></td>
           		<td><%=a.getPhoneNumber()%></td>
				<td><%= a.getStatus() ? "Active" : "Inactive" %></td>
              <td>
        <!-- View first -->
        <a href="manageUserAcc-Form.jsp?action=view&id=<%= a.getUserID() %>"" class="btn btn-view" style="text-decoration: none;"><i class="fa-regular fa-eye"></i></a>
      
        <!-- Delete -->
        <form action="/FlightReservationSystem/userController" method="post"  style="display:inline;">
          <input type="hidden" name="action" value="delete"/>
          <input type="hidden" name="id" value="<%=a.getUserID()%>"/>
          <button type="submit" class="btn btn-delete" ><i class="fa-solid fa-trash"></i></button>
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
//search message
function searchMessages(){
  var input = document.getElementById('searchInput').value.toLowerCase();
  var rows = document.querySelectorAll('#manageUserTable tbody tr');
  rows.forEach(row => {
    row.style.display = row.innerText.toLowerCase().includes(input) ? '' : 'none';
  });
}

function searchMessages() {
	  let input = document.getElementById('searchInput').value.toLowerCase();
	  let rows = document.querySelectorAll('#manageUserTable tbody tr');

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

  // Optional: Search filter
  function search() {
    const input = document.getElementById("searchInput").value.toLowerCase();
    const rows = document.querySelectorAll("#airlineTable tbody tr");
    rows.forEach(row => {
      const text = row.innerText.toLowerCase();
      row.style.display = text.includes(input) ? "" : "none";
    });
  }
</script>

</body>
</html>
