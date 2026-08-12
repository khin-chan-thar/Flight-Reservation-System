package DAO;

import Database.DBConnection;
import Model.Airline;
import java.sql.*;
import java.util.*;

public class airlineDAO {

	
    // Add Airline
    public boolean addAirline(Airline airline) {
        String sql = "INSERT INTO airline (name, code, country, status) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, airline.getName());
            ps.setString(2, airline.getCode());
            ps.setString(3, "Null");
            ps.setString(4, airline.getStatus());
            
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }
    
    // Get Airline by ID
    public Airline getAirlineById(int id) {
        Airline airline = null;
        String sql = "SELECT * FROM airline WHERE airlineID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    airline = new Airline();
                    airline.setAirlineID(rs.getInt("airlineID"));
                    airline.setName(rs.getString("name"));
                    airline.setCode(rs.getString("code"));
                    airline.setCountry(rs.getString("country"));
                    airline.setStatus(rs.getString("status"));
                    airline.setCreateAt(rs.getString("createdAt"));
                    airline.setUpdateAt(rs.getString("updatedAt"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return airline;
    }
    
	


    // Get All Airlines
    public List<Airline> listAirlines() {
        List<Airline> airlines = new ArrayList<>();
        String sql = "SELECT * FROM airline";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Airline a = new Airline();
                a.setAirlineID(rs.getInt("airlineID"));
                a.setName(rs.getString("name"));
                a.setCode(rs.getString("code"));
                a.setCountry(rs.getString("country"));
                a.setStatus(rs.getString("status"));
                airlines.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return airlines;
    }

    // Update Airline
    public boolean updateAirline(Airline airline) {
        String sql = "UPDATE airline SET name=?, code=?, country=?, status=? WHERE airlineID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, airline.getName());
            ps.setString(2, airline.getCode());
            ps.setString(3, airline.getCountry());
            ps.setString(4, airline.getStatus());
            ps.setInt(5, airline.getAirlineID());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }
    //check duplicated airline
 // Check if airline exists by name or code
    public boolean isDuplicateAirline(String name, String code) {
        String sql = "SELECT COUNT(*) FROM airline WHERE name=? OR code=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; // true if duplicate exists
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    // Delete Airline
    public boolean deleteAirline(int id) {
        String sql = "DELETE FROM airline WHERE airlineID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }
    
    
    
}
