<%@page import="java.sql.*"%>
<%@page import="com.clinic.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Appointment</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f4f4f4; display: flex; justify-content: center; }
        .form-box { background: white; padding: 30px; width: 450px; border-radius: 8px; box-shadow: 0px 0px 10px #ccc; }
        input, select { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #ffc107; color: black; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-cancel { display: block; text-align: center; margin-top: 15px; color: red; text-decoration: none; font-weight: bold; }
        .readonly-input { background-color: #e9ecef; color: #495057; cursor: not-allowed; }
        .error-msg { color: red; text-align: center; font-weight: bold; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="form-box">
        <h2 style="color: #004085; margin-top: 0; text-align: center;">Edit Appointment Details</h2>
        <%
            String appNo = request.getParameter("appNo");
            
            // Appointment ID eka URL eken awith nethnam
            if (appNo == null || appNo.trim().isEmpty()) {
                out.println("<p class='error-msg'>Error: Appointment ID is missing!</p>");
                out.println("<a href='admin.jsp' class='btn-cancel'>Go Back</a>");
            } else {
                try {
                    Connection con = DBConnection.getConnection();
                    if(con != null) {
                        PreparedStatement pst = con.prepareStatement("SELECT * FROM appointments WHERE appointment_number=?");
                        pst.setString(1, appNo);
                        ResultSet rsApp = pst.executeQuery();
                        
                        // Database eke e appointment eka thiyenawanam form eka pennanawa
                        if(rsApp.next()) {
        %>
        <form action="EditAppServlet" method="POST">
            <input type="hidden" name="appointment_number" value="<%= rsApp.getString("appointment_number") %>">
            
            <label>Patient Name:</label>
            <input type="text" name="name" value="<%= rsApp.getString("patient_name") %>" required>

            <label>Contact Number:</label>
            <input type="text" name="contact_number" value="<%= rsApp.getString("contact_number") %>" required>

            <label>Select Dentist:</label>
            <select name="dentist" id="dentistDropdown" onchange="updateTreatment()" required>
                <option value="<%= rsApp.getString("dentist") %>" data-specialization="<%= rsApp.getString("treatment") %>"><%= rsApp.getString("dentist") %> (Current)</option>
                <%
                    Statement st = con.createStatement();
                    ResultSet rsDoc = st.executeQuery("SELECT * FROM doctors");
                    while(rsDoc.next()) {
                        String docName = rsDoc.getString("doctor_name");
                        String specialization = rsDoc.getString("specialization");
                %>
                <option value="<%= docName %>" data-specialization="<%= specialization %>"><%= docName %> - <%= specialization %></option>
                <%
                    }
                %>
            </select>

            <label>Treatment Type:</label>
            <input type="text" name="treatment" id="treatmentInput" class="readonly-input" value="<%= rsApp.getString("treatment") %>" readonly required>

            <label>Date:</label>
            <input type="date" name="date" value="<%= rsApp.getString("app_date") %>" required>

            <label>Time:</label>
            <input type="time" name="time" value="<%= rsApp.getString("app_time") %>" required>

            <button type="submit">Update Appointment</button>
            <a href="admin.jsp" class="btn-cancel">Cancel & Go Back</a>
        </form>
        <%
                        } else {
                            // Appointment eka database eke nethnam meka pennanawa
                            out.println("<p class='error-msg'>Error: No appointment found for ID: " + appNo + "</p>");
                            out.println("<a href='admin.jsp' class='btn-cancel'>Go Back</a>");
                        }
                    } else {
                        out.println("<p class='error-msg'>Error: Database connection failed!</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='error-msg'>System Error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
    <script>
        function updateTreatment() {
            var dropdown = document.getElementById("dentistDropdown");
            var selectedOption = dropdown.options[dropdown.selectedIndex];
            document.getElementById("treatmentInput").value = selectedOption.getAttribute("data-specialization") || "";
        }
    </script>
</body>
</html>