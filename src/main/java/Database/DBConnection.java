package Database;
import java.sql.*;
import javax.naming.*;

public class DBConnection {
	
	private static final String DB_URL = "jdbc:mysql://localhost:2002/frms";

	private static final String USERNAME = "root"; //Change to your MYSQL username
	private static final String PASSWORD = "thin"; //Change to your MYSQL password
	
	public static Connection getConnection() throws SQLException {
			Connection connection = null;
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				connection = DriverManager.getConnection(DB_URL, USERNAME , PASSWORD);
			}catch (ClassNotFoundException | SQLException e) {
				e.printStackTrace();
				throw new SQLException("Unable to connect to the database" , e);
		}
			return connection;
	}
	
	public static void closeConnection(Connection connection) {
		if(connection!=null) {
			try {
				connection.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}

}
