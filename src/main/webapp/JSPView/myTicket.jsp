<%@ page import="java.util.*, Model.Passenger" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Passenger> tickets = (List<Passenger>) request.getAttribute("tickets");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
<title>Your Tickets</title>
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
    body { font-family: Arial; background: #f0f4f8; padding: 20px; }
    h1 { text-align: center; color: #004b75;margin-top:15px; margin-bottom: 5px; }
   
    .ticket { flex: 1 ;background: #fff; width: 500px; border-radius: 15px; box-shadow: 0 8px 20px rgba(0,0,0,0.2); padding: 20px; margin: 20px auto; position: relative; border-left: 10px solid #004b75; }
    .ticket-header { display: flex; justify-content: space-between; margin-bottom: 15px; }
    .ticket-header h2 { color: #004b75; font-size: 20px; }
    .ticket-body p { margin: 5px 0; font-size: 16px; }
    .ticket-footer { display: flex; justify-content: space-between; font-size: 14px; color: #666; }
 .ticket-table {
        width: 100%;
        border-collapse: collapse; /* remove default spacing */
        margin-bottom: 15px;
    }

    .ticket-table td {
        padding: 5px 10px;
        vertical-align: top;
    }

    .ticket-table td.label {
        font-weight: bold;
        width: 120px; /* adjust as needed */
    }
    .button {
    align-item: right;
    }
    .download-container {
    flex-shrink: 0;     
    text-align: right;  /* or center/left depending on your design */
}

  .download-container button {
        margin-top: 15px;
        padding: 10px 20px;
        border: none;
        border-radius: 8px;
        background: #007bff;
        color: white;
        font-size: 14px;
        cursor: pointer;
      }

      .download-container button:hover {
        background: #0056b3;
      }
      
      .ticket-wrapper {
      width : 800px;
      margin : auto;
    display: flex;
    align-items: center;   /* vertically center ticket & button */
    justify-content: space-between; /* space between ticket and button */
    gap: 20px;             /* spacing between elements */
}
    
</style>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script>
  function downloadTicket(ticketId) {
    // Get the ticket element by its unique ID
    const ticket = document.getElementById(ticketId);
    
    if (!ticket) {
      alert("Ticket not found!");
      return;
    }

    // Use html2canvas to capture the ticket as a canvas
    html2canvas(ticket).then((canvas) => {
      // Create a temporary link element
      const link = document.createElement("a");
      link.download = ticketId + ".png";  // filename
      link.href = canvas.toDataURL("image/png"); // convert canvas to PNG
      link.click(); // trigger download
    }).catch((err) => {
      console.error("Error capturing ticket:", err);
    });
  }
</script>
    
</head>
<body>
<!-- Navbar -->
  <div class="navbar">
    <div class="logo"><i class="fa-solid fa-plane-departure"></i> Aurora</div>
    <div class="nav-links">
      <a href="<%=request.getContextPath()%>/JSPView/homeUser.jsp" >Home</a>
 
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
        <button type="submit" class="active">My Ticket</button>
      </form>

      <a href="<%=request.getContextPath()%>/JSPView/contactAdmin.jsp">Message</a>
      <a href="<%=request.getContextPath()%>/userController?action=logout">Logout</a>
 	</div>
  </div>
<!--End of Navbar-->
    <header>
  <h1>Aurora</h1>
  
</header>
<h1>Tickets</h1>

<%
if (tickets == null || tickets.isEmpty()) {
%>
    <p style="text-align:center;">No tickets found.</p>
<%
} else {
	int i = 0;
    for (Passenger ticket : tickets) {
%>
   <div class="ticket-wrapper">
    <!-- Ticket box -->
    <div class="ticket" id="ticket<%= i %>">
        <div class="ticket-header">
            <h2>Aurora Airline</h2>
            <span>Ticket #: <%= ticket.getTicketNumber() != null ? ticket.getTicketNumber() : "Not Issued" %></span>
        </div>
        <table class="ticket-table">
            <tr>
                <td class="label">Passenger:</td>
                <td><%= ticket.getFullName() %></td>
                <td class="label">Flight:</td>
                <td><%= ticket.getFlight().getFlightNumber() %></td>
            </tr>
            <tr>
                <td class="label">From:</td>
                <td><%= ticket.getFlight().getOrigin() %></td>
                <td class="label">To:</td>
                <td><%= ticket.getFlight().getDestination() %></td>
            </tr>
            <tr>
                <td class="label">Departure:</td>
                <td><%= ticket.getFlight().getDeparture() %></td>
                <td class="label">Arrival:</td>
                <td><%= ticket.getFlight().getArrival() %></td>
            </tr>
        </table>
    </div>

    <!-- Download button -->
    <div class="download-container">
        <button onclick="downloadTicket('ticket<%= i %>')">
            <i class="fa-solid fa-download"></i> Download
        </button>
    </div>
</div>

   
<%
   i++; }
}
%>
</body>
</html>
