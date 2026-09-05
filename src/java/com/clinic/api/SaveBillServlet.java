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

@WebServlet(name = "SaveBillServlet", urlPatterns = {"/SaveBillServlet"})
public class SaveBillServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String appNo = request.getParameter("appNo");
        String treatmentCost = request.getParameter("treatment_cost");
        String consultationFee = request.getParameter("consultation_fee");

        try {
            Connection con = DBConnection.getConnection();
            if (con != null) {
                String query = "UPDATE appointments SET treatment_cost=?, consultation_fee=? WHERE appointment_number=?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setDouble(1, Double.parseDouble(treatmentCost));
                pst.setDouble(2, Double.parseDouble(consultationFee));
                pst.setString(3, appNo);
                pst.executeUpdate();
            }
            response.sendRedirect("admin.jsp?success=Bill+Saved+Successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=Failed+to+save+bill");
        }
    }
}