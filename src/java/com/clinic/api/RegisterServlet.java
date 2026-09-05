package com.clinic.api;

import com.clinic.dao.DBConnection;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            Part part = request.getPart("photo");
            String fileName = "default.png";
            
            if (part != null && part.getSize() > 0) {
                fileName = part.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                part.write(uploadPath + File.separator + fileName);
            }

            Connection con = DBConnection.getConnection();
            if (con != null) {
                String query = "INSERT INTO patients (name, address, phone, username, password, profile_pic) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, name);
                pst.setString(2, address);
                pst.setString(3, phone);
                pst.setString(4, username);
                pst.setString(5, password);
                pst.setString(6, fileName);
                pst.executeUpdate();
            }

            // Register Successfully pop-up ekata redirect kirima
            response.sendRedirect("index.html?success=Registration+Successful.+Please+Login");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.html?error=Registration+Failed");
        }
    }
}