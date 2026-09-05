<%@page import="java.sql.*"%>
<%@page import="com.clinic.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String appNo = request.getParameter("appNo");
    String sessionUser = (String) session.getAttribute("username");
    
    if(appNo == null || sessionUser == null) {
        response.sendRedirect("index.html");
        return;
    }
    
    boolean isAdmin = "admin".equals(sessionUser);
    String backPage = isAdmin ? "admin.jsp" : "dashboard.jsp";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bill & Receipt - Sunrise Dental</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; margin: 40px; display: flex; justify-content: center; }
        .receipt-box { background: white; padding: 40px; width: 500px; border-radius: 8px; box-shadow: 0 0 10px #ccc; }
        .clinic-header { text-align: center; border-bottom: 2px solid #004085; padding-bottom: 10px; margin-bottom: 20px; }
        .clinic-header h2 { margin: 0; color: #004085; }
        .details-table { width: 100%; margin-bottom: 20px; border-collapse: collapse; }
        .details-table td { padding: 8px 0; border-bottom: 1px dashed #ddd; }
        .cost-input { width: 120px; padding: 5px; text-align: right; font-size: 16px; border: 1px solid #ccc; border-radius: 4px; font-weight: bold; }
        .total-section { font-size: 18px; font-weight: bold; text-align: right; margin-top: 20px; color: #333; }
        .btn-container { text-align: center; margin-top: 30px; display: flex; justify-content: center; gap: 10px; flex-wrap: wrap; }
        .btn { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; text-decoration: none; display: inline-block; }
        .btn-print { background: #28a745; }
        .btn-save { background: #ffc107; color: black; }
        
        @media print {
            .btn-container { display: none; }
            body { background: white; margin: 0; }
            .receipt-box { box-shadow: none; padding: 0; width: 100%; }
            .cost-input { border: none; background: transparent; text-align: right; font-weight: bold; padding: 0; }
        }
    </style>
</head>
<body>
    <div class="receipt-box">
        <div class="clinic-header">
            <h2>Sunrise Dental Clinic</h2>
            <p style="margin: 5px 0 0; color: gray;">Official Treatment Receipt & Bill</p>
        </div>

        <%
            Connection con = DBConnection.getConnection();
            if(con != null) {
                PreparedStatement pst = con.prepareStatement("SELECT * FROM appointments WHERE appointment_number=?");
                pst.setString(1, appNo);
                ResultSet rs = pst.executeQuery();
                if(rs.next()) {
                    String treatment = rs.getString("treatment");
                    
                    double treatmentCost = rs.getDouble("treatment_cost");
                    double consultationFee = rs.getDouble("consultation_fee");
                    
                    // Admin kenek newei nam saha thama database eke costs save karala nethnam (0.0 nam)
                    if (!isAdmin && treatmentCost == 0.0 && consultationFee == 0.0) {
        %>
                        <table class="details-table">
                            <tr>
                                <td><b>Appointment No:</b></td>
                                <td style="text-align: right;"><%= rs.getString("appointment_number") %></td>
                            </tr>
                            <tr>
                                <td><b>Patient Name:</b></td>
                                <td style="text-align: right;"><%= rs.getString("patient_name") %></td>
                            </tr>
                            <tr>
                                <td><b>Treatment Type:</b></td>
                                <td style="text-align: right;"><%= treatment %></td>
                            </tr>
                        </table>
                        <div style="text-align: center; padding: 30px 0; color: #dc3545;">
                            <h3>Bill Not Generated Yet</h3>
                            <p style="color: #666; font-size: 14px;">Your bill has not been finalized or published by the clinic administration yet. Please check back later.</p>
                        </div>
                        <div class="btn-container">
                            <a href="dashboard.jsp" class="btn">Back to Dashboard</a>
                        </div>
        <%
                    } else {
                        // Admin kenek nam, hari patient ge bill eka save karala nam meka pennai
                        if(treatmentCost == 0.0 && consultationFee == 0.0) {
                            if(treatment != null) {
                                String t = treatment.toLowerCase();
                                if(t.contains("scaling") || t.contains("cleaning")) treatmentCost = 2500.00;
                                else if(t.contains("filling") || t.contains("composite")) treatmentCost = 4000.00;
                                else if(t.contains("extraction") || t.contains("surgery")) treatmentCost = 3500.00;
                                else if(t.contains("root canal")) treatmentCost = 8500.00;
                                else if(t.contains("braces") || t.contains("orthodontics")) treatmentCost = 25000.00;
                                else treatmentCost = 3000.00;
                            }
                            consultationFee = 1500.00;
                        }
                        
                        double totalCost = treatmentCost + consultationFee;
        %>

        <table class="details-table">
            <tr>
                <td><b>Appointment No:</b></td>
                <td style="text-align: right;"><%= rs.getString("appointment_number") %></td>
            </tr>
            <tr>
                <td><b>Patient Name:</b></td>
                <td style="text-align: right;"><%= rs.getString("patient_name") %></td>
            </tr>
            <tr>
                <td><b>Contact Number:</b></td>
                <td style="text-align: right;"><%= rs.getString("contact_number") %></td>
            </tr>
            <tr>
                <td><b>Dentist:</b></td>
                <td style="text-align: right;"><%= rs.getString("dentist") %></td>
            </tr>
            <tr>
                <td><b>Treatment Type:</b></td>
                <td style="text-align: right;"><%= treatment %></td>
            </tr>
            <tr>
                <td><b>Date & Time:</b></td>
                <td style="text-align: right;"><%= rs.getString("app_date") %> | <%= rs.getString("app_time") %></td>
            </tr>
        </table>

        <form action="UpdateBillServlet" method="POST">
            <input type="hidden" name="appNo" value="<%= appNo %>">
            
            <table class="details-table" style="border-top: 2px solid #333; padding-top: 10px;">
                <% if(isAdmin) { %>
                    <tr>
                        <td>Treatment Cost (Rs.):</td>
                        <td style="text-align: right;">
                            <input type="number" name="treatment_cost" id="treatmentCost" class="cost-input" value="<%= treatmentCost %>" step="0.01" oninput="calculateTotal()" required>
                        </td>
                    </tr>
                    <tr>
                        <td>Consultation Fee (Rs.):</td>
                        <td style="text-align: right;">
                            <input type="number" name="consultation_fee" id="consultationFee" class="cost-input" value="<%= consultationFee %>" step="0.01" oninput="calculateTotal()" required>
                        </td>
                    </tr>
                <% } else { %>
                    <tr>
                        <td>Treatment Cost:</td>
                        <td style="text-align: right;">Rs. <%= String.format("%.2f", treatmentCost) %></td>
                    </tr>
                    <tr>
                        <td>Consultation Fee:</td>
                        <td style="text-align: right;">Rs. <%= String.format("%.2f", consultationFee) %></td>
                    </tr>
                <% } %>
            </table>

            <div class="total-section" id="totalDisplay">
                Total Amount: Rs. <%= String.format("%.2f", totalCost) %>
            </div>

            <div class="btn-container">
                <% if(isAdmin) { %>
                    <button type="submit" class="btn btn-save">Save Bill</button>
                <% } %>
                <button type="button" onclick="window.print()" class="btn btn-print">Print Receipt</button>
                <a href="<%= backPage %>" class="btn">Back</a>
            </div>
        </form>

        <%
                    }
                } else {
                    out.println("<h3 style='color:red; text-align:center;'>Appointment not found!</h3>");
                }
            }
        %>
    </div>

    <% if(isAdmin) { %>
    <script>
        function calculateTotal() {
            var tCost = parseFloat(document.getElementById("treatmentCost").value) || 0;
            var cFee = parseFloat(document.getElementById("consultationFee").value) || 0;
            var total = tCost + cFee;
            document.getElementById("totalDisplay").innerHTML = "Total Amount: Rs. " + total.toFixed(2);
        }
    </script>
    <% } %>

    <script>
        // Alert popup for success/error messages
        const urlParams = new URLSearchParams(window.location.search);
        const successMsg = urlParams.get('success');
        const errorMsg = urlParams.get('error');
        if (successMsg) {
            alert(successMsg.replace(/\+/g, ' '));
        } else if (errorMsg) {
            alert("Error: " + errorMsg.replace(/\+/g, ' '));
        }
    </script>
</body>
</html>