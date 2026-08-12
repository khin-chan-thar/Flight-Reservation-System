package Controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

import DAO.flightDAO;
import Model.Flight;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class flightController extends HttpServlet {
	
protected void doGet(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
		  String action = request.getParameter("action");
			if ("viewAllFlights".equals(action)) {

			    try {
			        // 1️⃣ Create DAO instance
			        flightDAO flightDAO = new flightDAO(); // make sure you have this DAO class
			        
			        // 2️⃣ Fetch all flights from database
			        List<Flight> allFlights = flightDAO.viewAllFlights();
			        System.out.println("Fetched " + allFlights.size() + " flights from DB.");

			        // 3️⃣ Set flights in request scope for JSP
			        request.setAttribute("allFlights", allFlights);

			        // 4️⃣ Forward to JSP
			        request.getRequestDispatcher("/JSPView/viewAllFlights.jsp").forward(request, response);
			        System.out.println("Forwarded to viewFlightsUser.jsp successfully.");

			    } catch (Exception e) {
			        e.printStackTrace();
			        request.setAttribute("errorMessage", "Failed to fetch flights: " + e.getMessage());
			        request.getRequestDispatcher("/JSPView/errorPageFailLoadFlights.jsp").forward(request, response);
			    }
			}
	        try {
	            flightDAO dao = new flightDAO();
	             action = request.getParameter("action");
	            int flightID = request.getParameter("id") != null ? Integer.parseInt(request.getParameter("id")) : 0;

	            if ("delete".equals(action) && flightID > 0) {
	                dao.deleteFlight(flightID);
	                response.sendRedirect("JSPView/manageFlight.jsp");
	                return;
	            }

	            if ("edit".equals(action) && flightID > 0) {
	                Flight f = dao.getFlightById(flightID);
	                request.setAttribute("flight", f);
	                request.getRequestDispatcher("JSPView/editFlight.jsp").forward(request, response);
	                return;
	            }

	            if ("view".equals(action) && flightID > 0) {
	                Flight f = dao.getFlightById(flightID);
	                request.setAttribute("flight", f);
	                request.getRequestDispatcher("JSPView/viewFlight.jsp").forward(request, response);
	                return;
	            }

	            // Default: list all flights
	            List<Flight> flights = dao.getAllFlights();
	            request.setAttribute("flights", flights);
	            request.getRequestDispatcher("JSPView/manageFlight.jsp").forward(request, response);

	        } catch (Exception e) {
	            e.printStackTrace();
	            response.getWriter().println("Error: " + e.getMessage());
	        }
	    }
	  
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    if ("saveFlights".equals(action)) {
        saveOrUpdateFlight(request, response);
    } else if ("searchFlights".equals(action)) {
        viewUserFlights(request, response);
    } else if ("editFlights".equals(action)) {
    	saveOrUpdateFlight(request, response);
    }
}

private void saveOrUpdateFlight(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    try {
        String flightIDStr = request.getParameter("flightID");
        String flightNumber = request.getParameter("flightNumber");
      
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");

        // Parse timestamps from input type="datetime-local"
        Timestamp departureTime = Timestamp.valueOf(request.getParameter("departureTime").replace("T"," ") + ":00");
        Timestamp arrivalTime = Timestamp.valueOf(request.getParameter("arrivalTime").replace("T"," ") + ":00");

        double price = Double.parseDouble(request.getParameter("price"));
        int seats = Integer.parseInt(request.getParameter("availableSeats"));
        int aircraftID = Integer.parseInt(request.getParameter("aircraftID"));
        int airlineID = Integer.parseInt(request.getParameter("airlineID"));

        Flight f = new Flight();
        f.setFlightNumber(flightNumber);
   
        f.setOrigin(origin);
        f.setDestination(destination);
        f.setDepartureTime(departureTime);
        f.setArrivalTime(arrivalTime);
        f.setPrice(price);
        f.setAvailableSeats(seats);
        f.setAircraftID(aircraftID);
        f.setAirlineID(airlineID);

        flightDAO dao = new flightDAO();
        boolean success;

        if (flightIDStr != null && !flightIDStr.isEmpty()) {
            f.setFlightID(Integer.parseInt(flightIDStr));
            success = dao.updateFlight(f);
        } else {
            success = dao.addFlight(f);
        }

        if (success) {
            request.setAttribute("successMessage", "Flight saved successfully!");
        } else {
            request.setAttribute("errorMessage", "Flight could not be saved!");
        }

        request.getRequestDispatcher("JSPView/manageFlight.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", e.getMessage());
        request.getRequestDispatcher("JSPView/manageFlight.jsp").forward(request, response);
    }
}

private void viewUserFlights(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    try {
        String fromCity = request.getParameter("from");
        String toCity = request.getParameter("to");
        String dateStr = request.getParameter("date");
        int numPassengers = Integer.parseInt(request.getParameter("numPassengers"));

        LocalDate departureDate = null;
        if (dateStr != null && !dateStr.isEmpty()) {
            departureDate = LocalDate.parse(dateStr); // yyyy-MM-dd format from input type="date"
        }

        flightDAO flightDao = new flightDAO();
        List<Flight> flights = flightDao.viewUserFlights(fromCity, toCity, departureDate);

        // Filter flights by available seats
        flights.removeIf(f -> f.getAvailableSeats() < numPassengers);

        request.setAttribute("flights", flights);
        request.setAttribute("numPassengers", numPassengers);

        // Save search in session
        HttpSession session = request.getSession();
        session.setAttribute("lastFlights", flights);
        session.setAttribute("lastNumPassengers", numPassengers);
        session.setAttribute("lastFrom", fromCity);
        session.setAttribute("lastTo", toCity);
        session.setAttribute("lastDate", departureDate);

        request.getRequestDispatcher("/JSPView/viewFlightsUser.jsp").forward(request, response);

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("errorMessage", e.getMessage());
        request.getRequestDispatcher("/JSPView/viewFlightsUser.jsp").forward(request, response);
    }
}

	
}