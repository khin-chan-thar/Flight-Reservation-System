package Controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import DAO.bookingDAO;
import DAO.*;
import DAO.passengerDAO;
import Model.Booking;
import Model.Flight;
import Model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.*;


@SuppressWarnings("serial")
public class bookingController extends HttpServlet {
	  private flightDAO flightDAO = new flightDAO();
	    private bookingDAO bookingDAO = new bookingDAO();
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int bookingID = Integer.parseInt(request.getParameter("bookingID"));
        response.setContentType("application/json");

        try {
            bookingDAO bdao = new bookingDAO();
            flightDAO fdao = new flightDAO();
            passengerDAO pdao = new passengerDAO();

            Booking booking = bdao.getBookingByID(bookingID);
            Flight flight = fdao.getFlightById(booking.getFlightID());
            List<Passenger> passengers = pdao.getPassengersByBooking(bookingID);

            JSONObject json = new JSONObject();
            json.put("booking", new JSONObject(booking));
            json.put("flight", new JSONObject(flight));
            JSONArray arr = new JSONArray();
            for (Passenger p : passengers) {
                arr.put(new JSONObject(p));
            }
            json.put("passengers", arr);

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        //using session
        HttpSession session = request.getSession();
        
        session.setAttribute("b", session.getAttribute("a"));
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            request.setAttribute("errorMessage", "You must be logged in to book a flight!");
            request.getRequestDispatcher("/JSPView/loginUser.jsp").forward(request, response);
            return;
        }
        else if ("bookForm".equals(action)) {
            // 1️⃣ Get flight and numPassengers from request
            int flightId = Integer.parseInt(request.getParameter("flightId"));
            int numPassengers = Integer.parseInt(request.getParameter("numPassengers"));

            // 2️⃣ Get flight from DAO
            Flight flight = flightDAO.searchUserFlights(flightId);
            if (flight == null) {
                request.setAttribute("errorMessage", "Flight not found!");
                request.getRequestDispatcher("/JSPView/ViewFlightsUser.jsp").forward(request, response);
                return;
            }

            // 3️⃣ Check available seats
            if (numPassengers > flight.getAvailableSeats()) {
                request.setAttribute("errorMessage", "Only " + flight.getAvailableSeats() + " seats available!");
                request.getRequestDispatcher("/JSPView/errorPageNOseat.jsp").forward(request, response);
                return;
            }

            // 4️⃣ Update session with selected flight and numPassengers
            session.setAttribute("selectedFlight", flight);
            session.setAttribute("numPassengers", numPassengers);

            // 5️⃣ Update passengers list from request (if any), else keep session data
            List<Passenger> passengers = (List<Passenger>) session.getAttribute("passengers");
            if (passengers == null) passengers = new ArrayList<>();

            for (int i = 1; i <= numPassengers; i++) {
                String name = request.getParameter("name" + i);
                if (name != null) { // form submitted previously
                    Passenger p = (i <= passengers.size()) ? passengers.get(i - 1) : new Passenger();
                    p.setFullName(name);
                    p.setAge(Integer.parseInt(request.getParameter("age" + i)));
                    p.setGender(request.getParameter("gender" + i));
                    p.setPassportOrNRC(request.getParameter("passport" + i));
                    if (i > passengers.size()) passengers.add(p);
                }
            }
            session.setAttribute("passengers", passengers);

            // 6️⃣ Forward to bookingForm.jsp
            request.setAttribute("numPassengers", numPassengers);
            request.getRequestDispatcher("/JSPView/bookingForm.jsp").forward(request, response);
        }


        else if ("bookingSummary".equals(action)) {
            // 1️⃣ Get flight and numPassengers from request
            int flightId = Integer.parseInt(request.getParameter("flightId"));
            int numPassengers = Integer.parseInt(request.getParameter("numPassengers"));

            // 2️⃣ Get flight from DAO
            Flight flight = flightDAO.searchUserFlights(flightId);
            if (flight == null) {
                request.setAttribute("errorMessage", "Flight not found!");
                request.getRequestDispatcher("/JSPView/bookingSummary.jsp").forward(request, response);
                return;
            }

            // 3️⃣ Update passengers from submitted form
            List<Passenger> passengers = new ArrayList<>();
            for (int i = 1; i <= numPassengers; i++) {
                Passenger p = new Passenger();
                p.setFullName(request.getParameter("name" + i));
                p.setAge(Integer.parseInt(request.getParameter("age" + i)));
                p.setGender(request.getParameter("gender" + i));
                p.setPassportOrNRC(request.getParameter("passport" + i));
                passengers.add(p);
            }
            session.setAttribute("passengers", passengers);

            // 4️⃣ Calculate total cost and create booking
            double totalCost = numPassengers * flight.getPrice();
            Booking booking = new Booking();
            booking.setFlightID(flightId);
            booking.setNumOfPassengers(numPassengers);
            booking.setBookingDate(LocalDate.now());
            booking.setStatus("Pending");
            booking.setTotalCost(totalCost);
            booking.setUserID(user.getUserID());
            String bookingCode = "BKG" + (((int) (Math.random() * 1000) + 1));
            booking.setBookingCode(bookingCode);

            session.setAttribute("selectedFlight", flight);
            session.setAttribute("numPassengers", numPassengers);
            session.setAttribute("pendingBooking", booking);

            // 5️⃣ Forward to bookingSummary.jsp
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/JSPView/bookingSummary.jsp").forward(request, response);
        }


        // ------------------ SAVE BOOKING AFTER PAYMENT ------------------
        else if ("proceedPayment".equals(action)) {

            Booking booking = (Booking) session.getAttribute("pendingBooking");
            if (booking == null) {
                request.setAttribute("errorMessage", "No booking found in session!");
                request.getRequestDispatcher("/JSPView/bookingSummary.jsp").forward(request, response);
                return;
            }

            // 1️⃣ Build passengers list from request
            List<Passenger> passengers = new ArrayList<>();
            for (int i = 1; i <= booking.getNumOfPassengers(); i++) {
                String name = request.getParameter("name" + i);
                String ageStr = request.getParameter("age" + i);
                String gender = request.getParameter("gender" + i);
                String passportNo = request.getParameter("passport" + i);

                if (name == null || ageStr == null || gender == null || passportNo == null ||
                    name.isEmpty() || ageStr.isEmpty() || gender.isEmpty() || passportNo.isEmpty()) {
                    request.setAttribute("errorMessage", "All passenger details required for passenger " + i);
                    request.getRequestDispatcher("/JSPView/errorPagepassengerRequired.jsp").forward(request, response);
                    return;
                }

                int age;
                try {
                    age = Integer.parseInt(ageStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid age for passenger " + i);
                    request.getRequestDispatcher("/JSPView/errorPageInvalidPassenger.jsp").forward(request, response);
                    return;
                }

                Passenger passenger = new Passenger();
                passenger.setFullName(name);
                passenger.setAge(age);
                passenger.setGender(gender);
                passenger.setPassportOrNRC(passportNo);
                passengers.add(passenger);
            }

            // 2️⃣ Create placeholder payment
            Payment payment = new Payment();
            payment.setBookingID(booking.getBookingID());
            payment.setUserID(user.getUserID());
            payment.setAmount(booking.getTotalCost());
            payment.setStatus("Pending");
            payment.setPaymentMethod("");    // empty for now
            payment.setTransactionID("");    // empty for now
            payment.setPaymentDate(null);    // not paid yet

            // 3️⃣ Save everything via bookingService
            boolean saved = bookingDAO.saveBookingWithPassengers(booking, payment, passengers);

            if (saved) {
                // Remove from session
                session.removeAttribute("pendingBooking");

                // Store booking for confirmation or payment page
                booking.setPayment(payment);
                session.setAttribute("booking", booking);
                request.setAttribute("booking", booking);

                // Forward to payment upload page
                request.getRequestDispatcher("/JSPView/paymentUpload.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Booking failed. Please try again.");
                request.getRequestDispatcher("/JSPView/paymentUpload.jsp").forward(request, response);
            }
            
        }

     // ------------------ VIEW BOOKINGS ------------------
        else if ("viewBookings".equals(action)) {	
        
            System.out.println("Servlet hit for action: " + action);

            try {
                // 2️⃣ Create DAO instance
                bookingDAO bookingDAO = new bookingDAO();
                System.out.println("User ID " + user.getUserID());
                // 3️⃣ Fetch all bookings for this user
                List<Booking> userBookings = bookingDAO.getBookingByUserId(user.getUserID());
                System.out.println("Fetched " + userBookings.size() + " bookings for userID=" + user.getUserID());

                // 4️⃣ Set bookings in request scope for JSP
                request.setAttribute("userBookings", userBookings);
               
                // 5️⃣ Forward to JSP
                request.getRequestDispatcher("/JSPView/viewBookingStatus.jsp").forward(request, response);
                System.out.println("Forwarded to viewBookingStatus.jsp successfully.");

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Failed to fetch bookings: " + e.getMessage());
                request.getRequestDispatcher("/JSPView/errorPageFailLoadBookings.jsp").forward(request, response);
            }
        }
        
        if ("myTicket".equalsIgnoreCase(action)) {
            passengerDAO passengerDAO = new passengerDAO();
            List<Passenger> tickets = passengerDAO.getTicketsByUserID(user.getUserID());
            request.setAttribute("tickets", tickets);
            request.getRequestDispatcher("/JSPView/myTicket.jsp").forward(request, response);
            return;
        }


//

    }
    
}