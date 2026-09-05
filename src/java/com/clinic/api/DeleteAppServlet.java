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

@WebServlet(name = "DeleteAppServlet", urlPatterns = {"/DeleteAppServlet"})
public class DeleteAppServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String appNo = request.getParameter("appNo");
        try {
            Connection con = DBConnection.getConnection();
            if (con != null && appNo != null) {
                PreparedStatement pst = con.prepareStatement("DELETE FROM appointments WHERE appointment_number=?");
                pst.setString(1, appNo);
                pst.executeUpdate();
            }
            response.sendRedirect("admin.jsp"); // Delete kalata passe ayeth dashboard ekata yanawa
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}