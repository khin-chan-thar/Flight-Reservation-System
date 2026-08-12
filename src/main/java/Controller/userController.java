package Controller;

import java.io.IOException;

import DAO.userDAO;
import Model.User;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class userController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    
    
    public userController() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	 String action = request.getParameter("action");
    	if ("logout".equalsIgnoreCase(action)) {
             // Invalidate the session to log out the user
             HttpSession session = request.getSession(false); // get existing session, do not create new
             if (session != null) {
                 session.invalidate();
             }

             // Redirect user to main home page
             response.sendRedirect(request.getContextPath() + "/JSPView/mainHome.jsp");
             return; // stop further processing
         }
    	
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                
           
                case "delete":
                    deleteManageAcc(request, response);
                    break;
               
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
        
        userDAO userDAO = new userDAO();

        if ("registerUserForm".equalsIgnoreCase(action)) {
            String name = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");

            // ------------------ VALIDATION ------------------
            if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

                request.setAttribute("errorMessage", "All fields are required!");
                request.getRequestDispatcher("/JSPView/registerUser.jsp").forward(request, response);
                return;
            }

            String passwordPattern = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).{8,}$";
            String phonePattern = "^\\+?\\d{10,15}$";

            if (!password.matches(passwordPattern)) {
                request.setAttribute("errorMessage", "Password must be at least 8 chars, include upper, lower, number & symbol!");
                request.getRequestDispatcher("/JSPView/registerUser.jsp").forward(request, response);
                return;
            }

            if (!phone.matches(phonePattern)) {
                request.setAttribute("errorMessage", "Phone number is invalid! Must be 10-15 digits.");
                request.getRequestDispatcher("/JSPView/registerUser.jsp").forward(request, response);
                return;
            }

            // ------------------ CREATE USER ------------------
            User user = new User();
            user.setFullName(name);
            user.setEmail(email);
            user.setPhoneNumber(phone);
            user.setPassword(password);
            user.setStatus(true);

            // Register user and get DB-generated ID
            User registeredUser = userDAO.registerUser(user); // must return User with userID
            if (registeredUser != null) {
                System.out.println("DB UserID: " + registeredUser.getUserID());
                request.getSession().setAttribute("loggedInUser", registeredUser); // store in session
                request.getRequestDispatcher("/JSPView/loginUser.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "User already exists! Please try again!");
                request.getRequestDispatcher("/JSPView/registerUser.jsp").forward(request, response);
            }

        } else if ("loginUserForm".equalsIgnoreCase(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            User user = userDAO.validateUser(email, password); // returns User with DB userID
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", user);
                System.out.println("Logged-in DB UserID: " + user.getUserID());
                request.getRequestDispatcher("/JSPView/homeUser.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Invalid username/email or password!");
                request.getRequestDispatcher("/JSPView/loginUser.jsp").forward(request, response);
            }
        }
    }

	private void deleteManageAcc(HttpServletRequest request, HttpServletResponse response) throws IOException {
		// TODO Auto-generated method stub
		 int id = Integer.parseInt(request.getParameter("id"));
		 userDAO userdao = new userDAO();  
		 boolean success =userdao.deleteUser(id);
		 if(success){
	            request.getSession().setAttribute("msg", "User Account is Deleted successfully!");
	            request.getSession().setAttribute("msgType", "Success");
	        } else {
	            request.getSession().setAttribute("msg", "Failed to Delete User Account.");
	            request.getSession().setAttribute("msgType", "Failed");
	        }
		 
	     response.sendRedirect(request.getContextPath() + "/JSPView/manageUserAcc.jsp");
	}
}
