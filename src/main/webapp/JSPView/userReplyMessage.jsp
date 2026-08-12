<%@page import="java.util.List"%>
<%@page import="DAO.messageDAO, Model.Message"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User - Contact Admin</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
td.message-col, td.subject-col { max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

.modal-overlay {
    position: fixed; top:0; left:0; width:100%; height:100%;
    background: rgba(0,0,0,0.5); display:none; justify-content:center; align-items:center; z-index:1000;
}
.modal-content {
    background: #fff; padding:20px; border-radius:12px; width:400px;
}
.modal-content h2 { text-align:center; color:#004b75; }
.modal-content input, .modal-content textarea { width:100%; padding:10px; margin-bottom:12px; border-radius:8px; }
.modal-content textarea { height:100px; resize:none; }
.modal-content .btn { padding:10px 15px; margin:5px; border:none; border-radius:8px; cursor:pointer; }
.modal-content .btn-send { background:#1a73e8; color:white; }
.modal-content .btn-cancel { background:#dc3545; color:white; }
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
  <div class="user-panel">
  
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
<li><a href="<%=request.getContextPath()%>/JSPView/manageUserAcc.jsp"><i class="fa-solid fa-address-card"></i> Manage User Accounts</a></li>
        <li class="active"><a href="<%=request.getContextPath()%>/JSPView/adminReplyMessage.jsp"><i class="fa-solid fa-address-book"></i> Contact User</a></li>
        <li><a href="<%=request.getContextPath()%>/JSPView/mainHome.jsp"><i class="fa-solid fa-right-from-bracket"></i> Log Out</a></li>
      </ul>
    </aside>
    
      <!-- Main content -->
    <div class="content">
      <h2>Contact Admin</h2>
     
      <div class="content_title">
        <ul>
          <li><button class="btn btn-add" onclick="openSendMessageModal()">Send Message</button></li>

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
      <table border="1" id="userContactTable">
        <thead>
          <tr>
            <th>Message ID</th><th>From Admin</th><th>Subject</th><th>Message</th><th>Time</th><th>Status</th><th>Action</th>
          </tr>
        </thead>
        <tbody>
        <%
            messageDAO dao = new messageDAO();
            //Integer userID = (Integer) session.getAttribute("userID");
            Integer userID = 1;
            List<Message> inbox = dao.getUserInbox(userID); // your DAO: messages from admin to this user
            if(inbox != null){
                for(Message msg: inbox){
        %>
          <tr>
            <td><%= msg.getMessageID() %></td>
            <td>Admin</td>
            <td class="subject-col"><%= msg.getSubject() %></td>
            <td class="message-col" title="<%= msg.getContent() %>"><%= msg.getContent() %></td>
            <td><%= msg.getSentDate() %></td>
            <td><%= msg.getStatus() %></td>
            <td>
              <button onclick="openReplyModal('<%= msg.getAdminID() %>', '<%= msg.getSubject() %>', '<%= msg.getContent().replaceAll("'", "\\\\'") %>')">
                <i class="fa-regular fa-pen-to-square"></i> Reply
              </button>
            </td>
          </tr>
        <%
                }
            }
        %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Send Message Modal -->
<div class="modal-overlay" id="sendMessageModal">
  <div class="modal-content">
    <h2>Send Message to Admin</h2>
    <form action="/FlightReservationSystem/userReplyController" method="post">
      <!-- Hidden user and admin fields -->
      <input type="hidden" name="receiverAdminID" value="1"/><!-- or dynamic admin ID -->
      <input type="hidden" name="userID" value="<%= 1 %>"/><!-- Change to session userID -->

      <!-- Subject -->
      <label>Subject:</label><br/>
      <input type="text" name="subject" required/><br/>

      <!-- Message -->
      <label>Message:</label><br/>
      <textarea name="content" placeholder="Type your message..." required></textarea><br/>

      <button type="submit" class="btn btn-send">Send</button>
      <button type="button" class="btn btn-cancel" onclick="closeSendMessageModal()">Cancel</button>
    </form>
  </div>
</div>



<!-- Reply Modal -->
<div class="modal-overlay" id="replyModal">
  <div class="modal-content">
    <h2>Reply to Admin</h2>
    <form action="/FlightReservationSystem/userReplyController" method="post">
      <!-- Hidden fields -->
      <input type="" id="modalReceiverAdminID" name="receiverAdminID" required/>
      <input type="" name="userID" value="<%= 1 %>"/><!--Change it to user getting with session  need to change -->

      <!-- Editable subject -->
      <label>Subject:</label><br/>
      <input type="text" id="modalSubject" name="subject" required/><br/>

      <!-- Editable content -->
      <label>Message:</label><br/>
      <textarea id="modalContent" name="content" placeholder="Type your reply..." required></textarea><br/>

      <button type="submit" class="btn btn-send">Send Reply</button>
      <button type="button" class="btn btn-cancel" onclick="closeReplyModal()">Cancel</button>
    </form>
  </div>
</div>

<script>
function openReplyModal(adminID, subject, content){
    if(!adminID) {
        alert("Admin ID is missing!");
        return;
    }
    document.getElementById('modalReceiverAdminID').value = adminID;
    document.getElementById('modalSubject').value = subject || "";
    document.getElementById('modalContent').value = content || "";
    document.getElementById('replyModal').style.display = 'flex';
}

function closeReplyModal(){
    document.getElementById('replyModal').style.display = 'none';
}

function openSendMessageModal(){
    document.getElementById('sendMessageModal').style.display = 'flex';
}

function closeSendMessageModal(){
    document.getElementById('sendMessageModal').style.display = 'none';
}


function searchMessages(){
  var input = document.getElementById('searchInput').value.toLowerCase();
  var rows = document.querySelectorAll('#userContactTable tbody tr');
  rows.forEach(row => {
    row.style.display = row.innerText.toLowerCase().includes(input) ? '' : 'none';
  });
}

function searchMessages() {
	  let input = document.getElementById('searchInput').value.toLowerCase();
	  let rows = document.querySelectorAll('#userContactTable tbody tr');

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



</script>




</body>
</html>
