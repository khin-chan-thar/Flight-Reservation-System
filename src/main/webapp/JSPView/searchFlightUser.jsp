<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date"%>
<%
    String lastFrom = (String) session.getAttribute("lastFrom");
    String lastTo = (String) session.getAttribute("lastTo");
    Object lastDateObj = session.getAttribute("lastDate"); // could be Date or Timestamp
    Integer lastNumPassengers = (Integer) session.getAttribute("lastNumPassengers");

    String lastDateStr = "";
    if (lastDateObj != null) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        if (lastDateObj instanceof Date) {
            lastDateStr = sdf.format((Date) lastDateObj);
        } else {
            lastDateStr = lastDateObj.toString(); // fallback, if already string
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Search Flights</title>
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
  
   .container {
        display: flex;
        padding: 20px;
      }

      .SF {
        text-align: center;
        padding-bottom: 10px;
      }

      /* Search Flights */
      .SearchForm {
      margin-top : 15px;
        padding-top: 10px;
      }

      .container {
        font-size: 15px;
        font-weight: bold;
        display: none;
        padding: 30px;
        max-width: 600px;
        margin: 20px auto;
        background: white;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
      }

      input,
      select,
      button {
        width: 100%;
        padding: 15px;
        margin: 5px 0;
        border: 1px solid #ccc;
        border-radius: 5px;
      }

      .searchBtn {
        background: #004b75;
        color: white;
        cursor: pointer;
        margin-top: 15px;
      }

      .searchBtn:hover {
        background: #0066cc;
      }

      .searchBtn:disabled {
        background: gray;
        cursor: not-allowed;
      }
</style>
</head>
<script>
      function updateDestination() {
        const fromSelect = document.querySelector("select[name='from']");
        const toSelect = document.querySelector("select[name='to']");

        // Enable all options first
        for (let option of toSelect.options) {
          option.disabled = false;
        }

        // Disable the same option as selected in "From"
        if (fromSelect.value) {
          for (let option of toSelect.options) {
            if (option.value === fromSelect.value) {
              option.disabled = true;
            }
          }
        }

        // If "To" is the same as "From", reset it
        if (toSelect.value === fromSelect.value) {
          toSelect.value = "";
        }
      }

      function saveFormData(formId, storageKey) {
        const form = document.getElementById(formId);
        form.addEventListener("input", () => {
          const formData = new FormData(form);
          let obj = {};
          formData.forEach((value, key) => obj[key] = value);
          localStorage.setItem(storageKey, JSON.stringify(obj));
        });
      }

      function restoreFormData(formId, storageKey) {
        const form = document.getElementById(formId);
        const saved = localStorage.getItem(storageKey);
        if (saved) {
          const data = JSON.parse(saved);
          for (let key in data) {
            const input = form.querySelector(`[name="${key}"]`);
            if (input) {
              if (input.type === "radio" || input.type === "checkbox") {
                if (input.value === data[key]) input.checked = true;
              } else {
                input.value = data[key];
              }
            }
          }
        }
      }

      document.addEventListener("DOMContentLoaded", () => {
        saveFormData("searchForm", "searchFormData");
        restoreFormData("searchForm", "searchFormData");
        document.getElementById("searchForm").addEventListener("submit", () => {
          localStorage.removeItem("searchFormData");
        });
      });

    </script>
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
	 

  <h1>Aurora</h1>
  <% 
      Model.User user = (Model.User) session.getAttribute("loggedInUser"); 
      if (user != null) { 
  %>
      <p style="color: #ffff99;">Logged in as: <%= user.getFullName() %> (ID: <%= user.getUserID() %>)</p>
  <% } %>
</header>

   <div class="SearchForm">
      <div id="searchFlight" class="container" style="display: block">
        <h2 class="SF">Search Flights</h2>
    <form action="/FlightReservationSystem/flightController" method="POST">
    <input type="hidden" name="action" value="searchFlights"/>
      <label>From:</label>
      <select name="from" required onchange="updateDestination()">
    <option value="">-- Select Origin --</option>
    <option value="Yangon" <%= "Yangon".equals(lastFrom) ? "selected" : "" %>>Yangon</option>
    <option value="Mandalay" <%= "Mandalay".equals(lastFrom) ? "selected" : "" %>>Mandalay</option>
    <option value="Naypyitaw" <%= "Naypyitaw".equals(lastFrom) ? "selected" : "" %>>Naypyitaw</option>
    <option value="Bagan" <%= "Bagan".equals(lastFrom) ? "selected" : "" %>>Bagan</option>
    <option value="Tachileik" <%= "Tachileik".equals(lastFrom) ? "selected" : "" %>>Tachileik</option>
</select>

<label>To:</label>
<select name="to" required>
    <option value="">-- Select Destination --</option>
    <option value="Yangon" <%= "Yangon".equals(lastTo) ? "selected" : "" %>>Yangon</option>
    <option value="Mandalay" <%= "Mandalay".equals(lastTo) ? "selected" : "" %>>Mandalay</option>
    <option value="Naypyitaw" <%= "Naypyitaw".equals(lastTo) ? "selected" : "" %>>Naypyitaw</option>
    <option value="Bagan" <%= "Bagan".equals(lastTo) ? "selected" : "" %>>Bagan</option>
    <option value="Tachileik" <%= "Tachileik".equals(lastTo) ? "selected" : "" %>>Tachileik</option>
</select>

<label>Date:</label>
<input type="date" name="date" value="<%= lastDateStr %>" required />

<label>Number of Passengers:</label>
<input type="number" name="numPassengers" min="1" max="5" 
       value="<%= lastNumPassengers != null ? lastNumPassengers : 1 %>"  required />	
      <button type="submit" class="searchBtn">Search Available Flight</button>
    </form>

    </div>
    </div>
  </body>
</html>
