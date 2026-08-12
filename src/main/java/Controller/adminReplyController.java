package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import Model.Message;
import DAO.messageDAO;


public class adminReplyController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private messageDAO dao;

    public void init() throws ServletException {
        dao = new messageDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession();
            Integer adminID = (Integer) session.getAttribute("adminID"); // make sure adminID is in session
            adminID = 1;//need to change getting it from session 
            if (adminID == null) {
                // redirect to login if not logged in
                response.sendRedirect(request.getContextPath() + "/JSPView/adminReplyMessage.jsp");
                return;
            }

            int receiverUserID = Integer.parseInt(request.getParameter("receiverUserID"));
            String subject = request.getParameter("subject");
            String content = request.getParameter("content"); // must match textarea name in JSP

            // Create message object
            Message msg = new Message();
            msg.setUserID(receiverUserID);   // User receiving the reply
            msg.setAdminID(adminID);         // Admin sending the reply
            msg.setSubject(subject);
            msg.setContent(content);

            boolean success = dao.sendAdminReply(msg);

            if (success) {
                // Redirect back to admin inbox after successful reply
                response.sendRedirect(request.getContextPath() + "/JSPView/adminReplyMessage.jsp");
            } else {
                // Show error on the same page if sending failed
                request.setAttribute("error", "Failed to send reply. Try again.");
                request.getRequestDispatcher("/JSPView/adminReplyMessage-Form.jsp")
                       .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/JSPView/adminReplyMessage.jsp");
        }
    }
}
