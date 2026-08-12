package Controller;

import jakarta.servlet.*;

import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

import DAO.passengerDAO;
import Model.Passenger;

public class passengerInfoController extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        passengerDAO dao = new passengerDAO();
        List<Passenger> passengers = dao.getAllPassengers();  // fetch all passengers
        System.out.println("Passengers fetched: " + passengers.size());
        request.setAttribute("passengerList", passengers);
        RequestDispatcher rd = request.getRequestDispatcher("/JSPView/passengerInfo.jsp");
        rd.forward(request, response);
        
       

    }
}
