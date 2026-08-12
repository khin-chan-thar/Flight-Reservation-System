package DAO;

import java.sql.*;
import java.util.*;

import Database.DBConnection;
import Model.Aircraft;

public class aircraftDAO {

    // Add new aircraft
	public boolean addAircraft(Aircraft a) {
	    // Check if model already exists
	    String checkSql = "SELECT COUNT(*) FROM Aircraft WHERE model=?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement checkPst = conn.prepareStatement(checkSql)) {
	        checkPst.setString(1, a.getModel());
	        try (ResultSet rs = checkPst.executeQuery()) {
	            if(rs.next() && rs.getInt(1) > 0) {
	                throw new RuntimeException("Duplicate Aircraft Number!");
	            }
	        }

	        // Insert if not duplicate
	        String sql = "INSERT INTO Aircraft(model, totalSeat, airlineID, status) VALUES (?, ?, ?, ?)";
	        try (PreparedStatement pst = conn.prepareStatement(sql)) {
	            pst.setString(1, a.getModel());
	            pst.setInt(2, a.getTotalSeat());
	            pst.setInt(3, a.getAirlineID());
	            pst.setString(4, a.getStatus());

	            int row = pst.executeUpdate();
	            return row > 0;
	        }
	    } catch(Exception e) {
	        e.printStackTrace();
	        throw new RuntimeException(e.getMessage());
	    }
	}


    // Get all aircraft
    public List<Aircraft> getAllAircraft() {
        List<Aircraft> list = new ArrayList<>();
        String sql = "SELECT ac.*, al.name AS airlineName FROM Aircraft ac " +
                     "LEFT JOIN Airline al ON ac.airlineID = al.airlineID " +
                     "ORDER BY ac.aircraftID DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while(rs.next()) {
                list.add(mapResultSetToAircraft(rs));
            }

        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get aircraft by ID
    public Aircraft getAircraftById(int id) {
        String sql = "SELECT ac.*, al.name AS airlineName FROM Aircraft ac " +
                     "LEFT JOIN Airline al ON ac.airlineID = al.airlineID WHERE ac.aircraftID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, id);
            try(ResultSet rs = pst.executeQuery()) {
                if(rs.next()) return mapResultSetToAircraft(rs);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update aircraft
    public boolean updateAircraft(Aircraft a) {
        String sql = "UPDATE Aircraft SET model=?, totalSeat=?, airlineID=?, status=? WHERE aircraftID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, a.getModel());
            pst.setInt(2, a.getTotalSeat());
            pst.setInt(3, a.getAirlineID());
            pst.setString(4, a.getStatus());
            pst.setInt(5, a.getAircraftID());

            int row = pst.executeUpdate();
            return row > 0;
        } catch(SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete aircraft
    public boolean deleteAircraft(int id) {
        String sql = "DELETE FROM Aircraft WHERE aircraftID=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, id);
            int row = pst.executeUpdate();
            return row > 0;
        } catch(SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Search aircraft by model or airline
    public List<Aircraft> searchAircraft(String keyword) {
        List<Aircraft> list = new ArrayList<>();
        String sql = "SELECT ac.*, al.name AS airlineName FROM Aircraft ac " +
                     "LEFT JOIN Airline al ON ac.airlineID = al.airlineID " +
                     "WHERE ac.model LIKE ? OR al.name LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {

            String kw = "%" + keyword + "%";
            pst.setString(1, kw);
            pst.setString(2, kw);

            try(ResultSet rs = pst.executeQuery()) {
                while(rs.next()) list.add(mapResultSetToAircraft(rs));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Map ResultSet to Aircraft object
    private Aircraft mapResultSetToAircraft(ResultSet rs) throws SQLException {
        Aircraft a = new Aircraft();
        a.setAircraftID(rs.getInt("aircraftID"));
        a.setModel(rs.getString("model"));
        a.setTotalSeat(rs.getInt("totalSeat"));
        a.setAirlineID(rs.getInt("airlineID"));
        a.setStatus(rs.getString("status"));
        a.setAirlineName(rs.getString("airlineName"));
       
        return a;
    }
}
