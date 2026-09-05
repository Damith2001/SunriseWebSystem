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
import javax.servlet.http.HttpSession;

@WebServlet(name = "DeleteProfileServlet", urlPatterns = {"/DeleteProfileServlet"})
public class DeleteProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            String username = (String) session.getAttribute("username");
            
            if (username != null) {
                try {
                    Connection con = DBConnection.getConnection();
                    if (con != null) {
                        // Patients table eken adala userwa delete kirima
                        PreparedStatement pst = con.prepareStatement("DELETE FROM patients WHERE username=?");
                        pst.setString(1, username);
                        pst.executeUpdate();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            // Session eka invalidate kirima
            session.invalidate();
        }
        
        // Success message eka ekka index.html ekata redirect wenawa
        response.sendRedirect("index.html?success=Profile+Deleted+Successfully");
    }
}