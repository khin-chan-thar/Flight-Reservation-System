package Model;

import java.time.LocalDateTime;

public class Passenger {
    private int passengerID;
    private int bookingID;
    private String fullName;
    private String gender;
    private int age;
    private String passportOrNRC;
    

    private String ticketNumber;   // ticket code
    private Flight flight;         // flight info

    // Constructors
    public Passenger() {}

    public Passenger(int passengerID, int bookingID, String fullName,
                     String ticketNumber, Flight flight) {
        this.passengerID = passengerID;
        this.bookingID = bookingID;
        this.fullName = fullName;
        this.ticketNumber = ticketNumber;
        this.flight = flight;
    }

   
	

	// ------------------ Getters and Setters ------------------
    public Flight getFlight() {
		return flight;
	}

	public void setFlight(Flight flight) {
		this.flight = flight;
	}

	public String getTicketNumber() {
		return ticketNumber;
	}

	public void setTicketNumber(String ticketNumber) {
		this.ticketNumber = ticketNumber;
	}
    public int getPassengerID() {
        return passengerID;
    }

    public void setPassengerID(int passengerID) {
        this.passengerID = passengerID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getPassportOrNRC() {
        return passportOrNRC;
    }

    public void setPassportOrNRC(String passportOrNRC) {
        this.passportOrNRC = passportOrNRC;
    }

   

    // ------------------ toString ------------------
    @Override
    public String toString() {
        return "Passenger{" +
                "passengerID=" + passengerID +
                ", bookingID=" + bookingID +
                ", fullName='" + fullName + '\'' +
                ", gender='" + gender + '\'' +
                ", age=" + age +
                ", passportOrNRC='" + passportOrNRC + '\'' +
                '}';
    }
}
