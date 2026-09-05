package com.clinic.api;

import com.clinic.dao.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        try {
            // Admin check
            if ("admin".equals(user) && "admin123".equals(pass)) {
                HttpSession session = request.getSession();
                session.setAttribute("username", "admin");
                response.sendRedirect("admin.jsp?success=Admin+Login+Successful");
                return;
            }

            Connection con = DBConnection.getConnection();
            if (con != null) {
                String query = "SELECT * FROM patients WHERE username=? AND password=?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, user);
                pst.setString(2, pass);
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", user);
                    session.setAttribute("name", rs.getString("name"));
                    session.setAttribute("profile_pic", rs.getString("profile_pic"));
                    session.setAttribute("phone", rs.getString("phone"));
                    session.setAttribute("address", rs.getString("address"));
                    
                    response.sendRedirect("dashboard.jsp?success=Login+Successful");
                } else {
                    // index.html wenuwata login.html walata redirect karanawa
                    response.sendRedirect("login.html?error=Invalid+Username+or+Password");
                }
            } else {
                // index.html wenuwata login.html walata redirect karanawa
                response.sendRedirect("login.html?error=Database+Connection+Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // index.html wenuwata login.html walata redirect karanawa
            response.sendRedirect("login.html?error=" + e.getMessage());
        }
    }
}