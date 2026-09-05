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

@WebServlet(name = "EditPatientServlet", urlPatterns = {"/EditPatientServlet"})
public class EditPatientServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                // Password eka update wenne naha, anith 3 witharai
                String query = "UPDATE patients SET name=?, phone=?, address=? WHERE username=?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, name);
                pst.setString(2, phone);
                pst.setString(3, address);
                pst.setString(4, username);
                
                pst.executeUpdate();
            }
            response.sendRedirect("admin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}