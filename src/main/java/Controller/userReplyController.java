package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Timestamp;
import java.time.Instant;

import Model.Message;
import DAO.messageDAO;

/**
 * Servlet implementation class userReplyController
 */
public class userReplyController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	    private messageDAO dao;

	    @Override
	    public void init() throws ServletException {
	        dao = new messageDAO();
	    }

	    @Override
	    protected void doPost(HttpServletRequest request, HttpServletResponse response)
	            throws ServletException, IOException {
	        
	        
	        try {
	             int userID = Integer.parseInt(request.getParameter("userID"));
	             int adminID = Integer.parseInt(request.getParameter("receiverAdminID"));
	             
	             String subject = request.getParameter("subject");
	             String content = request.getParameter("content");

	             if(subject == null || subject.isEmpty() || content == null || content.isEmpty()) {
	                 response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Subject or content cannot be empty");
	                 return;
	             }

	             Message msg = new Message();
	             msg.setUserID(userID);
	             msg.setAdminID(adminID);
	             msg.setSubject(subject);
	             msg.setContent(content);
	             msg.setSentDate(new java.sql.Timestamp(System.currentTimeMillis()));
	             msg.setStatus("Sent");

	          dao = new messageDAO();
	             boolean success = dao.sendMessageToAdmin(msg);

	             if(success) {
	                 response.sendRedirect(request.getContextPath()+"/JSPView/contactAdmin.jsp");
	             } else {
	                 response.sendRedirect(request.getContextPath()+"/JSPView/contactAdmin.jsp");
	             }

	         } catch(NumberFormatException e) {
	             response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user or admin ID");
	         } catch(Exception e) {
	             e.printStackTrace();
	             response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
	         }
	    }

}
