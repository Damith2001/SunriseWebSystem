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

@WebServlet(name = "EditDoctorServlet", urlPatterns = {"/EditDoctorServlet"})
public class EditDoctorServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String name = request.getParameter("doctor_name");
        String specialization = request.getParameter("specialization");
        String phone = request.getParameter("phone");

        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                String query = "UPDATE doctors SET doctor_name=?, specialization=?, phone=? WHERE id=?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, name);
                pst.setString(2, specialization);
                pst.setString(3, phone);
                pst.setString(4, id);
                pst.executeUpdate();
            }
            response.sendRedirect("admin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}