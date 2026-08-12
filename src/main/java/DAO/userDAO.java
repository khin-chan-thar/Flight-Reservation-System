package DAO;

import Database.DBConnection;
import Model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class userDAO {

    // ----------------- REGISTER USER -----------------
	public User registerUser(User user) {
	    String sql = "INSERT INTO USERS(fullName, email, phoneNumber, password, status) VALUES(?,?,?,?,?)";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

	        ps.setString(1, user.getFullName());
	        ps.setString(2, user.getEmail());
	        ps.setString(3, user.getPhoneNumber());
	        ps.setString(4, user.getPassword());
	        ps.setBoolean(5, user.getStatus());

	        int rows = ps.executeUpdate();
	        if (rows > 0) {
	            try (ResultSet rs = ps.getGeneratedKeys()) {
	                if (rs.next()) {
	                    user.setUserID(rs.getInt(1)); // ← this is the DB-generated userID
	                }
	            }
	            return user; // return user with ID
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null; // registration failed
	}


    // ----------------- VALIDATE LOGIN -----------------
	public User validateUser(String email, String password) {
	    String sql = "SELECT * FROM USERS WHERE email=? AND password=?";
	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setString(1, email);
	        ps.setString(2, password);

	        try (ResultSet rs = ps.executeQuery()) {
	            if (rs.next()) {
	                User user = new User();
	                user.setUserID(rs.getInt("userID"));       // ← database ID
	                user.setFullName(rs.getString("fullName"));
	                user.setEmail(rs.getString("email"));
	                user.setPhoneNumber(rs.getString("phoneNumber"));
	                user.setStatus(rs.getBoolean("status"));
	                return user;
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null; // invalid login
	}


    // ----------------- GET ALL USERS -----------------
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM USERS";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("userID"));
                user.setFullName(rs.getString("fullName"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phoneNumber"));
                user.setStatus(rs.getBoolean("status"));
                users.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }

    // ----------------- GET USER BY EMAIL & PASSWORD (optional) -----------------
//    public User getUserByEmailAndPassword(String email, String password) {
//        return validateUser(email, password);
//    }
    
    //for the adminreply
    public User getUserById(int id) {
        User user = null;
        String sql = "SELECT * FROM users WHERE userID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserID(rs.getInt("userID"));
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phoneNumber"));
                    user.setPassword(rs.getString("password"));
                    user.setStatus(rs.getBoolean("status"));//need to change 
                   
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

 // Delete UserAcc
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE userID=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    
    
}
