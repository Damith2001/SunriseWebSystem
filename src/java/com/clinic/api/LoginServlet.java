package com.clinic.api;
import com.clinic.dao.PatientDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        PatientDAO dao = new PatientDAO();
        int patientId = dao.login(user, pass);

        if (patientId > 0) {
            HttpSession session = request.getSession();
            session.setAttribute("patientId", patientId);
            session.setAttribute("username", user);
            response.sendRedirect("dashboard.html");
        } else {
            response.getWriter().println("<h3>Invalid Username or Password!</h3><a href='index.html'>Try Again</a>");
        }
    }
}