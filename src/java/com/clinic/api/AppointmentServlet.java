package com.clinic.api;
import com.clinic.dao.AppointmentDAO;
import com.clinic.utils.NotificationService;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AppointmentServlet", urlPatterns = {"/AppointmentServlet"})
public class AppointmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("patientId") != null) {
            int patientId = (int) session.getAttribute("patientId");
            String dentist = request.getParameter("dentist");
            String treatment = request.getParameter("treatment");
            String date = request.getParameter("date");
            String time = request.getParameter("time");

            AppointmentDAO dao = new AppointmentDAO();
            if (dao.addAppointment(patientId, dentist, treatment, date, time)) {
                NotificationService.sendSMS("Patient", "Appointment booked for " + date + " at " + time);
                response.getWriter().println("<h3 style='color:green;'>Appointment Successfully Booked!</h3><a href='dashboard.html'>Go Back</a>");
            } else {
                response.getWriter().println("<h3>Failed to book appointment.</h3>");
            }
        } else {
            response.sendRedirect("index.html");
        }
    }
}