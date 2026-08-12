package Controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import DAO.*;
import Model.Booking;
import Model.Payment;
import Model.User;	
import java.io.*;
import java.time.LocalDateTime;
import java.util.regex.*;

@WebServlet("/paymentController")
public class paymentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public paymentController() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Handle admin actions
        if ("approve".equalsIgnoreCase(action) || "reject".equalsIgnoreCase(action)) {
            handleAdminAction(request, response, action);
            return; // stop further execution
        }

        // Handle user payment flow
        handleUserPayment(request, response);
    }

    /**
     * Handles approve/reject payment by admin.
     */
    private void handleAdminAction(HttpServletRequest request, HttpServletResponse response, String action)
            throws IOException {
    	paymentDAO dao = new paymentDAO();
    
        int paymentId = Integer.parseInt(request.getParameter("id"));
        boolean success = false;

        if ("approve".equalsIgnoreCase(action)) {
            success = dao.approvePayment(paymentId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/JSPView/manageUserPayment.jsp?msg=Payment+Approved");
            } else {
                response.sendRedirect(request.getContextPath() + "/JSPView/manageUserPayment.jsp?msg=Error");
            }
        } else if ("reject".equalsIgnoreCase(action)) {
            success = dao.rejectPayment(paymentId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/JSPView/manageUserPayment.jsp?msg=Payment+Rejected");
            } else {
                response.sendRedirect(request.getContextPath() + "/JSPView/manageUserPayment.jsp?msg=Error");
            }
        }
    }

    /**
     * Handles user payment upload & confirmation.
     */
    private void handleUserPayment(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/JSPView/paymentUpload.jsp?error=loginRequired");
            return;
        }

        String bookingCode = request.getParameter("bookingCode");
        if (bookingCode == null || bookingCode.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/JSPView/paymentUpload.jsp?error=missingCode");
            return;
        }

        bookingDAO bookingDAO = new bookingDAO();
        Booking booking = bookingDAO.getBookingByBookingCode(bookingCode);
        if (booking == null) {
            response.sendRedirect(request.getContextPath() + "/JSPView/paymentUpload.jsp?error=notFound");
            return;
        }

        paymentDAO paymentDAO = new paymentDAO();

        String transactionID = request.getParameter("paymentTransaction");
        String transactionIDPattern = "^[A-Za-z0-9-_]{8,20}$";

        if (!Pattern.matches(transactionIDPattern, transactionID)) {
            response.sendRedirect(request.getContextPath() + "/JSPView/paymentUpload.jsp?error=invalidTxId");
            return;
        }

        if (paymentDAO.isTransactionIDExist(transactionID)) {
            response.sendRedirect(request.getContextPath() + "/JSPView/paymentUpload.jsp?error=duplicateTxId");
            return;
        }

        booking.getTotalCost();
        String totalCostParam = request.getParameter("totalCost");
        if (totalCostParam != null && !totalCostParam.trim().isEmpty()) {
            try {
                Double.parseDouble(totalCostParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/JSPView/paymentUpload.jsp?error=invalidCost");
                return;
            }
        }

        // Update payment
        Payment payment = paymentDAO.getPaymentByBookingId(booking.getBookingID());
        payment.setPaymentMethod(request.getParameter("paymentMethod"));
        payment.setTransactionID(transactionID);
        payment.setStatus("");
        payment.setPaymentDate(LocalDateTime.now());

        boolean updated = paymentDAO.updatePayment(payment);
        if (updated) {
        	 session.removeAttribute("lastFlights");
             session.removeAttribute("lastNumPassengers");
             session.removeAttribute("lastFrom");
             session.removeAttribute("lastTo");
             session.removeAttribute("lastDate");
            response.sendRedirect(request.getContextPath() + "/JSPView/bookingPending.jsp?success=paymentConfirmed");
        } else {
            response.sendRedirect(request.getContextPath() + "/JSPView/paymentUpload.jsp?error=updateFailed");
        }

        
    }
}

