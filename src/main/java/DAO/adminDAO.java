package DAO;

import java.sql.*;

import Database.DBConnection;
import Model.Admin;

public class adminDAO {

    // Login check
	 public Admin login(String email, String password) {
	        Admin admin = null;
	        String sql = "SELECT * FROM admin WHERE email = ? AND password = ?"; // Removed status

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setString(1, email);
	            ps.setString(2, password); // Plain text passwords for now

	            try (ResultSet rs = ps.executeQuery()) {
	                if (rs.next()) {
	                    admin = new Admin();
	                    admin.setAdminID(rs.getInt("adminID"));
	                    admin.setEmail(rs.getString("email"));
	                    admin.setPassword(rs.getString("password"));
	                }
	            }

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }

	        return admin;
	    }
}
