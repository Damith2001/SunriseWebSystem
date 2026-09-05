package com.clinic.api;

import com.clinic.dao.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            
            // Login form eken ena username saha password ganeema
            String user = request.getParameter("username");
            String pass = request.getParameter("password");

            // 1. Mulinma check karanawa me log wenne ADMIN da kiyala
            if ("admin".equals(user) && "admin123".equals(pass)) {
                // Admin nam kelinma admin.jsp ekata yanawa
                response.sendRedirect("admin.jsp");
                return; // Methanin code eka nawathinawa, paha database check ekata yanne naha
            }

            // 2. Admin nemei nam, Database ekata connect wela Patient kenek da kiyala balanawa
            Connection con = DBConnection.getConnection();

            if (con != null) {
                String query = "SELECT * FROM patients WHERE username=? AND password=?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, user);
                pst.setString(2, pass);
                
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    // Patient database eke innawa nam dashboard ekata yanawa
                    response.sendRedirect("dashboard.html");
                } else {
                    // Username/Password waradi nam error eka pennanawa (index.html wenuwata oyage login page eke nama danna)
                    out.println("<h3 style='color:red; text-align:center;'>Invalid Username or Password!</h3>");
                    out.println("<div style='text-align:center;'><a href='index.html' style='text-decoration:none; padding:8px 15px; background:blue; color:white; border-radius:5px;'>Try Again</a></div>");
                }
            } else {
                out.println("<h3 style='color:red;'>Database Connection Failed!</h3>");
            }

        } catch (Exception e) {
            response.getWriter().println("<h3 style='color:red;'>ERROR: " + e.getMessage() + "</h3>");
            e.printStackTrace();
        }
    }
}