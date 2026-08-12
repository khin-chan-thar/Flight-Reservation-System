package Controller;

import java.io.IOException;
import java.util.List;

import DAO.aircraftDAO;
import Model.Aircraft;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class aircraftController extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String action = request.getParameter("action");
	    aircraftDAO dao = new aircraftDAO();

	    try {
	        String model = request.getParameter("model");
	        int totalSeat = Integer.parseInt(request.getParameter("totalSeat"));
	        int airlineID = Integer.parseInt(request.getParameter("airlineID"));
	        String status = request.getParameter("status");

	        Aircraft a = new Aircraft();
	        a.setModel(model);
	        a.setTotalSeat(totalSeat);
	        a.setAirlineID(airlineID);
	        a.setStatus(status);

	        boolean success = false;

	        if ("update".equals(action)) {
	            // update mode
	            int aircraftID = Integer.parseInt(request.getParameter("aircraftID"));
	            a.setAircraftID(aircraftID);
	            success = dao.updateAircraft(a);
	            request.setAttribute("successMessage", "Aircraft updated successfully!");
	        } else {
	            // add mode
	            success = dao.addAircraft(a);
	            request.setAttribute("successMessage", "Aircraft added successfully!");
	        }

	    } catch (RuntimeException ex) {
	        request.setAttribute("errorMessage", ex.getMessage());
	    }

	    request.getRequestDispatcher("${pageContext.request.contextPath}/JSPView/manageAircraft.jsp").forward(request, response);
	}

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            aircraftDAO dao = new aircraftDAO();
            String action = request.getParameter("action");
            int aircraftID = request.getParameter("id") != null ? Integer.parseInt(request.getParameter("id")) : 0;

            if("delete".equals(action) && aircraftID > 0) {
                dao.deleteAircraft(aircraftID);
                response.sendRedirect("JSPView/manageAircraft.jsp");
                return;
            }

            if("edit".equals(action) && aircraftID > 0) {
                Aircraft a = dao.getAircraftById(aircraftID);
                request.setAttribute("aircraft", a);
                request.getRequestDispatcher("JSPView/editAircraft.jsp").forward(request, response);
                return;
            }

            if("view".equals(action) && aircraftID > 0) {
                Aircraft a = dao.getAircraftById(aircraftID);
                request.setAttribute("aircraft", a);
                request.getRequestDispatcher("JSPView/viewAircraft.jsp").forward(request, response);
                return;
            }

            // Default: list all aircraft
            String search = request.getParameter("search");
            List<Aircraft> aircraftList = (search != null && !search.isEmpty()) ?
                    dao.searchAircraft(search) : dao.getAllAircraft();

            request.setAttribute("aircraftList", aircraftList);
            request.getRequestDispatcher("JSPView/manageAircraft.jsp").forward(request, response);

        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
