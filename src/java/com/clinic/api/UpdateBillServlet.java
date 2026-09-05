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

@WebServlet(name = "UpdateBillServlet", urlPatterns = {"/UpdateBillServlet"})
public class UpdateBillServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String sessionUser = (String) session.getAttribute("username");
        
        if (sessionUser == null || !"admin".equals(sessionUser)) {
            response.sendRedirect("index.html");
            return;
        }

        String appNo = request.getParameter("appNo");
        String treatmentCostStr = request.getParameter("treatment_cost");
        String consultationFeeStr = request.getParameter("consultation_fee");

        try {
            // Values double walata convert karagannawa (empty unoth 0.0 widiyata save wenna)
            double treatmentCost = 0.0;
            double consultationFee = 0.0;

            if (treatmentCostStr != null && !treatmentCostStr.trim().isEmpty()) {
                treatmentCost = Double.parseDouble(treatmentCostStr);
            }
            if (consultationFeeStr != null && !consultationFeeStr.trim().isEmpty()) {
                consultationFee = Double.parseDouble(consultationFeeStr);
            }

            Connection con = DBConnection.getConnection();
            if (con != null) {
                String query = "UPDATE appointments SET treatment_cost=?, consultation_fee=? WHERE appointment_number=?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setDouble(1, treatmentCost);
                pst.setDouble(2, consultationFee);
                pst.setString(3, appNo);
                pst.executeUpdate();
            }
            response.sendRedirect("view_bill.jsp?appNo=" + appNo + "&success=Bill+Updated+Successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("view_bill.jsp?appNo=" + appNo + "&error=Update+Failed");
        }
    }
}