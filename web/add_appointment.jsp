<%@page import="java.sql.*"%>
<%@page import="com.clinic.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Appointment (Admin)</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f4f4f4; display: flex; justify-content: center; }
        .form-box { background: white; padding: 30px; width: 450px; border-radius: 8px; box-shadow: 0px 0px 10px #ccc; }
        input, select { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #28a745; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-cancel { display: block; text-align: center; margin-top: 15px; color: red; text-decoration: none; font-weight: bold; }
        .readonly-input { background-color: #e9ecef; color: #495057; cursor: not-allowed; }
    </style>
</head>
<body>
    <div class="form-box">
        <h2 style="color: #004085; margin-top: 0; text-align: center;">Add New Appointment</h2>
        <form action="AdminAddAppServlet" method="POST">
            <label>Patient Name:</label>
            <input type="text" name="name" required>

            <label>Contact Number:</label>
            <input type="text" name="contact_number" required>

            <label>Select Dentist:</label>
            <select name="dentist" id="dentistDropdown" onchange="updateTreatment()" required>
                <option value="" data-specialization="">-- Select a Doctor --</option>
                <%
                    Connection con = DBConnection.getConnection();
                    if(con != null) {
                        Statement st = con.createStatement();
                        ResultSet rs = st.executeQuery("SELECT * FROM doctors");
                        while(rs.next()) {
                            String docName = rs.getString("doctor_name");
                            String specialization = rs.getString("specialization");
                %>
                <option value="<%= docName %>" data-specialization="<%= specialization %>"><%= docName %> - <%= specialization %></option>
                <%
                        }
                    }
                %>
            </select>

            <label>Treatment Type:</label>
            <input type="text" name="treatment" id="treatmentInput" class="readonly-input" readonly required>

            <label>Select Date:</label>
            <input type="date" name="date" required>

            <label>Select Time:</label>
            <input type="time" name="time" required>

            <button type="submit">Save Appointment</button>
            <a href="admin.jsp" class="btn-cancel">Cancel & Go Back</a>
        </form>
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