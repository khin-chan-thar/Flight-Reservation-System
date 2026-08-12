package Model;

import java.time.LocalDateTime;

public class Payment {
    private int paymentID;
    private int bookingID;           // foreign key to Booking
    private String bookingCode;
    private int userID;              // foreign key to User
    private double amount;
    private String paymentMethod;           // e.g., Credit Card, Cash, Bank Transfer
    private String status;           // e.g., Pending, Approved
    private LocalDateTime paymentDate;
    private String transactionID; 
    private Integer adminApprovedBy;  // foreign key to Admin (nullable)
    private String fullName;


    // ------------------ Constructors ------------------
    public Payment() {
    }

    public Payment(int paymentID, int bookingID, int userID, double amount, String method, String status,
                   LocalDateTime paymentDate, String transationID, Integer adminApprovedBy) {
        this.paymentID = paymentID;
        this.bookingID = bookingID;
        this.userID = userID;
        this.amount = amount;
        this.paymentMethod = method;
        this.status = status;
        this.paymentDate = paymentDate;
        this.transactionID = transationID;
        this.adminApprovedBy = adminApprovedBy;
    }

    // ------------------ Getters and Setters ------------------
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
   
    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(String transactionID) {
        this.transactionID = transactionID;
    }

    public Integer getAdminApprovedBy() {
        return adminApprovedBy;
    }

    public void setAdminApprovedBy(Integer adminApprovedBy) {
        this.adminApprovedBy = adminApprovedBy;
    }
    
    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    // ------------------ toString ------------------
    @Override
    public String toString() {
        return "Payment{" +
                "paymentID=" + paymentID +
                ", bookingID=" + bookingID +
                ", userID=" + userID +
                ", amount=" + amount +
                ", method='" + paymentMethod + '\'' +
                ", status='" + status + '\'' +
                ", paymentDate=" + paymentDate +
                ", paymentScreenshot='" + transactionID + '\'' +
                ", adminApprovedBy=" + adminApprovedBy +
                '}';
    }
}
