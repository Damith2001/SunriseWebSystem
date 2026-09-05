package com.clinic.api;

import com.clinic.dao.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "EditAppServlet", urlPatterns = {"/EditAppServlet"})
public class EditAppServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String appNo = request.getParameter("appNo"); // edit_appointment.jsp eken ena name eka 'appNo' nisa eka match kala
        String name = request.getParameter("name");
        String contact = request.getParameter("contact_number");
        String email = request.getParameter("email"); // Email eka gannawa
        String dentist = request.getParameter("dentist");
        String treatment = request.getParameter("treatment");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                String query = "UPDATE appointments SET patient_name=?, contact_number=?, email=?, dentist=?, treatment=?, app_date=?, app_time=? WHERE appointment_number=?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, name);
                pst.setString(2, contact);
                pst.setString(3, email);
                pst.setString(4, dentist);
                pst.setString(5, treatment);
                pst.setString(6, date);
                pst.setString(7, time);
                pst.setString(8, appNo);
                pst.executeUpdate();
            }
            response.sendRedirect("admin.jsp?success=Appointment+Updated+Successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=Operation+Failed");
        }
    }
}