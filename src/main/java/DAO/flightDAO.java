package DAO;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

import Database.DBConnection;
import Model.Flight;

public class flightDAO {

    public boolean addFlight(Flight f) {
        String sql = "INSERT INTO Flight(flightNumber, origin, destination, departureTime, arrivalTime, price, availableSeats, aircraftID, airlineID) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, f.getFlightNumber());
            pst.setString(2, f.getOrigin());
            pst.setString(3, f.getDestination());
            pst.setTimestamp(4, f.getDepartureTime());
            pst.setTimestamp(5, f.getArrivalTime());
            pst.setDouble(6, f.getPrice());
            pst.setInt(7, f.getAvailableSeats());
            pst.setInt(8, f.getAircraftID());
            pst.setInt(9, f.getAirlineID());

            int row = pst.executeUpdate();
            return row > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            // ✅ Duplicate entry or foreign key violation
            if (e.getErrorCode() == 1062) {  
                throw new RuntimeException("Duplicate Flight Number!.");
            } else {
                throw new RuntimeException("Data constraint violation: " + e.getMessage());
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Unexpected error: " + e.getMessage());
        
        }
    }

    // Optional: Get all flights
    public List<Flight> getAllFlights() {
        List<Flight> list = new ArrayList<>();
        String sql = "SELECT f.*, a.name AS airlineName, ac.model AS aircraftModel " +
                     "FROM Flight f " +
                     "JOIN Airline a ON f.airlineID = a.airlineID " +
                     "JOIN Aircraft ac ON f.aircraftID = ac.aircraftID " +
                     "ORDER BY f.flightID DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                Flight f = new Flight();
                f.setFlightID(rs.getInt("flightID"));
                f.setFlightNumber(rs.getString("flightNumber"));
                f.setOrigin(rs.getString("origin"));
                f.setDestination(rs.getString("destination"));
                f.setDepartureTime(rs.getTimestamp("departureTime"));
                f.setArrivalTime(rs.getTimestamp("arrivalTime"));
                f.setPrice(rs.getDouble("price"));
                f.setAvailableSeats(rs.getInt("availableSeats"));
                f.setAircraftID(rs.getInt("aircraftID"));
                f.setAirlineID(rs.getInt("airlineID"));
                f.setAirlineName(rs.getString("airlineName"));
                f.setAircraftModel(rs.getString("aircraftModel"));
                list.add(f);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Flight> searchFlights(String keyword) {
        List<Flight> list = new ArrayList<>();
        String sql = "SELECT f.flightID, f.flightNumber, f.origin, f.destination, f.price, f.availableSeats, " +
                     "a.name AS airlineName, ac.model AS aircraftModel " +
                     "FROM Flight f " +
                     "LEFT JOIN Airline a ON f.airlineID = a.airlineID " +
                     "LEFT JOIN Aircraft ac ON f.aircraftID = ac.aircraftID " +
                     "WHERE f.flightNumber LIKE ? OR f.origin LIKE ? OR f.destination LIKE ? OR a.name LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            pst.setString(1, kw);
            pst.setString(2, kw);
            pst.setString(3, kw);
            pst.setString(4, kw);

            try (ResultSet rs = pst.executeQuery()) {
                while(rs.next()) {
                    Flight f = new Flight();
                    f.setFlightID(rs.getInt("flightID"));
                    f.setFlightNumber(rs.getString("flightNumber"));
                    f.setOrigin(rs.getString("origin"));
                    f.setDestination(rs.getString("destination"));
                    f.setPrice(rs.getDouble("price"));
                    f.setAvailableSeats(rs.getInt("availableSeats"));
                    f.setAirlineName(rs.getString("airlineName"));
                    f.setAircraftModel(rs.getString("aircraftModel"));
                    list.add(f);
                }
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Flight getFlightById(int flightID) {
        String sql = "SELECT f.*, a.name AS airlineName, ac.model AS aircraftModel " +
                     "FROM Flight f " +
                     "LEFT JOIN Airline a ON f.airlineID = a.airlineID " +
                     "LEFT JOIN Aircraft ac ON f.aircraftID = ac.aircraftID " +
                     "WHERE f.flightID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, flightID);
            try (ResultSet rs = pst.executeQuery()) {
                if(rs.next()) {
                    return mapResultSetToFlight(rs);
                }
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update flight
    public boolean updateFlight(Flight f) {
        String sql = "UPDATE Flight SET flightNumber=?, origin=?, destination=?, departureTime=?, arrivalTime=?, price=?, availableSeats=?, aircraftID=?, airlineID=? WHERE flightID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, f.getFlightNumber());
            pst.setString(2, f.getOrigin());
            pst.setString(3, f.getDestination());
            pst.setTimestamp(4, f.getDepartureTime());
            pst.setTimestamp(5, f.getArrivalTime());
            pst.setDouble(6, f.getPrice());
            pst.setInt(7, f.getAvailableSeats());
            pst.setInt(8, f.getAircraftID());
            pst.setInt(9, f.getAirlineID());
            pst.setInt(10, f.getFlightID());

            int row = pst.executeUpdate();
            return row > 0;
        } catch(SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete flight
    public boolean deleteFlight(int flightID) {
        String sql = "DELETE FROM Flight WHERE flightID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, flightID);
            int row = pst.executeUpdate();
            return row > 0;
        } catch(SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ====== Helper to map ResultSet to Flight object ======
    private Flight mapResultSetToFlight(ResultSet rs) throws SQLException {
        Flight f = new Flight();
        f.setFlightID(rs.getInt("flightID"));
        f.setFlightNumber(rs.getString("flightNumber"));
        f.setOrigin(rs.getString("origin"));
        f.setDestination(rs.getString("destination"));
        f.setDepartureTime(rs.getTimestamp("departureTime"));
        f.setArrivalTime(rs.getTimestamp("arrivalTime"));
        f.setPrice(rs.getDouble("price"));
        f.setAvailableSeats(rs.getInt("availableSeats"));
        f.setAircraftID(rs.getInt("aircraftID"));
        f.setAirlineID(rs.getInt("airlineID"));
        f.setAirlineName(rs.getString("airlineName"));
        f.setAircraftModel(rs.getString("aircraftModel"));
        return f;
    }
    
    //---------------------Thin's Code--------------------------//
    public List<Flight> viewUserFlights(String fromCity, String toCity, LocalDate departureDate) {
	    List<Flight> flights = new ArrayList<>();
	    
	    // SQL to match origin, destination, and departure date
	    String sql = "SELECT * FROM flight WHERE origin=? AND destination=? AND departureTime BETWEEN ? AND ?";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setString(1, fromCity);
	        ps.setString(2, toCity);

	        // Create start and end timestamps for the day
	        LocalDateTime startOfDay = departureDate.atStartOfDay();
	        LocalDateTime endOfDay = departureDate.atTime(LocalTime.MAX);

	        ps.setTimestamp(3, Timestamp.valueOf(startOfDay));
	        ps.setTimestamp(4, Timestamp.valueOf(endOfDay));

	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            Timestamp depTs = rs.getTimestamp("departureTime");
	            LocalDateTime departureTime = depTs != null ? depTs.toLocalDateTime() : null;

	            flights.add(new Flight(
	                rs.getInt("flightID"),
	                rs.getString("flightNumber"),
	                rs.getString("origin"),
	                rs.getString("destination"),
	                departureTime,
	                rs.getDouble("price"),
	                rs.getInt("availableSeats")
	            ));
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    
	    return flights;
	}
 

 public Flight searchUserFlights(int flightID) {
	    Flight flight = null;
	    String sql = "SELECT flightID, flightNumber, origin, destination, departureTime, price, availableSeats "
	               + "FROM flight WHERE flightID = ?";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, flightID);
	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            Timestamp depTs = rs.getTimestamp("departureTime");
	            LocalDateTime departureTime = depTs != null ? depTs.toLocalDateTime() : null;

	            flight = new Flight();
	            flight.setFlightID(rs.getInt("flightID"));
	            flight.setFlightNumber(rs.getString("flightNumber"));
	            flight.setOrigin(rs.getString("origin"));
	            flight.setDestination(rs.getString("destination"));
	            flight.setDeparture(departureTime); // use LocalDateTime
	            flight.setPrice(rs.getDouble("price"));
	            flight.setAvailableSeats(rs.getInt("availableSeats"));
	            
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return flight;
	}


    // Update available seats
    public void updateSeats(int flightID, int bookedSeats) {
        Flight flight = searchUserFlights(flightID);
        String sql = "UPDATE flight\r\n"
        		+ "SET availableSeats = ?\r\n"
        		+ "WHERE flightID = ?;\r\n";
        if (flight != null) {
            int remainingSeats = flight.getAvailableSeats() - bookedSeats;
            if (remainingSeats < 0) remainingSeats = 0;

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, remainingSeats);
                ps.setInt(2, flightID);
                ps.executeUpdate();

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
        
        public List<Flight> viewAllFlights() {
            List<Flight> flights = new ArrayList<>();
            String sql = "SELECT * FROM flight";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

            	while (rs.next()) {
            	    Flight f = new Flight();
            	    f.setFlightID(rs.getInt("flightID"));
            	    f.setFlightNumber(rs.getString("flightNumber"));
            	    f.setOrigin(rs.getString("origin"));
            	    f.setDestination(rs.getString("destination"));

            	    // Convert SQL Timestamp to LocalDateTime
            	    Timestamp depTs = rs.getTimestamp("departureTime");
            	    if (depTs != null) {
            	        f.setDeparture(depTs.toLocalDateTime());
            	    }

            	    Timestamp arrTs = rs.getTimestamp("arrivalTime");
            	    if (arrTs != null) {
            	        f.setArrival(arrTs.toLocalDateTime());
            	    }

            	    f.setPrice(rs.getDouble("price"));
            	    f.setAvailableSeats(rs.getInt("availableSeats"));
            	    f.setAircraftID(rs.getInt("aircraftID"));
            	    f.setAirlineID(rs.getInt("airlineID"));
            	   
            	    flights.add(f);
            	}


            } catch (SQLException e) {
                e.printStackTrace();
            }

            return flights;
        }
    

}
