	package DAO;
	
	import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

import Database.DBConnection;
import Model.Flight;
import Model.Passenger;
	
	public class passengerDAO {
	
	    // ------------------- Add Passenger -------------------
		public boolean addPassenger(Passenger passenger, int bookingId) {
		    String sql = "INSERT INTO PASSENGER (bookingID, fullName, gender, age, passportOrNRC) VALUES (?,?,?,?,?)";
		    try (Connection conn = DBConnection.getConnection();
		         PreparedStatement ps = conn.prepareStatement(sql)) {
		        
		        ps.setInt(1, bookingId);
		        ps.setString(2, passenger.getFullName());
		        ps.setString(3, passenger.getGender());      // gender is 3rd
		        ps.setInt(4, passenger.getAge());            // age is 4th
		        ps.setString(5, passenger.getPassportOrNRC());// passportOrNRC is 5th
		        
		        int rows = ps.executeUpdate();
		        System.out.println("Rows inserted: " + rows + " for passenger " + passenger.getFullName());
		        return rows > 0;
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return false;
		}


	 
	    
		public List<Passenger> getAllPassengers() {
		    List<Passenger> list = new ArrayList<>();
		    try (Connection conn = DBConnection.getConnection();
		         Statement stmt = conn.createStatement();
		         ResultSet rs = stmt.executeQuery("SELECT * FROM passenger")) {
		        while (rs.next()) {
		            Passenger p = new Passenger();
		            p.setPassengerID(rs.getInt("passengerID"));
		            p.setBookingID(rs.getInt("bookingID"));
		            p.setFullName(rs.getString("fullName"));
		           
		            p.setPassportOrNRC(rs.getString("passportOrNRC"));
		            p.setGender(rs.getString("gender"));
		            p.setAge(rs.getInt("age"));
		            p.setTicketNumber(rs.getString("ticketNumber"));
		         
		            
		            list.add(p);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return list;
		}

	
	    // ------------------- Get Passengers By Booking -------------------
	    public List<Passenger> getPassengersByBooking(int bookingId) {
	        List<Passenger> passengers = new ArrayList<>();
	        String sql = "SELECT * FROM PASSENGER WHERE bookingID=?";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            
	            ps.setInt(1, bookingId);
	            try (ResultSet rs = ps.executeQuery()) {
	                while (rs.next()) {
	                    Passenger p = new Passenger();
	                    p.setPassengerID(rs.getInt("passengerID"));
	                    p.setBookingID(rs.getInt("bookingID"));
	                    p.setFullName(rs.getString("fullName"));
	                    p.setAge(rs.getInt("age"));
	                    p.setGender(rs.getString("gender"));
	                    p.setPassportOrNRC(rs.getString("passportNo"));
	                    passengers.add(p);
	                }
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return passengers;
	    }
	
	    // ------------------- Delete Passenger -------------------
	    public boolean deletePassenger(int passengerId) {
	        String sql = "DELETE FROM PASSENGER WHERE passengerID=?";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {
	            
	            ps.setInt(1, passengerId);
	            int rows = ps.executeUpdate();
	            return rows > 0;
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return false;
	    }
	    
	    // --------Get Passenger Ticket-------
	    public List<Passenger> getTicketsByUserID(int userID) {
	        List<Passenger> tickets = new ArrayList<>();
	        String sql = "SELECT p.passengerID, p.fullname AS passengerName, p.ticketNumber, " +
	                     "f.flightID, f.flightNumber, f.origin, f.destination, f.departureTime, f.arrivalTime " +
	                     "FROM passenger p " +
	                     "INNER JOIN Booking b ON p.bookingID = b.bookingID " +
	                     "INNER JOIN Flight f ON b.flightID = f.flightID " +
	                     "WHERE b.userID = ? " +
	                     "ORDER BY f.departureTime, p.passengerID";

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setInt(1, userID);
	            ResultSet rs = ps.executeQuery();

	            while (rs.next()) {
	            	Timestamp depTs = rs.getTimestamp("departureTime");
			        LocalDateTime departureTime = depTs != null ? depTs.toLocalDateTime() : null;
			        
			        Timestamp arrivalTs = rs.getTimestamp("arrivalTime");
			        LocalDateTime arrivalTime = arrivalTs != null ? arrivalTs.toLocalDateTime() : null;
			        
	                Flight flight = new Flight();
	                flight.setFlightID(rs.getInt("flightID"));
	                flight.setFlightNumber(rs.getString("flightNumber"));
	                flight.setOrigin(rs.getString("origin"));
	                flight.setDestination(rs.getString("destination"));
	                flight.setDeparture(departureTime);
	                flight.setArrival(arrivalTime);

	                Passenger passenger = new Passenger(
	                    rs.getInt("passengerID"),
	                    userID,                       // bookingID or userID
	                    rs.getString("passengerName"),
	                    rs.getString("ticketNumber"),
	                    flight
	                );

	                tickets.add(passenger);
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return tickets;
	    }
	
	}

