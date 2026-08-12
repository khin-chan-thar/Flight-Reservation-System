<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="Model.Booking, Model.Flight, Model.Passenger" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    session = request.getSession();
    Flight flight = (Flight) session.getAttribute("selectedFlight");
    if (flight == null) flight = new Flight();

    Integer numPassengers = (Integer) request.getAttribute("numPassengers");
    if (numPassengers == null) numPassengers = (Integer) session.getAttribute("numPassengers");
    if (numPassengers == null) numPassengers = 1;
    session.setAttribute("numPassengers", numPassengers);

    List<Passenger> passengers = (List<Passenger>) session.getAttribute("passengers");
    if (passengers == null) passengers = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Flight</title>
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

        .container { width: 700px; margin: auto; background: #fff; padding: 2rem; border-radius: 12px; box-shadow: 0 6px 18px rgba(0,0,0,0.1); margin-top: 100px; }
        h1 { text-align: center; color: #004b75; margin-bottom: 20px; }
        fieldset { border: 1px solid #ccc; border-radius: 8px; padding: 16px; margin-bottom: 20px; }
        legend { font-weight: 600; color: #374151; }
        .form-grid { display: grid; grid-template-columns: 1fr 2fr; gap: 12px 16px; align-items: center; margin-top: 12px; }
        label { font-size: 14px; color: #374151; padding-top:10px; }
        input[type="text"], input[type="number"] { padding: 8px; border-radius: 6px; border: 1px solid #ccc; width: 100%; margin-bottom:10px; }
        .gender-options { display: flex; gap: 16px; margin-bottom:10px; }
        .summaryBtn { background: #004b75; color: white; border: none; border-radius: 8px; width: 220px; height: 40px; font-size: 15px; font-weight: 600; cursor: pointer; display: block; margin: 10px auto; }
        .summaryBtn:hover { background: #0066cc; }
        .back-btn { display: inline-block; margin-bottom: 20px; padding: 8px 15px; background: #004b75; color: white; border-radius: 6px; text-decoration: none; }
        .error { color: red; font-weight: bold; margin-bottom: 10px; text-align:center; }
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

<div class="container">
    <a href="<%=request.getContextPath() %>/JSPView/viewFlightsUser.jsp" class="back-btn">← Back</a>

 

    <c:if test="${not empty errorMessage}">
        <div class="error">${errorMessage}</div>
    </c:if>

   <h1>Booking Flight: <%= flight.getOrigin() %> → <%= flight.getDestination() %></h1>

<form action="/FlightReservationSystem/bookingController" method="post">
    <input type="hidden" name="action" value="bookingSummary"/>
    <input type="hidden" name="flightId" value="<%= flight.getFlightID() %>"/>

    <input type="hidden" name="numPassengers" value="<%= numPassengers %>" min="1" required/>

    <% for (int i = 1; i <= numPassengers; i++) {
        Passenger p = (i <= passengers.size()) ? passengers.get(i-1) : new Passenger();
    %>
        <fieldset>
            <legend>Passenger <%= i %></legend>
            <label>Name:</label>
            <input type="text" name="name<%= i %>" value="<%= (p.getFullName() != null) ? p.getFullName() : "" %>" required/>

            <label>Age:</label>
          <input type="number" 
       name="age<%= i %>"  
       min="1" 
       max="99" 
       value="<%= (p.getAge() > 0) ? p.getAge() : "" %>" 
       oninput="if(this.value.length > 2) this.value = this.value.slice(0,2);" 
       required/>

			<label>Gender:</label>
		      <div class="gender-options">
	            <input type="radio" name="gender<%= i %>" value="Male" <%= "Male".equals(p.getGender()) ? "checked" : "" %> /> Male
	            <input type="radio" name="gender<%= i %>" value="Female" <%= "Female".equals(p.getGender()) ? "checked" : "" %> /> Female
			 </div>
            <label>Passport:</label>
			<input type="text" 
		       name="passport<%= i %>" 
		       value="<%= (p.getPassportOrNRC() != null) ? p.getPassportOrNRC() : "" %>" 
		       pattern="^[A-Za-z0-9]{6,9}$" 
		       title="Passport must be 6–9 characters long and contain only letters and numbers." 
		       required/>
</fieldset>
    <% } %>

    <button type="submit" class="summaryBtn">Show Booking Summary</button>
</form>

</div>

</body>
</html>
