package Model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Flight {
    private int flightID;
    private String flightNumber;
    private String origin;
    private String destination;
    private Timestamp departureTime;
    private Timestamp arrivalTime;
    private LocalDateTime departure;
    private LocalDateTime arrival;
    private double price;
    private int availableSeats;
    private int aircraftID;
    private int airlineID;
    private String status;

    // Extra fields for display
    private String airlineName;
    private String aircraftModel;

    // Getters & Setters
    public Flight() {}
    
    public Flight(int flightID,String flightNumber, String origin, String destination, LocalDateTime departure, double price , int availableSeats) {
        this.flightID = flightID;
    	this.flightNumber = flightNumber;
        this.origin = origin;
        this.destination = destination;
        this.departure = departure;
        this.price = price;
        this.availableSeats = availableSeats;
    }
    public int getFlightID() { return flightID; }
    public LocalDateTime getDeparture() {
		return departure;
	}
	public void setDeparture(LocalDateTime departure) {
		this.departure = departure;
	}
	public LocalDateTime getArrival() {
		return arrival;
	}
	public void setArrival(LocalDateTime arrival) {
		this.arrival = arrival;
	}
	public void setFlightID(int flightID) { this.flightID = flightID; }

    public String getFlightNumber() { return flightNumber; }
    public void setFlightNumber(String flightNumber) { this.flightNumber = flightNumber; }

    public String getOrigin() { return origin; }
    public void setOrigin(String origin) { this.origin = origin; }

    public String getDestination() { return destination; }
    public void setDestination(String destination) { this.destination = destination; }

    public Timestamp getDepartureTime() { return departureTime; }
    public void setDepartureTime(Timestamp departureTime) { this.departureTime = departureTime; }

    public Timestamp getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(Timestamp arrivalTime) { this.arrivalTime = arrivalTime; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getAvailableSeats() { return availableSeats; }
    public void setAvailableSeats(int availableSeats) { this.availableSeats = availableSeats; }

    public int getAircraftID() { return aircraftID; }
    public void setAircraftID(int aircraftID) { this.aircraftID = aircraftID; }

    public int getAirlineID() { return airlineID; }
    public void setAirlineID(int airlineID) { this.airlineID = airlineID; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAirlineName() { return airlineName; }
    public void setAirlineName(String airlineName) { this.airlineName = airlineName; }

    public String getAircraftModel() { return aircraftModel; }
    public void setAircraftModel(String aircraftModel) { this.aircraftModel = aircraftModel; }
}
