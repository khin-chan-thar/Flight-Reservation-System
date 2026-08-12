<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Payment Upload - Flight Reservation System</title>
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
  .footer ul li { margin-bottom:5px; font-size:14px; }
        .form-container {
            background: white;
            padding: 2.5rem 2rem;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
            width:600px;
            height : 500px;
            text-align: center;
            margin : auto;
        }
        header h1 {
            color: #004b75;
            font-size: 28px;
            margin-bottom: 7px;
        }
        header p {
            color: #004b75;
            font-size: 14px;
            margin-bottom: 7px;
        }
        input, select {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            margin-top: 5px;
            margin-bottom: 15px;
            outline: none;
            font-size: 14px;
        }
        input:focus, select:focus {
            border-color: #004b75;
            box-shadow: 0 0 0 2px rgba(0,75,117,0.2);
        }
        .btn-submit {
            width: 100%;
            padding: 10px 0;
            background: #004b75;
            color: white;
            font-size: 16px;
            font-weight: 600;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }
        .btn-submit:hover {
            background: linear-gradient(135deg, #005c99, #0077e6);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.25);
        }
        .btn-submit:active {
            transform: translateY(0);
            box-shadow: 0 3px 6px rgba(0,0,0,0.2);
        }
        .back-btn {
            display: block;
            width: 100%;
            padding: 10px 0;
            margin-top: 15px;
            background: #004b75;
            color: white;
            text-decoration: none;
            font-weight: 600;
            border-radius: 8px;
            transition: background 0.3s;
        }
        .back-btn:hover { background: #0066cc; }
        .error-message { color: #dc2626; font-size: 13px; text-align: left; margin-bottom: 10px; }
        .success-message { color: #16a34a; font-weight: 600; margin-bottom: 15px; }
        label { display: block; font-weight: 600; color: #004b75; margin-bottom: 5px; font-size: 14px; text-align: left; }
    .disabled-link {
    pointer-events: none;    /* disables clicking */
    opacity: 0.5;            /* makes it appear disabled */
    cursor: default;         /* normal cursor */
    background: #004b75;     /* keep background consistent */
    color: #fff;             /* text color */
}
    </style>
</head>
<body>
<!-- Navbar -->
  <div class="navbar">
    <div class="logo"><i class="fa-solid fa-plane-departure"></i> Aurora</div>
    <div class="nav-links">
      <a href="<%=request.getContextPath()%>/JSPView/homeUser.jsp" class="disabled-link" >Home</a>
 
      <a href="<%=request.getContextPath()%>/JSPView/searchFlightUser.jsp" class="disabled-link">Search Flight</a>
      
       <form action="/FlightReservationSystem/flightController" method="get">
        <input type="hidden" name="action" value="viewAllFlights"/>
        <button type="submit" class="disabled-link">Flights</button>
      </form>
      
      <form action="/FlightReservationSystem/bookingController" method="post">
        <input type="hidden" name="action" value="viewBookings"/>
        <button type="submit" class="disabled-link">View Booking Status</button>
      </form>
      
      <form action="/FlightReservationSystem/bookingController" method="post">
        <input type="hidden" name="action" value="myTicket"/>
        <button type="submit" class="disabled-link">My Ticket</button>
      </form>

      <a href="<%=request.getContextPath()%>/JSPView/contactAdmin.jsp" class="disabled-link">Contact Admin</a>
      <a href="<%=request.getContextPath()%>/userController?action=logout" class="disabled-link">Logout</a>
 	</div>
  </div>
<!--End of Navbar-->
    <header>
  <h1>Aurora</h1>
  
</header>
<div class="form-container">
    <header>
        <h1> Payment Upload</h1>
        <p>Complete your payment to confirm the booking</p>
    </header>

   <!-- Display messages -->
<%
    String error = request.getParameter("error");
    if ("invalidTxId".equals(error)) {
%>
        <p class="error-message">Invalid Transaction ID. Please enter a valid ID (8-20 characters, letters, numbers, - or _).</p>
<%
    } else if ("duplicateTxId".equals(error)) {
%>
        <p class="error-message">Transaction ID already exists. Please check your ID.</p>
<%
    }
%>



    <!-- Payment Form -->
    <form action="/FlightReservationSystem/paymentController" method="post">
        <input type="hidden" name="action" value="proceedPayment" />

        <label for="bookingCode"><i class='fas fa-address-book'></i> : Booking Code</label>
        <input type="text" id="bookingCode" name="bookingCode" value="${booking.bookingCode}" readonly />

        <label for="totalCost"><i class='fas fa-donate'></i> : Amount</label>
        <input type="number" id="totalCost" name="totalCost" value="${booking.totalCost}" readonly />

        <label for="paymentMethod"><i class='fab fa-cc-apple-pay'></i> : Payment Method</label>
        <select id="paymentMethod" name="paymentMethod" required>
            <option value="Bank Transfer">Bank Transfer</option>
            <option value="Credit Card">Credit Card</option>
            <option value="Mobile Payment">Mobile Payment</option>
        </select>

        <label for="paymentTransaction"><i class='fas fa-landmark'></i> : Payment Transaction ID</label>
        <input type="text" id="paymentTransaction" name="paymentTransaction" 
               pattern="^[A-Za-z0-9-_]{8,20}$"
               title="Transaction ID must be 8-20 characters, letters, numbers, - and _" required />
        <div class="error-message" id="transactionIdError"></div>

        <button type="submit" class="btn-submit">Submit Payment</button>
    </form>

</div>

</body>
</html>
