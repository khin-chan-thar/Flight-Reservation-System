package DAO;

import Database.DBConnection;
import Model.Payment;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class paymentDAO {
	
	public int addPayment(Payment payment) {
        int paymentID = -1;
        String sql = "INSERT INTO payment (bookingID, userID, amount, status, paymentMethod, transactionID, paymentDate) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, payment.getBookingID());
            ps.setInt(2, payment.getUserID());
            ps.setDouble(3, payment.getAmount());
            ps.setString(4, payment.getStatus());
            ps.setString(5, payment.getPaymentMethod());
            ps.setString(6, payment.getTransactionID());
            if (payment.getPaymentDate() != null) {
                ps.setTimestamp(7, Timestamp.valueOf(payment.getPaymentDate()));
            } else {
                ps.setNull(7, Types.TIMESTAMP);
            }

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                paymentID = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return paymentID;
    }

	 public boolean updatePayment(Payment payment) {
		    String sql = "UPDATE payment SET amount=?, paymentMethod=?, status=?, paymentDate=?, transactionID=?, adminApprovedBy=? WHERE paymentID=?";
		    try (Connection conn = DBConnection.getConnection();
		         PreparedStatement ps = conn.prepareStatement(sql)) {

		        ps.setDouble(1, payment.getAmount());
		        ps.setString(2, payment.getPaymentMethod());
		        ps.setString(3, "Pending");
		        if (payment.getPaymentDate() != null)
		            ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
		        else
		            ps.setNull(4, Types.TIMESTAMP);
		        ps.setString(5, payment.getTransactionID());
		        if (payment.getAdminApprovedBy() != null)
		            ps.setInt(6, payment.getAdminApprovedBy());
		        else
		            ps.setNull(6, Types.INTEGER);
		        ps.setInt(7, payment.getPaymentID());

		        return ps.executeUpdate() > 0;

		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return false;
		}
	 
	 //----------------------MIN MIN CODE-------------------------------------//
	 public boolean approvePayment(int paymentId) {
	      String updatePaymentSql = "UPDATE payment SET status='Approved' WHERE paymentID=?";
	      String updateBookingSql = "UPDATE booking SET status='Confirmed' WHERE bookingID=?";
	      String updatePassengerSql = "UPDATE passenger SET ticketNumber=? WHERE bookingID=?";

	      try (Connection con = DBConnection.getConnection()) {
	          con.setAutoCommit(false); // transaction start

	          // 1. Get bookingID from payment
	          int bookingId = -1;
	          try (PreparedStatement ps = con.prepareStatement("SELECT bookingID FROM payment WHERE paymentID=?")) {
	              ps.setInt(1, paymentId);
	              try (ResultSet rs = ps.executeQuery()) {
	                  if (rs.next()) {
	                      bookingId = rs.getInt("bookingID");
	                  }
	              }
	          }

	          if (bookingId == -1) {
	              con.rollback();
	              return false;
	          }

	          // 2. Approve payment
	          try (PreparedStatement ps = con.prepareStatement(updatePaymentSql)) {
	              ps.setInt(1, paymentId);
	              ps.executeUpdate();
	          }

	          // 3. Confirm booking
	          try (PreparedStatement ps = con.prepareStatement(updateBookingSql)) {
	              ps.setInt(1, bookingId);
	              ps.executeUpdate();
	          }

	          // 4. Generate ticket(s) for passenger(s)
	          String ticketNumber = "TKT-" + bookingId + "-" + System.currentTimeMillis();
	          try (PreparedStatement ps = con.prepareStatement(updatePassengerSql)) {
	              ps.setString(1, ticketNumber);
	              ps.setInt(2, bookingId);
	              ps.executeUpdate();
	          }

	          con.commit(); // ✅ commit all
	          return true;

	      } catch (Exception e) {
	          e.printStackTrace();
	          return false;
	      }
	  }

		public boolean rejectPayment(int paymentId) {
		    String sql = "UPDATE payment SET status='Rejected' WHERE paymentID=?";
		    try (Connection con = DBConnection.getConnection();
		         PreparedStatement ps = con.prepareStatement(sql)) {

		        ps.setInt(1, paymentId);

		        int rows = ps.executeUpdate();
		        return rows > 0;
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		    return false;
		}
		
		public List<Payment> getAllPayments() {
		    List<Payment> payments = new ArrayList<>();
		    String sql = "SELECT \r\n"
		    		+ "    p.paymentID, \r\n"
		    		+ "    p.bookingID, \r\n"
		    		+ "    p.userID, \r\n"
		    		+ "    u.fullName AS userFullName, \r\n"
		    		+ "    p.amount, \r\n"
		    		+ "    p.paymentMethod, \r\n"
		    		+ "    p.status, \r\n"
		    		+ "    p.paymentDate, \r\n"
		    		+ "    p.transactionID,\r\n"
		    		+ "    b.bookingCode\r\n"
		    		+ "FROM payment p\r\n"
		    		+ "JOIN users u ON p.userID = u.userID\r\n"
		    		+ "JOIN booking b ON p.bookingID = b.bookingID;\r\n"
		    		+ "";

		    try (Connection con = DBConnection.getConnection();
		         PreparedStatement ps = con.prepareStatement(sql);
		         ResultSet rs = ps.executeQuery()) {

		        while (rs.next()) {
		            Payment p = new Payment();
		            p.setPaymentID(rs.getInt("paymentID"));
		            p.setBookingCode(rs.getString("bookingCode"));
		            p.setUserID(rs.getInt("userID"));
		            p.setFullName(rs.getString("userFullName")); // ✅ from users table
		            p.setAmount(rs.getDouble("amount"));
		            p.setPaymentMethod(rs.getString("paymentMethod"));
		            p.setStatus(rs.getString("status"));
		            Timestamp ts = rs.getTimestamp("paymentDate");
	        	    if (ts != null) {
	        	        p.setPaymentDate(ts.toLocalDateTime()); // ✅ correct
	        	    }
		            p.setTransactionID(rs.getString("transactionID"));

		            payments.add(p);
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    }

		    return payments;
		}
		
		public Payment getPaymentById(int id) {
		    Payment payment = null;
		    String sql = "SELECT * FROM payment WHERE paymentID=?";

		    try (Connection con = DBConnection.getConnection();
		         PreparedStatement ps = con.prepareStatement(sql)) {

		        ps.setInt(1, id);  // set the payment ID parameter

		        try (ResultSet rs = ps.executeQuery()) {
		            if (rs.next()) {
		                payment = new Payment();
		                payment.setPaymentID(rs.getInt("paymentID"));
		                payment.setBookingID(rs.getInt("bookingID"));
		                payment.setUserID(rs.getInt("userID"));
		                payment.setAmount(rs.getDouble("amount"));
		                payment.setPaymentMethod(rs.getString("paymentMethod"));
		                payment.setTransactionID(rs.getString("transactionID"));
		                payment.setStatus(rs.getString("status"));
		                Timestamp ts = rs.getTimestamp("paymentDate");
		        	    if (ts != null) {
		        	        payment.setPaymentDate(ts.toLocalDateTime()); // ✅ correct
		        	    }
		               

		                int adminId = rs.getInt("adminApprovedBy");
		                if (!rs.wasNull()) {
		                    payment.setAdminApprovedBy(adminId);
		                }
		            }
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    }

		    return payment;
		}

		

		
		
		public Payment getPaymentById1(int id) {
		    Payment payment = null;
		    String sql = "SELECT p.paymentID, p.bookingID, p.userID, u.fullName AS userFullName, " +
		                 "p.amount, p.paymentMethod,p.transactionID, p.status, p.paymentDate " +
		                 "FROM payment p " +
		                 "JOIN users u ON p.userID = u.userID " +
		                 "WHERE p.paymentID = ?";

		    try (Connection con = DBConnection.getConnection();
		         PreparedStatement ps = con.prepareStatement(sql)) {

		        ps.setInt(1, id);
		        try (ResultSet rs = ps.executeQuery()) {
		            if (rs.next()) {
		                payment = new Payment();
		                payment.setPaymentID(rs.getInt("paymentID"));
		                payment.setBookingID(rs.getInt("bookingID"));
		                payment.setUserID(rs.getInt("userID"));
		                payment.setFullName(rs.getString("userFullName")); // ✅ set full name
		                payment.setAmount(rs.getDouble("amount"));
		                payment.setPaymentMethod(rs.getString("paymentMethod"));
		                payment.setStatus(rs.getString("status"));
		                Timestamp ts = rs.getTimestamp("paymentDate");
		        	    if (ts != null) {
		        	        payment.setPaymentDate(ts.toLocalDateTime()); // ✅ correct
		        	    }
		        	    payment.setTransactionID(rs.getString("transactionID"));
		            }
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    }

		    return payment;
		}
		
		
		//---------------------------------MIN MIN CODE-------------------------------//
	 
	 public Payment getPaymentByBookingId(int bookingId) {
	        Payment payment = null;
	        String sql = "SELECT * FROM payment WHERE bookingID = ?";

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setInt(1, bookingId);
	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                Timestamp ts = rs.getTimestamp("paymentDate");
	                LocalDateTime paymentDate = (ts != null) ? ts.toLocalDateTime() : null;

	                payment = new Payment(
	                        rs.getInt("paymentID"),
	                        rs.getInt("bookingID"),
	                        rs.getInt("userID"),
	                        rs.getDouble("amount"),
	                        rs.getString("paymentMethod"),
	                        rs.getString("status"),
	                        paymentDate,
	                        rs.getString("transactionID"),
	                        (Integer) rs.getObject("adminApprovedBy")
	                );
	            }

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }

	        return payment; // null if not found
	    }


	 public boolean isTransactionIDExist(String transactionID) {
	        String sql = "SELECT COUNT(*) FROM payment WHERE transactionID = ?";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setString(1, transactionID);
	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                return rs.getInt(1) > 0;  // If count > 0, it means transactionID exists
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return false;  // No matching transactionID found
	    }
	 

}
