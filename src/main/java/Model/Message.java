package Model;

import java.util.Date;

public class Message {
    private int messageID;
    private int userID;     // receiver or sender user
    private int adminID;    // receiver or sender admin
    private String subject;
    private String content;
    private Date sentDate;
    private String status;

    // Constructor
    public Message() {}

    public Message(int messageID, int userID, int adminID, String subject, String content, Date sentDate, String status) {
        this.messageID = messageID;
        this.userID = userID;
        this.adminID = adminID;
        this.subject = subject;
        this.content = content;
        this.sentDate = sentDate;
        this.status = status;
    }

    // Getters & Setters
    public int getMessageID() {
        return messageID;
    }
    public void setMessageID(int messageID) {
        this.messageID = messageID;
    }

    public int getUserID() {
        return userID;
    }
    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getAdminID() {
        return adminID;
    }
    public void setAdminID(int adminID) {
        this.adminID = adminID;
    }

    public String getSubject() {
        return subject;
    }
    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    public Date getSentDate() {
        return sentDate;
    }
    public void setSentDate(Date sentDate) {
        this.sentDate = sentDate;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
}
