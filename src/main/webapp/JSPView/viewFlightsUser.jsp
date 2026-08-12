<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, Model.Flight" %>
<%
    // Try request first
    List<Flight> flights = (List<Flight>) request.getAttribute("flights");
    Integer numPassengers = (Integer) request.getAttribute("numPassengers");

    // If request empty, fall back to session
    if (flights == null) {
        flights = (List<Flight>) session.getAttribute("lastFlights");
    }
    if (numPassengers == null) {
        numPassengers = (Integer) session.getAttribute("lastNumPassengers");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Flights</title>
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
    
    h1 {
      text-align: center;
      margin-top: 20px;
      margin-bottom: 20px;
    }
    
    h2{
    text-align : center;
     margin-bottom: 20px;
     }

    /* Back button fixed at top-right */
    .back-btn {
      position: fixed;
      top: 100px;
      right: 45px;
      padding: 8px 16px;
      background-color: #004b75;
      color: white;
      text-decoration: none;
      border-radius: 5px;
      font-size: 14px;
      transition: background 0.3s;
      <%--z-index: 1000;--%>
      /* table ပေါ်မကျအောင် */
    }

    .back-btn:hover {
      background-color: #0056b3;
    }

    table{
    	width: 100%;
            border-collapse: collapse;
    }

    th,
    td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: center;
    }

    th {
      background-color: #004b75;
      color: white;
    }

    tr:nth-child(even) {
      background-color: #f9f9f9;
    }

    .book-btn {
      padding: 7px 20px;
      width : 100px;
      background-color: #28a745;
      color: white;
      border: none;
      border-radius: 3px;
      cursor: pointer;
      transition: background 0.3s;
      font-size: 14px;
      text-decoration: none;
      display: inline-block;
    }

    .book-btn:hover {
      background-color: #1e7e34;
    }
    
    .container {
            width: 1230px;
            margin: 10px auto;
            background-color: #fff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<!-- Navbar -->
  <div class="navbar">
    <div class="logo"><i class="fa-solid fa-plane-departure"></i> Aurora</div>
    <div class="nav-links">
      <a href="<%=request.getContextPath()%>/JSPView/homeUser.jsp" >Home</a>
      <a href="<%=request.getContextPath()%>/JSPView/searchFlightUser.jsp" class="active">Search Flight</a>
      
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

      <a href="<%=request.getContextPath()%>/JSPView/contactAdmin.jsp">Message</a>
      <a href="<%=request.getContextPath()%>/userController?action=logout">Logout</a>
 	</div>
  </div>
<!--End of Navbar-->
    <header>
  <h1>Aurora</h1>
  <%-- <% 
      Model.User user = (Model.User) session.getAttribute("loggedInUser"); 
      if (user != null) { 
  %>
      <p style="color: #ffff99;">Logged in as: <%= user.getFullName() %> (ID: <%= user.getUserID() %>)</p>
  <% } %> --%>
</header>

<!-- Back Button -->
 <div class="container">
  <h2>Available Flights</h2>
<form action="<%=request.getContextPath()%>/JSPView/searchFlightUser.jsp" method="post">
    <button type="submit" class="back-btn">← Back</button>
</form>
 

    <%
    
    if (flights != null && !flights.isEmpty()) {
%>
      
        <table>
            <tr>
                <th>Flight No</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>Departure</th>
                <th>Price</th>
                <th>Available Seats</th>
                <th>Action</th>
            </tr>
            <%
            for (Flight f : flights) {
                if (f.getAvailableSeats() >= numPassengers) { // show only if enough seats
        %>
                <tr>
                    <td><%= f.getFlightNumber() %></td>
                    <td><%= f.getOrigin() %></td>
                    <td><%= f.getDestination() %></td>
                    <td><%= f.getDeparture() %></td>
                    <td>$<%= f.getPrice() %></td>
                    <td><%= f.getAvailableSeats() %></td>
                    <td>
                        <form action="/FlightReservationSystem/bookingController" method="post">
                            <input type="hidden" name="action" value="bookForm"/>
	                        <input type="hidden" name="flightId" value="<%= f.getFlightID() %>"/>
	                        <input type="hidden" name="numPassengers" value="<%= numPassengers %>"/>
	                        <button type="submit" class="book-btn">Book</button>
                        </form>
                    </td>
                </tr>
            <%
                }
            }
            %>
        </table>
  
       </div>
         <%
        } else {
    %>
        <p style="text-align:center; color:red;">No flights available for your search.</p>
    <%
        }
    %>

    


</body>
</html>
