package Model;

public class User {
	
	private int userID;
	private String fullName;
	private String email;
	private String phoneNumber;
	private String password;
	private boolean status;
	
	public User() {
		
	}
	
	public User(int id , String name , String email , String phone , String password , boolean status) {
		this.userID =id;
		this.fullName = name;
		this.email = email;
		this.phoneNumber = phone;
		this.password = password;
		this.status = status;
	}

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public boolean getStatus() {
		return status;
	}

	public void setStatus(boolean b) {
		this.status = b;
	}
	
	

}
