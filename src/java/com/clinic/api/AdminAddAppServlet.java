package com.clinic.api;

import com.clinic.dao.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminAddAppServlet", urlPatterns = {"/AdminAddAppServlet"})
public class AdminAddAppServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String patientName = request.getParameter("name");
        String contactNumber = request.getParameter("contact_number");
        String dentist = request.getParameter("dentist");
        String treatment = request.getParameter("treatment");
        String appointmentDate = request.getParameter("date");
        String appointmentTime = request.getParameter("time");

        Random rnd = new Random();
        String appointmentNumber = "APT-" + (1000 + rnd.nextInt(9000));

        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                String query = "INSERT INTO appointments (appointment_number, patient_name, contact_number, dentist, treatment, app_date, app_time) VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, appointmentNumber);
                pst.setString(2, patientName);
                pst.setString(3, contactNumber);
                pst.setString(4, dentist);
                pst.setString(5, treatment);
                pst.setString(6, appointmentDate);
                pst.setString(7, appointmentTime);
                pst.executeUpdate();
            }
            response.sendRedirect("admin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}