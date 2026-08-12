package Model;

public class Airline {
	 private int airlineID;
	    private String name;
	    private String code;
	    private String country;
	    private String status;
	    private String createAt;
	    private String updateAt;

	    // Getters and Setters
	    public String getCreateAt() {return createAt;}
	    public void setCreateAt(String createAt) { this.createAt = createAt; }
	    
	    public String getUpdateAt() {return createAt;}
	    public void setUpdateAt(String updateAt) { this.updateAt = updateAt; }
	    
	    
	    public int getAirlineID() { return airlineID; }
	    public void setAirlineID(int airlineID) { this.airlineID = airlineID; }

	    public String getName() { return name; }
	    public void setName(String name) { this.name = name; }

	    public String getCode() { return code; }
	    public void setCode(String code) { this.code = code; }

	    public String getCountry() { return country; }
	    public void setCountry(String country) { this.country = country; }

	    public String getStatus() { return status; }
	    public void setStatus(String status) { this.status = status; }
	    
	    
}
