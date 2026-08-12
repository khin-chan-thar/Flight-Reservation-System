<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.Flight" %>

<%
    List<Flight> allFlights = (List<Flight>) request.getAttribute("allFlights");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View All Flights</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
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
  
  a {
    color: inherit;          /* inherits text color from parent */
    text-decoration: none;   /* removes underline */
    font-weight: inherit;    /* optional: inherit font weight */
    cursor: pointer;         /* keeps pointer cursor */
    background: none;        /* remove any background */
    border: none;            /* remove borders if any */
    outline: none;           /* remove outline on focus */
    transition: color 0.2s;  /* optional smooth hover */
}

a:hover {
    color: white;          /* optional hover color */
    text-decoration: none;   /* ensures no underline on hover */
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
  .footer ul li { margin-bottom:5px; font-size:14px; }
    
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7fc;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 1200px;
            margin: 50px auto;
            background-color: #fff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #004b75;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            text-align : center;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #004b75;
            color: #fff;
        }
        .status-pending {
            color: orange;
            font-weight: bold;
        }
        .status-completed {
            color: green;
            font-weight: bold;
        }
        .status-failed {
            color: red;
            font-weight: bold;
        }
        .error-message {
            text-align: center;
            color: red;
            font-size: 16px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<!-- Navbar -->
  <div class="navbar">
    <div class="logo"><i class="fa-solid fa-plane-departure"></i> Aurora</div>
    <div class="nav-links">
      <a href="<%=request.getContextPath()%>/JSPView/homeUser.jsp" >Home</a>
 
      <a href="<%=request.getContextPath()%>/JSPView/searchFlightUser.jsp">Search Flight</a>
      
       <form action="/FlightReservationSystem/flightController" method="get"  >
        <input type="hidden" name="action" value="viewAllFlights"/>
        <button type="submit" class="active">Flights</button>
      </form>
      
      <form action="/FlightReservationSystem/bookingController" method="post">
        <input type="hidden" name="action" value="viewBookings"/>
        <button type="submit">View Booking Status</button>
      </form>
      
      <form action="/FlightReservationSystem/bookingController" method="post">
        <input type="hidden" name="action" value="myTicket"/>
        <button type="submit">My Ticket</button>
      </form>

      <a href="<%=request.getContextPath()%>/JSPView/contactAdmin.jsp">Message</a>
      <a href="<%=request.getContextPath()%>/userController?action=logout">Logout</a>
 	</div>
  </div>
<!--End of Navbar-->
    <header>
  <h1>Aurora</h1>
  
</header>
<div class="container">
    <h2>All Flights</h2>   
         <% if (allFlights != null && !allFlights.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>Flight ID</th>
                        <th>Flight Number</th>
                        <th>Origin</th>
                        <th>Destination</th>
                        <th>Departure Time</th>
                        <th>Arrival Time</th>
                        <th>Price ($)</th>
                        <th>Available Seats</th>
                       
                    </tr>
                </thead>
                <tbody>
                    <% for (Flight flight : allFlights) { %>
                        <tr>
                            <td><%= flight.getFlightID() %></td>
                            <td><%= flight.getFlightNumber() %></td>
                            <td><%= flight.getOrigin() %></td>
                            <td><%= flight.getDestination() %></td>
                            <td><%= flight.getDeparture() %></td>
                            <td><%= flight.getArrival() %></td>
                            <td><%= flight.getPrice() %></td>
                            <td><%= flight.getAvailableSeats() %></td>
                           
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div style="text-align:center; color:red; font-weight:bold; margin-top:20px;">No flights found.</div>
        <% } %>

</div>

</body>
</html>
