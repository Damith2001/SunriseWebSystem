package com.clinic.api;

import com.clinic.dao.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AppointmentServlet", urlPatterns = {"/AppointmentServlet"})
public class AppointmentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null) username = "guest";

        String name = request.getParameter("name");
        String contact = request.getParameter("contact_number");
        String email = request.getParameter("email"); // Email field eka gannawa
        String dentist = request.getParameter("dentist");
        String treatment = request.getParameter("treatment");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                // Check double booking
                String checkQuery = "SELECT * FROM appointments WHERE dentist=? AND app_date=? AND app_time=?";
                PreparedStatement checkPst = con.prepareStatement(checkQuery);
                checkPst.setString(1, dentist);
                checkPst.setString(2, date);
                checkPst.setString(3, time);
                ResultSet rs = checkPst.executeQuery();
                
                if (rs.next()) {
                    response.sendRedirect("appointment.jsp?error=booked");
                } else {
                    Random rnd = new Random();
                    String appNo = "APT-" + (1000 + rnd.nextInt(9000));
                    
                   String insertQuery = "INSERT INTO appointments (appointment_number, patient_name, contact_number, email, dentist, treatment, app_date, app_time, username) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                   PreparedStatement insertPst = con.prepareStatement(insertQuery);
                   insertPst.setString(1, appNo);
                   insertPst.setString(2, name);
                   insertPst.setString(3, contact);
                   insertPst.setString(4, email); // Email eka
                   insertPst.setString(5, dentist);
                   insertPst.setString(6, treatment);
                   insertPst.setString(7, date);
                   insertPst.setString(8, time);
                   insertPst.setString(9, username);
                   insertPst.executeUpdate();
                    
                 
                    if (email != null && !email.trim().isEmpty()) {
                        try {
                            String subject = "Sunrise Dental - Appointment Confirmation (" + appNo + ")";
                            String messageBody = "Dear " + name + ",\n\nYour appointment has been successfully booked!\n\n"
                                    + "Appointment No: " + appNo + "\n"
                                    + "Dentist: " + dentist + "\n"
                                    + "Treatment: " + treatment + "\n"
                                    + "Date: " + date + "\n"
                                    + "Time: " + time + "\n\n"
                                    + "Thank you for choosing Sunrise Dental!";
                            
                            EmailUtil.sendEmail(email, subject, messageBody);
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                    
                    response.sendRedirect("appointment.jsp?success=Appointment+Booked+Successfully&appNo=" + appNo);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("appointment.jsp?error=System+Error");
        }
    }
}