package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import Database.DBConnection;
import DAO.airlineDAO;
import Model.Airline;
/**
 * Servlet implementation class AirlinServlet
 */

public class airlineController extends HttpServlet {
	private airlineDAO dao;

    public void init() {
        dao = new airlineDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "add":
                    addAirline(request, response);
                    break;
                case "update":
                    updateAirline(request, response);
                    break;
                case "delete":
                    deleteAirline(request, response);
                    break;
               
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void addAirline(HttpServletRequest req, HttpServletResponse res) throws SQLException, IOException, ServletException {
		/*
		 * AirLine a = new AirLine(); a.setName(req.getParameter("name"));
		 * a.setCode(req.getParameter("code")); //
		 * a.setCountry(req.getParameter("country"));
		 * a.setStatus(req.getParameter("status")); dao.addAirline(a); boolean success =
		 * dao.addAirline(a); if(success){ req.getSession().setAttribute("msg",
		 * "Airline added successfully!"); req.getSession().setAttribute("msgType",
		 * "Success"); } else { req.getSession().setAttribute("msg",
		 * "Failed to add airline."); req.getSession().setAttribute("msgType",
		 * "Failed"); }
		 * 
		 * res.sendRedirect(req.getContextPath() + "/JSPView/manageAirline.jsp");
		 */
    	
    	String action = req.getParameter("action");

    	if ("add".equals(action)) {
    	    String name = req.getParameter("name").trim();
    	    String code = req.getParameter("code").trim().toUpperCase();
    	    String status = req.getParameter("status");

    	    // Check for duplicates
    	    if (dao.isDuplicateAirline(name, code)) {
    	        
    	        res.sendRedirect(req.getContextPath() + "/JSPView/ManageAirline-Form.jsp?action=add&error=Airline+code+already+exists");
    	    } else {
    	    	
    			  Airline a = new Airline(); a.setName(req.getParameter("name"));
    			  a.setCode(req.getParameter("code")); //
    			  a.setCountry(req.getParameter("country"));
    			  a.setStatus(req.getParameter("status")); dao.addAirline(a); boolean success =
    			  dao.addAirline(a); if(success){ req.getSession().setAttribute("msg",
    			  "Airline added successfully!"); req.getSession().setAttribute("msgType",
    			  "Success"); } else { req.getSession().setAttribute("msg",
    			  "Failed to add airline."); req.getSession().setAttribute("msgType",
    			  "Failed"); }
    			  
    			  res.sendRedirect(req.getContextPath() + "/JSPView/manageAirline.jsp");
    			 
    	    }
    	}

    }

    private void updateAirline(HttpServletRequest req, HttpServletResponse res) throws SQLException, IOException {
        Airline a = new Airline();
        a.setAirlineID(Integer.parseInt(req.getParameter("id")));
        a.setName(req.getParameter("name"));   // MUST match <input name="name"/>
        a.setCode(req.getParameter("code"));   // MUST match <input name="code"/>
        //a.setCountry(req.getParameter("country"));
        a.setStatus(req.getParameter("status"));
       dao.updateAirline(a);
        boolean success = dao.updateAirline(a);
        if(success){
            req.getSession().setAttribute("msg", "Airline Update successfully!");
            req.getSession().setAttribute("msgType", "Success");
        } else {
            req.getSession().setAttribute("msg", "Failed to Update airline.");
            req.getSession().setAttribute("msgType", "Failed");
        }
        res.sendRedirect(req.getContextPath() + "/JSPView/manageAirline.jsp");    }

	/*
	 * private void viewAirline(HttpServletRequest req, HttpServletResponse res)
	 * throws SQLException, IOException { AirLine a = new AirLine();
	 * a.setAirlineID(Integer.parseInt(req.getParameter("id")));
	 * a.setName(req.getParameter("name")); // MUST match <input name="name"/>
	 * a.setCode(req.getParameter("code")); // MUST match <input name="code"/>
	 * 
	 * a.setStatus(req.getParameter("status")); dao.updateAirline(a);
	 * res.sendRedirect(req.getContextPath() + "/JSPView/manageAirline.jsp"); }
	 */
    
    
    private void deleteAirline(HttpServletRequest req, HttpServletResponse res) throws SQLException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        dao.deleteAirline(id);
        boolean success =dao.deleteAirline(id);
        if(success){
         
            req.getSession().setAttribute("msg", "Failed to Remove airline.");
            req.getSession().setAttribute("msgType", "Failed");
        } else {
        	   req.getSession().setAttribute("msg", "Airline Remove successfully!");
               req.getSession().setAttribute("msgType", "Success");
        }
        res.sendRedirect(req.getContextPath() + "/JSPView/manageAirline.jsp");
    }

}
