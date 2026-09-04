package com.clinic.api;
import com.clinic.dao.PatientDAO;
import java.io.File;
import java.io.IOException;
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
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Part part = request.getPart("photo");
        String fileName = part.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        part.write(uploadPath + File.separator + fileName);
        String photoPath = "uploads/" + fileName;

        PatientDAO dao = new PatientDAO();
        if (dao.registerPatient(name, address, phone, username, password, photoPath)) {
            response.sendRedirect("index.html");
        } else {
            response.getWriter().println("<h3>Registration Failed!</h3>");
        }
    }
}