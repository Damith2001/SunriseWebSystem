<%@page import="java.sql.*"%>
<%@page import="com.clinic.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Book Appointment - Sunrise Dental</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f4f4f4; display: flex; justify-content: center; }
        .form-box { background: white; padding: 30px; width: 450px; border-radius: 8px; box-shadow: 0px 0px 10px #ccc; }
        input, select { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        label { font-weight: bold; color: #333; }
        button { width: 100%; padding: 12px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; font-size: 16px; }
        button:hover { background: #0056b3; }
        .btn-cancel { display: block; text-align: center; margin-top: 15px; color: red; text-decoration: none; font-weight: bold; }
        .readonly-input { background-color: #e9ecef; color: #495057; cursor: not-allowed; }
    </style>
</head>
<body>
    <div class="form-box">
        <h2 style="color: #004085; margin-top: 0; text-align: center;">Book Appointment</h2>
        <form action="AppointmentServlet" method="POST">
            <label>Patient Name:</label>
            <input type="text" name="name" required>

            <label>Contact Number:</label>
            <input type="text" name="contact_number" required>

            <!-- Doctor select karaddi auto update wenna onchange eka dala thiyenawa -->
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
                <!-- data-specialization kiyana attribute eke doctorge specialization eka hangala thiyenawa -->
                <option value="<%= docName %>" data-specialization="<%= specialization %>"><%= docName %> - <%= specialization %></option>
                <%
                        }
                    }
                %>
            </select>

            <!-- Auto fill wena Treatment box eka (Readonly karala thiyenne edit karanna beri wenna) -->
            <label>Treatment Type:</label>
            <input type="text" name="treatment" id="treatmentInput" class="readonly-input" readonly required placeholder="Auto-filled based on Dentist">

            <label>Select Date:</label>
            <input type="date" name="date" required>

            <label>Select Time:</label>
            <input type="time" name="time" required>

            <button type="submit">Confirm Appointment</button>
            <a href="dashboard.html" class="btn-cancel">Back to Dashboard</a>
        </form>

        <div id="successMsg" style="text-align:center; margin-top:20px;"></div>
    </div>

    <script>
        // Doctor wa select karama auto treatment eka fill karana JavaScript function eka
        function updateTreatment() {
            var dropdown = document.getElementById("dentistDropdown");
            var selectedOption = dropdown.options[dropdown.selectedIndex];
            var specialization = selectedOption.getAttribute("data-specialization");
            
            // Eka treatment box ekata danawa
            document.getElementById("treatmentInput").value = specialization || "";
        }

        // Appointment eka success unama pennana message eka
        const urlParams = new URLSearchParams(window.location.search);
        const appNo = urlParams.get('appNo');
        if (appNo) {
            document.getElementById('successMsg').innerHTML = 
                "<div style='padding:15px; background-color:#d4edda; border:1px solid #c3e6cb; border-radius:5px;'>" +
                "<h3 style='color:#155724; margin:0;'>Appointment Successful!</h3>" + 
                "<h4 style='color:#004085; margin-top:10px;'>Appointment No: " + appNo + "</h4></div>";
        }
    </script>
</body>
</html>