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
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/UpdateProfileServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10)
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("index.html?error=Session+Expired");
            return;
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        
        String fileName = "";
        Part filePart = request.getPart("profile_pic");

        boolean updatePassword = (password != null && !password.trim().isEmpty());
        boolean updatePhoto = (filePart != null && filePart.getSize() > 0);

        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                if (updatePhoto) {
                    fileName = filePart.getSubmittedFileName();
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();
                    filePart.write(uploadPath + File.separator + fileName);
                }

                String query;
                PreparedStatement pst;

                if (updatePhoto && updatePassword) {
                    query = "UPDATE patients SET name=?, phone=?, address=?, profile_pic=?, password=? WHERE username=?";
                    pst = con.prepareStatement(query);
                    pst.setString(1, name); pst.setString(2, phone); pst.setString(3, address); pst.setString(4, fileName); pst.setString(5, password); pst.setString(6, username);
                } else if (updatePhoto && !updatePassword) {
                    query = "UPDATE patients SET name=?, phone=?, address=?, profile_pic=? WHERE username=?";
                    pst = con.prepareStatement(query);
                    pst.setString(1, name); pst.setString(2, phone); pst.setString(3, address); pst.setString(4, fileName); pst.setString(5, username);
                } else if (!updatePhoto && updatePassword) {
                    query = "UPDATE patients SET name=?, phone=?, address=?, password=? WHERE username=?";
                    pst = con.prepareStatement(query);
                    pst.setString(1, name); pst.setString(2, phone); pst.setString(3, address); pst.setString(4, password); pst.setString(5, username);
                } else {
                    query = "UPDATE patients SET name=?, phone=?, address=? WHERE username=?";
                    pst = con.prepareStatement(query);
                    pst.setString(1, name); pst.setString(2, phone); pst.setString(3, address); pst.setString(4, username);
                }
                pst.executeUpdate();
            }
            // Edit Profile Successful pop-up ekata redirect kirima
            response.sendRedirect("dashboard.jsp?success=Profile+Updated+Successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("edit_profile.jsp?error=Update+Failed");
        }
    }
}