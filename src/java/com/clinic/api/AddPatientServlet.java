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

@WebServlet(name = "AddPatientServlet", urlPatterns = {"/AddPatientServlet"})
public class AddPatientServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                String query = "INSERT INTO patients (name, phone, address, username, password) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, name);
                pst.setString(2, phone);
                pst.setString(3, address);
                pst.setString(4, username);
                pst.setString(5, password);
                pst.executeUpdate();
            }
          response.sendRedirect("admin.jsp?success=Patient+Added+Successfully");
        } catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("admin.jsp?error=Operation+Failed");
}
    }
}