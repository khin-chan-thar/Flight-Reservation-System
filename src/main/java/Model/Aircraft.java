package Model;

import java.sql.Timestamp;

public class Aircraft {

    private int aircraftID;
    private String model;
    private int totalSeat;
    private int airlineID;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    

    // Optional: For display purposes
    private String airlineName;

    // ====== Constructors ======
    public Aircraft() {
        this.status = "Available"; // default
    }

    public Aircraft(String model, int totalSeat, int airlineID, String status) {
        this.model = model;
        this.totalSeat = totalSeat;
        this.airlineID = airlineID;
        this.status = status;
    }

    // ====== Getters and Setters ======
    public int getAircraftID() {
        return aircraftID;
    }

    public void setAircraftID(int aircraftID) {
        this.aircraftID = aircraftID;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public int getTotalSeat() {
        return totalSeat;
    }

    public void setTotalSeat(int totalSeat) {
        this.totalSeat = totalSeat;
    }

    public int getAirlineID() {
        return airlineID;
    }

    public void setAirlineID(int airlineID) {
        this.airlineID = airlineID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getAirlineName() {
        return airlineName;
    }

    public void setAirlineName(String airlineName) {
        this.airlineName = airlineName;
    }

    // ====== toString for debugging ======
    @Override
    public String toString() {
        return "Aircraft [aircraftID=" + aircraftID + ", model=" + model + ", totalSeat=" + totalSeat
                + ", airlineID=" + airlineID + ", status=" + status + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt + ", airlineName=" + airlineName + "]";
    }
}
