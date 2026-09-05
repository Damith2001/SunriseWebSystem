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

@WebServlet(name = "DeleteDoctorServlet", urlPatterns = {"/DeleteDoctorServlet"})
public class DeleteDoctorServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        
        try {
            Connection con = DBConnection.getConnection();
            if (con != null && id != null) {
                // Doctor wa database eken delete kirima
                PreparedStatement pst = con.prepareStatement("DELETE FROM doctors WHERE id=?");
                pst.setString(1, id);
                pst.executeUpdate();
            }
            // Delete wunaata passe ayeth admin dashboard ekatama yanawa
            response.sendRedirect("admin.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}