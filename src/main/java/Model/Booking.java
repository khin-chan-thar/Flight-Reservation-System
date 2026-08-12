package Model;

import java.time.LocalDate;

public class Booking {
    private int bookingID;
    private String bookingCode;
    private int numOfPassengers;
    private int userID;
    private int flightID;
    private LocalDate bookingDate;
    private String status;
    private double totalCost;
    private Payment payment; 
    private Passenger passenger;
    private Flight flight;// add this inside Booking class


    // ------------------ Constructors ------------------
    public Booking() {
    }

    public Booking(int bookingID, String bookingCode,int numOfPassengers, int userID, int flightID, LocalDate bookingDate, String status, double totalCost , Payment payment, Flight flight, Passenger passenger) {
        this.bookingID = bookingID;
        this.bookingCode = bookingCode;
        this.numOfPassengers = numOfPassengers;
        this.userID = userID;
        this.flightID = flightID;
        this.bookingDate = bookingDate;
        this.status = status;
        this.totalCost = totalCost;
        this.payment = payment;
        this.flight = flight;
        this.passenger = passenger;
        
    }

    // ------------------ Getters and Setters ------------------
    
    public Payment getPayment() {
        return payment;
    }

    public void setPayment(Payment payment) {
        this.payment = payment;
    }
    
    public Passenger getPassenger() {
        return passenger;
    }

    public void getPassenger(Passenger passenger) {
        this.passenger = passenger;
    }
    
    public Flight getFlight() {
        return flight;
    }

    public void setFlight(Flight flight) {
        this.flight = flight;
    }

    
    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }
    
    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }
    
    public int getNumOfPassengers() {
        return numOfPassengers;
    }

    public void setNumOfPassengers(int numOfPassengers) {
        this.numOfPassengers = numOfPassengers;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getFlightID() {
        return flightID;
    }

    public void setFlightID(int flightID) {
        this.flightID = flightID;
    }

    public LocalDate getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDate bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }

    // ------------------ toString ------------------
    @Override
    public String toString() {
        return "Booking{" +
                "bookingID=" + bookingID +
                ", userID=" + userID +
                ", flightID=" + flightID +
                ", bookingDate=" + bookingDate +
                ", status='" + status + '\'' +
                ", totalCost=" + totalCost +
                ", numofPassener=" + numOfPassengers +
                ", bookingCode=" + bookingCode +
                ", payment=" + payment +
                ", flight=" + flight +
                '}';
    }
}
