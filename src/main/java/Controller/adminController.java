package Controller;

import java.io.IOException;

import DAO.adminDAO;
import Model.Admin;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class adminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("loginAdminForm".equals(action)) {
            loginAdmin(request, response);
        }
    }

    private void loginAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        adminDAO adminDao = new adminDAO();
        Admin admin = adminDao.login(email, password);

        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", admin);
            response.sendRedirect(request.getContextPath() + "/JSPView/manageFlight.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid email or password");
            request.getRequestDispatcher("/JSPView/loginAdmin.jsp").forward(request, response);
        }
    }

}
