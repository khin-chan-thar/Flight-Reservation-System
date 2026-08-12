package DAO;

import java.sql.*;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.*;

import Database.DBConnection;
import Model.Booking;
import Model.Flight;
import Model.Passenger;
import Model.Payment;

public class bookingDAO {

    public List<Booking> getAllBookings() throws Exception {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking ORDER BY bookingID DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setBookingCode(rs.getString("bookingCode"));
                b.setUserID(rs.getInt("userID"));
                b.setFlightID(rs.getInt("flightID"));
                java.sql.Date sqlDate = rs.getDate("bookingDate");
                if (sqlDate != null) {
                    b.setBookingDate(sqlDate.toLocalDate());
                }
                b.setStatus(rs.getString("status"));
                b.setTotalCost(rs.getDouble("totalCost"));
                list.add(b);
            }
        }
        return list;
    }
    
    
    
   public List<Booking> getAll() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking ORDER BY bookingID DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("bookingID"));
                b.setBookingCode(rs.getString("bookingCode"));
                b.setUserID(rs.getInt("userID"));
                b.setFlightID(rs.getInt("flightID"));
                java.sql.Date sqlDate = rs.getDate("bookingDate");
                if (sqlDate != null) {
                    b.setBookingDate(sqlDate.toLocalDate());
                }
                b.setStatus(rs.getString("status"));
                b.setTotalCost(rs.getDouble("totalCost"));
                list.add(b);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    public Booking getBookingByID(int bookingID) throws Exception {
        Booking b = null;
        String sql = "SELECT * FROM Booking WHERE bookingID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    b = new Booking();
                    b.setBookingID(rs.getInt("bookingID"));
                    b.setBookingCode(rs.getString("bookingCode"));
                    b.setUserID(rs.getInt("userID"));
                    b.setFlightID(rs.getInt("flightID"));
                    java.sql.Date sqlDate = rs.getDate("bookingDate");
                    if (sqlDate != null) {
                        b.setBookingDate(sqlDate.toLocalDate());
                    }
                    b.setStatus(rs.getString("status"));
                    b.setTotalCost(rs.getDouble("totalCost"));
                }
            }
        }
        return b;
    }
    
    public boolean updateBookingFlight(int bookingID, int newFlightID) {
        String sql = "UPDATE Booking b " +
                     "JOIN Flight f ON f.flightID = ? " +
                     "SET b.flightID = ?, b.totalCost = f.price " +
                     "WHERE b.bookingID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newFlightID);  // for JOIN
            ps.setInt(2, newFlightID);  // set new flightID
            ps.setInt(3, bookingID);    // which booking to update

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    

    // ----------------- UPDATE -----------------
    public boolean updateBooking(Booking booking) {
    	String sql = "UPDATE booking SET userID=?, flightID=?, bookingDate=?, status=?, totalCost=?, numOfPassengers=? "
    	           + "WHERE bookingID=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, booking.getUserID());
            ps.setInt(2, booking.getFlightID());
            ps.setDate(3, Date.valueOf(booking.getBookingDate()));
            ps.setString(4, booking.getStatus());
            ps.setDouble(5, booking.getTotalCost());
            ps.setInt(6, booking.getNumOfPassengers());
            ps.setInt(7, booking.getBookingID());

            return ps.executeUpdate() > 0; // true if update successful
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // ----------------- DELETE -----------------
    public boolean deleteBooking(int bookingID) {
        String sql = "DELETE FROM booking WHERE bookingID=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingID);
            return ps.executeUpdate() > 0; // true if delete successful
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
//----------------------------------Thin's Code --------------------------------------//
	// ----------------- CREATE -----------------
	public int addBooking(Booking booking) {
	    String sql = "INSERT INTO booking (userID, flightID, bookingDate, status, totalCost, numOfPassengers, bookingCode) "
	               + "VALUES (?, ?, ?, ?, ?, ?, ?)";

	    int generatedId = -1;

	    // Ensure the connection and statement are closed properly by using try-with-resources
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

	        // Set parameters for the PreparedStatement
	        ps.setInt(1, booking.getUserID());
	        ps.setInt(2, booking.getFlightID());
	        ps.setDate(3, Date.valueOf(booking.getBookingDate()));
	        ps.setString(4, booking.getStatus());
	        ps.setDouble(5, booking.getTotalCost());
	        ps.setInt(6, booking.getNumOfPassengers());
	        ps.setString(7, booking.getBookingCode()); // Set bookingCode parameter

	        // Execute the update
	        int affectedRows = ps.executeUpdate();

	        // If rows were affected, retrieve the generated keys (bookingID)
	        if (affectedRows > 0) {
	            try (ResultSet rs = ps.getGeneratedKeys()) {
	                if (rs.next()) {
	                    generatedId = rs.getInt(1);  // Retrieve the first generated key (bookingID)
	                }
	            }
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return generatedId;  // Return the generated bookingID or -1 if not found
	}


    // ----------------- READ -----------------
//    public Booking getUserBookingById(int bookingID) {
//        Booking booking = null;
//        String sql = "SELECT * FROM booking WHERE bookingID = ?";
//
//        try (Connection conn = DBConnection.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, bookingID);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                booking = mapResultSetToBooking(rs);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        return booking;
//    }

    public List<Booking> getUserBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM booking";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    public List<Booking> getBookingByUserId(int userID) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM booking WHERE userID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // Map booking from ResultSet
                Booking booking = mapResultSetToBooking(rs);


                flightDAO flightDao = new flightDAO(); // create an instance
                Flight flight = flightDao.getFlightById(booking.getFlightID());
                booking.setFlight(flight);

                
                // Get payment for this booking
                Payment payment = getPaymentByBookingId(booking.getBookingID());
                if (payment != null) {
                    booking.setPayment(payment);
                }

                bookings.add(booking); // add booking (with payment if found) to list
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }
    
    private Payment getPaymentByBookingId(int bookingId) throws SQLException {
        String sql = "SELECT * FROM payment WHERE bookingID = ?";
        try (Connection conn = DBConnection.getConnection();
        		PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Convert DATETIME → LocalDateTime
                Timestamp ts = rs.getTimestamp("paymentDate");
                LocalDateTime paymentDate = (ts != null) ? ts.toLocalDateTime() : null;

                return new Payment(
                    rs.getInt("paymentID"),
                    rs.getInt("bookingID"),
                    rs.getInt("userID"),
                    rs.getDouble("amount"),
                    rs.getString("paymentMethod"),
                    rs.getString("status"),
                    paymentDate, // ✅ LocalDateTime
                    rs.getString("transactionID"),
                    (Integer) rs.getObject("adminApprovedBy")
                );
            }
        }
        return null;
    }




    // ----------------- HELPER -----------------
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingID(rs.getInt("bookingID"));
        booking.setBookingCode(rs.getString("bookingCode"));
        booking.setUserID(rs.getInt("userID"));
        booking.setFlightID(rs.getInt("flightID"));
        booking.setNumOfPassengers(rs.getInt("numOfPassengers"));


        Date bookingDate = rs.getDate("bookingDate");
        if (bookingDate != null) {
            booking.setBookingDate(bookingDate.toLocalDate());
        }

        booking.setStatus(rs.getString("status"));
        booking.setTotalCost(rs.getDouble("totalCost"));

        return booking;
    }
    public Booking getBookingByBookingCode(String bookingCode) {
        // Example query to fetch booking based on the bookingCode
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        Booking booking = null;

        try {
            connection = DBConnection.getConnection(); // Your DB connection code
            String sql = "SELECT * FROM booking WHERE bookingCode = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, bookingCode);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                booking = new Booking();
                booking.setBookingID(resultSet.getInt("bookingID"));
                booking.setBookingCode(resultSet.getString("bookingCode"));
                booking.setTotalCost(resultSet.getDouble("totalCost"));
                // Set other fields of the Booking object
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return booking; // Returns null if not found
    }
    
    public boolean saveBookingWithPassengers(Booking booking, Payment payment, List<Passenger> passengers) {
        try {
        	bookingDAO bookingDAO = new bookingDAO();
        	paymentDAO paymentDAO = new paymentDAO();
        	passengerDAO passengerDAO = new passengerDAO();
        	flightDAO flightDAO = new flightDAO();
            // 1️⃣ Save booking
            int bookingId = bookingDAO.addBooking(booking);
            if (bookingId <= 0) return false;
            booking.setBookingID(bookingId);

            // 2️⃣ Save payment
            payment.setBookingID(bookingId); // ensure correct bookingID
            int paymentId = paymentDAO.addPayment(payment);
            if (paymentId <= 0) return false;
            payment.setPaymentID(paymentId);

            // 3️⃣ Save all passengers for this booking
            for (Passenger p : passengers) {
                boolean saved = passengerDAO.addPassenger(p, bookingId);
                if (!saved) {
                    System.out.println("Failed to save passenger: " + p.getFullName());
                    return false;
                }
            }

            // 4️⃣ Update flight seats
            flightDAO.updateSeats(booking.getFlightID(), booking.getNumOfPassengers());

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }



}
