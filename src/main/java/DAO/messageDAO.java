package DAO;

import Database.DBConnection;
import Model.Message;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class messageDAO {

    // --------------------
    // Get all messages
    // --------------------
    public List<Message> getAllMessages() {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT * FROM message ORDER BY sentDate DESC"; // newest first

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Message msg = new Message();
                msg.setMessageID(rs.getInt("messageID"));
                msg.setUserID(rs.getInt("UserID"));
                msg.setAdminID(rs.getInt("AdminID"));
                msg.setSubject(rs.getString("subject"));
                msg.setContent(rs.getString("content"));
                msg.setSentDate(rs.getTimestamp("sentDate"));
                msg.setStatus(rs.getString("status"));
                list.add(msg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /////from admin 
    public boolean sendMessage(Message msg) {
        String sql = "INSERT INTO message (adminID, userID, subject, content, status, sentDate) VALUES (?, ?, ?, ?, 'Sent', NOW())";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, msg.getAdminID());
            ps.setInt(2, msg.getUserID());
            ps.setString(3, msg.getSubject());
            ps.setString(4, msg.getContent());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // --------------------
    // User sends message to Admin
    // --------------------
    public boolean sendUserMessage(Message msg) {
        String sql = "INSERT INTO message (UserID, AdminID, subject, content, sentDate, status) "
                   + "VALUES (?, ?, ?, ?, NOW(), 'Delivered')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, msg.getUserID());
            ps.setInt(2, msg.getAdminID());
            ps.setString(3, msg.getSubject());
            ps.setString(4, msg.getContent());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // --------------------
    // Admin replies to User
    // --------------------
    public boolean sendAdminReply(Message msg) {
        String sql = "INSERT INTO message (UserID, AdminID, subject, content, sentDate, status) "
                   + "VALUES (?, ?, ?, ?, NOW(), 'Delivered')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, msg.getUserID());   // the user receiving the reply
            ps.setInt(2, msg.getAdminID());  // admin sending the reply
            ps.setString(3, msg.getSubject());
            ps.setString(4, msg.getContent());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Message> getUserMessagesOnly() {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT * FROM message WHERE subject NOT LIKE 'Re:%' ORDER BY sentDate DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Message msg = new Message();
                msg.setMessageID(rs.getInt("messageID"));
                msg.setUserID(rs.getInt("UserID"));
                msg.setAdminID(rs.getInt("AdminID"));
                msg.setSubject(rs.getString("subject"));
                msg.setContent(rs.getString("content"));
                msg.setSentDate(rs.getTimestamp("sentDate"));
                msg.setStatus(rs.getString("status"));
                list.add(msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    // --------------------
    // Get inbox for a User
    // --------------------
    public List<Message> getUserInbox(int userId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT * FROM message WHERE UserID=? ORDER BY sentDate DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Message msg = new Message();
                msg.setMessageID(rs.getInt("messageID"));
                msg.setUserID(rs.getInt("UserID"));
                msg.setAdminID(rs.getInt("AdminID"));
                msg.setSubject(rs.getString("subject"));
                msg.setContent(rs.getString("content"));
                msg.setSentDate(rs.getTimestamp("sentDate"));
                msg.setStatus(rs.getString("status"));
                list.add(msg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // --------------------
    // Get inbox for an Admin
    // --------------------
    public List<Message> getAdminInbox(int adminId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT * FROM message WHERE AdminID=? ORDER BY sentDate DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Message msg = new Message();
                msg.setMessageID(rs.getInt("messageID"));
                msg.setUserID(rs.getInt("UserID"));
                msg.setAdminID(rs.getInt("AdminID"));
                msg.setSubject(rs.getString("subject"));
                msg.setContent(rs.getString("content"));
                msg.setSentDate(rs.getTimestamp("sentDate"));
                msg.setStatus(rs.getString("status"));
                list.add(msg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
//////////////////////////////////user reply
    
 // User replying to Admin
    public boolean sendUserReply(Message msg) {
        String sql = "INSERT INTO message (userID, adminID, subject, content, sentDate, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, msg.getUserID());
            ps.setInt(2, msg.getAdminID());
            ps.setString(3, msg.getSubject());
            ps.setString(4, msg.getContent());
            ps.setTimestamp(5, (Timestamp) msg.getSentDate());
            ps.setString(6, msg.getStatus());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean sendMessageToAdmin(Message msg) {
        String sql = "INSERT INTO message (UserID, AdminID, subject, content, sentDate, status) VALUES (?, ?, ?, ?, ?, ?)";
        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, msg.getUserID());
            ps.setInt(2, msg.getAdminID());
            ps.setString(3, msg.getSubject());
            ps.setString(4, msg.getContent());
            ps.setTimestamp(5, (Timestamp) msg.getSentDate());
            ps.setString(6, msg.getStatus());

            return ps.executeUpdate() > 0;
        } catch(Exception e) {
            e.printStackTrace();
            return false;
        }
    }
////for user sending message
    public boolean insertUserMessage(Message msg) {
        String sql = "INSERT INTO message (userID, adminID, subject, content, sentDate, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, msg.getUserID());
            ps.setInt(2, msg.getAdminID());
            ps.setString(3, msg.getSubject());
            ps.setString(4, msg.getContent());
            ps.setTimestamp(5, (Timestamp) msg.getSentDate());
            ps.setString(6, msg.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    

}
