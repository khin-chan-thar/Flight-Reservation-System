<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Model.Booking, Model.Flight, Model.Passenger" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Booking Summary</title>
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
  
    .container {
        background: white;
        margin : auto;
        width: 600px;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 6px 18px rgba(0,0,0,0.1);
        text-align: center;
    }
    

    header { text-align: center; margin-bottom: 20px; }
    header h1 { color: #004b75; font-size: 28px; margin-bottom: 5px; }
    header p { color: #ffff99; font-size: 14px; }

    .back-btn {
        display: inline-block;
        margin-bottom: 20px;
        padding: 8px 15px;
        background: #004b75;
        color: white;
        border-radius: 6px;
        font-size: 14px;
        transition: background 0.3s;
    }
    .back-btn:hover { background: #0066cc; }

    .booking-info div { margin-bottom: 10px; font-size: 16px; }
    .booking-info strong { color: #004b75; }

    .passenger-summary {
        border: 1px solid #ccc;
        border-radius: 8px;
        background: #fafafa;
        padding: 15px 20px;
        margin-bottom: 15px;
    }
    .passenger-summary h3 {
        margin-bottom: 10px;
        color: #004b75;
        border-bottom: 1px solid #ccc;
        padding-bottom: 3px;
    }
    .passenger-summary p { margin-bottom: 5px; font-size: 14px; }

    .proceedBtn {
        display: block;
        width: 220px;
        height: 40px;
        margin: 20px auto 0 auto;
        background: linear-gradient(135deg, #004b75, #0066cc);
        color: white;
        font-size: 15px;
        font-weight: 600;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        transition: all 0.3s ease;
    }
    .proceedBtn:hover {
        background: linear-gradient(135deg, #005c99, #0077e6);
        transform: translateY(-2px);
        box-shadow: 0 6px 12px rgba(0,0,0,0.25);
    }
    .proceedBtn:active {
        transform: translateY(0);
        box-shadow: 0 3px 6px rgba(0,0,0,0.2);
    }

   
      .message {
        font-size: 18px;
        color: #333;
        margin-bottom: 20px;
      }
      .info {
        color: #0066cc;
        font-weight: bold;
        font-size: 22px;
      }
      .back-button {
        background: #004080;
        color: white;
        padding: 10px 20px;
        border-radius: 5px;
        border: none;
        cursor: pointer;
        text-decoration: none;
      }
      .back-button:hover {
        background: #0066cc;
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
  
</header>

      <div class="container">
      <p class="message">
        Your payment for <span class="info">${booking.bookingCode}</span> is currently pending. Please wait while we process your payment.
      </p>
      <p class="message">
        Once the payment is confirmed, your booking will be updated. You can check the status in your booking details.
      </p>
   <a href="/FlightReservationSystem/JSPView/homeUser.jsp" class="back-button">Back to Home</a>

    </div>


</body>
</html>
