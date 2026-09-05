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

@WebServlet(name = "DeletePatientServlet", urlPatterns = {"/DeletePatientServlet"})
public class DeletePatientServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("id");
        try {
            Connection con = DBConnection.getConnection();
            if (con != null && username != null) {
                PreparedStatement pst = con.prepareStatement("DELETE FROM patients WHERE username=?");
                pst.setString(1, username);
                pst.executeUpdate();
            }
            response.sendRedirect("admin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}