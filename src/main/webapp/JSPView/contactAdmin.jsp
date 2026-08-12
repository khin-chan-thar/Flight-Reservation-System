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
  * { margin:0; padding:0; box-sizing:border-box; font-family: Arial, sans-serif; }
  html, body { height:100%; width:100%; }

  body {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    background-color: #f4f7fb;
    color: #003366;
  }

  /* Navbar */
  .navbar {
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:0 20px;
    height:72px;
    background:#004b75;
    color:#fff;
    position:fixed;
    top:0;
    left:0;
    right:0;
    z-index:1000;
  }

  .logo { font-size:1.25rem; font-weight:700; display:flex; align-items:center; gap:8px; }

  .nav-links {
    display:flex;
    align-items:center;
    gap:15px;
    margin-left:auto;
  }

  .nav-links a, .nav-links button {
    text-decoration:none;
    color:white;
    font-weight:600;
    padding:8px 12px;
    border-radius:8px;
    background:transparent;
    border:none;
    cursor:pointer;
    transition: all 0.2s ease;
  }

  .nav-links a.active, .nav-links button.active {
    background:#0369a1;
  }

  .nav-links a:hover, .nav-links button:hover {
    background:#0284c7;
  }

  .nav-links form { margin:0; display:inline-block; }

  /* Make form button look like link */
  .nav-links form button {
    font-family: inherit;
    font-size: inherit;
    color: white;
    font-weight:600;
    background: transparent;
    border: none;
    padding:8px 12px;
    border-radius:8px;
    cursor:pointer;
  }

  /* Main Welcome Section */
  .welcome {
    flex-grow:1;
    display:flex;
    flex-direction:column;
    justify-content:center;
    align-items:center;
    text-align:center;
    padding:0 20px;
    margin-top:72px; /* offset fixed navbar */
  }

  .welcome h1 { font-size:2rem; margin-bottom:10px; font-weight:700; }
  .welcome p { font-size:1rem; max-width:600px; line-height:1.5; color:#333; }

  /* Footer */
  .footer {
    background:#004b75;
    color:#fff;
    padding:20px 10px 40px;
    text-align:center;
    margin-top:auto;
  }

  .footer h4 { font-size:1.2rem; margin-bottom:10px; }
  .footer ul { list-style:none; padding:0; margin:0; }
  .footer ul
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
.btn-add { background:#004b75; color:white; }

.messages-container {
    display: flex;
    flex-direction: column;
    gap: 20px;
    margin-top: 5px;
    padding: 10px;
}

.message-bubble {
    max-width: 70%;
    background: #fff;
    color: #004b75;
    padding: 15px 20px;
    border-radius: 15px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    position: relative;
    transition: transform 0.2s, box-shadow 0.2s;
}

.message-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 16px rgba(0,0,0,0.25);
}

.message-header {
    font-weight: bold;
    margin-bottom: 5px;
    font-size: 0.95rem;
}

.message-content {
    font-size: 0.95rem;
    margin-bottom: 8px;
    line-height: 1.4;
    word-wrap: break-word;
}

.message-time {
    font-size: 0.75rem;
    color: #004b75;
    text-align: right;
}

.reply-button {
    margin-top: 8px;
    background: #cce0f0;
    color: #004b75;
    border: none;
    padding: 6px 12px;
    border-radius: 10px;
    cursor: pointer;
    font-size: 0.85rem;
    transition: background 0.2s, color 0.2s;
}

.reply-button:hover {
    background: #004575;
    color: #fff;
}
</style>
</head>
<body>
 <!-- Navbar -->
  <div class="navbar">
    <div class="logo"><i class="fa-solid fa-plane-departure"></i> Aurora</div>
    <div class="nav-links">
      <a href="<%=request.getContextPath()%>/JSPView/homeUser.jsp" ">Home</a>
      <a href="<%=request.getContextPath()%>/JSPView/searchFlightUser.jsp">Search Flight</a>
      
       <form action="/FlightReservationSystem/flightController" method="get">
        <input type="hidden" name="action" value="viewAllFlights"/>
        <button type="submit">Flights</button>
      </form>
      
      <form action="/FlightReservationSystem/bookingController" method="post">
        <input type="hidden" name="action" value="viewBookings"/>
        <button type="submit">View Booking Status</button>
      </form>
      
      <form action="/FlightReservationSystem/bookingController" method="post">
        <input type="hidden" name="action" value="myTicket"/>
        <button type="submit">My Ticket</button>
      </form>

      
      <a href="<%=request.getContextPath()%>/JSPView/contactAdmin.jsp" class="active">Message</a>
      <a href="<%=request.getContextPath()%>/userController?action=logout">Logout</a>

  
    </div>
  </div>
<div class="container">
  <div class="user-panel">
  
  <!-- Sidebar -->
   
    
      <!-- Main content -->
    <div class="content">

      <div class="content_title">
      	<h1 style="margin-top : 20px;">Contact Admin</h1>
        <ul>
          <li><button class="btn btn-add" onclick="openSendMessageModal()">Send Message</button></li>

          <li>
            <div class="search-container">
              <input type="text" id="searchInput" placeholder="Search here...">
              <button onclick="search()"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
          </li>
        </ul>
      </div>
<%
    messageDAO dao = new messageDAO();
    Model.User loggedInUser = (Model.User) session.getAttribute("loggedInUser");
    if(loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/JSPView/loginUser.jsp");
        return;
    }
    Integer userID = loggedInUser.getUserID(); 
    List<Message> inbox = dao.getUserInbox(userID); 
%>


<div class="messages-container">
<%
if (inbox != null && !inbox.isEmpty()) {
    for (Message msg : inbox) {
    	boolean isAdmin = "Delivered".equals(msg.getStatus()); // admin messages
    	String senderLabel = isAdmin ? "Admin" : "You";
    	 String bubbleColor = isAdmin ? "#fff" : "#fff"; 
    	String bubbleClass = isAdmin ? "message-bubble message-admin" : "message-bubble message-user";
        String textAlign = isAdmin ? "left" : "right";
%>
    <div class="message-bubble">
        <div style="font-size:0.75rem; text-align:right;"><%= msg.getSentDate() %></div>
        <div style="font-weight:bold; margin-bottom:4px;"><%= senderLabel %></div>
        <div style="font-size:0.95rem; margin-bottom:6px;"><%= msg.getContent() %></div>
        
        <% if (isAdmin) { %>
            <button onclick="openReplyModal('<%= msg.getAdminID() %>', '<%= msg.getSubject() %>', '<%= msg.getContent().replaceAll("'", "\\\\'") %>')"
                    style="margin-top:6px; background:white; color:#004b75; border:none; padding:5px 10px; border-radius:8px; cursor:pointer; font-size:0.85rem;">
                Reply
            </button>
        <% } %>
    </div>
<%
    }
} else {
%>
    <p style="color:#555; text-align:center; margin-top:20px;">No messages found.</p>
<%
}
%>
</div>


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
      <input type="hidden" name="userID" value="<%= userID %>"/><!-- Change to session userID -->

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


</script>




</body>
</html>
