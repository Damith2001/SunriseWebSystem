<%@page import="java.sql.*"%>
<%@page import="com.clinic.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    if(username == null) {
        response.sendRedirect("index.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Dashboard - Sunrise Dental</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f4f4f4; }
        .header { background: #004085; color: white; padding: 15px 20px; display: flex; justify-content: space-between; }
        .container { display: flex; margin: 20px; gap: 20px; }
        .profile-card { background: white; padding: 20px; border-radius: 8px; width: 30%; box-shadow: 0 0 10px #ccc; text-align: center; height: fit-content; }
        .profile-pic { width: 150px; height: 150px; border-radius: 50%; object-fit: cover; border: 3px solid #004085; margin-bottom: 15px; }
        .btn { padding: 10px 15px; border-radius: 5px; text-decoration: none; color: white; display: inline-block; font-weight: bold; margin-top: 10px; width: 90%; }
        .btn-edit { background: #ffc107; color: black; }
        .btn-delete { background: #dc3545; margin-top: 10px; }
        .appointments-card { background: white; padding: 20px; border-radius: 8px; width: 70%; box-shadow: 0 0 10px #ccc; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #343a40; color: white; }
        .btn-book { background: #28a745; margin-bottom: 15px; width: auto; padding: 10px 20px; }
        .btn-bill { background: #17a2b8; color: white; padding: 6px 10px; font-size: 14px; text-decoration: none; border-radius: 4px; display: inline-block; font-weight: bold; }
    </style>
</head>
<body>
    <div class="header">
        <h2>Sunrise Dental - Patient Portal</h2>
        <a href="LogoutServlet" style="color: #ffc107; font-weight: bold; text-decoration: none; margin-top: 10px;">Logout</a>
    </div>

    <div class="container">
        <%
            Connection con = DBConnection.getConnection();
            if(con != null) {
                PreparedStatement pst = con.prepareStatement("SELECT * FROM patients WHERE username=?");
                pst.setString(1, username);
                ResultSet rs = pst.executeQuery();
                if(rs.next()) {
                    String pic = rs.getString("profile_pic");
                    if(pic == null || pic.trim().isEmpty()) {
                        pic = "default.png";
                    }
        %>
        <!-- Profile Card -->
        <div class="profile-card">
            <img src="uploads/<%= pic %>" alt="Profile Picture" class="profile-pic" onerror="this.src='https://cdn-icons-png.flaticon.com/512/149/149071.png'">
            <h3 style="margin: 0; color: #004085;"><%= rs.getString("name") %></h3>
            <p style="color: gray; margin-top: 5px;"><%= username %></p>
            <hr>
            <p><b>Phone:</b> <%= rs.getString("phone") %></p>
            <p><b>Address:</b> <%= rs.getString("address") %></p>
            
            <a href="edit_profile.jsp" class="btn btn-edit">Edit Profile</a>
            <form action="DeleteProfileServlet" method="POST" onsubmit="return confirm('Are you sure you want to delete your profile permanently?');">
                <button type="submit" class="btn btn-delete" style="border:none; cursor:pointer;">Delete My Account</button>
            </form>
        </div>
        <%
                }
        %>

        <!-- Appointments List -->
        <div class="appointments-card">
            <h2 style="color: #004085; margin-top: 0;">My Appointments</h2>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <a href="appointment.jsp" class="btn btn-book" style="margin-bottom:0;">+ Book New Appointment</a>
                <!-- Patient Search Bar -->
                <input type="text" id="patientSearchInput" onkeyup="filterPatientAppointments()" placeholder="Search appointments..." style="padding: 8px; width: 250px; border: 1px solid #ccc; border-radius: 4px;">
            </div>
            
            <table id="patientAppointmentsTable">
                <tr>
                    <th>App No</th>
                    <th>Patient Name</th>
                    <th>Dentist</th>
                    <th>Treatment</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Actions</th>
                </tr>
                <%
                    PreparedStatement pst2 = con.prepareStatement("SELECT * FROM appointments WHERE username=? ORDER BY app_date DESC");
                    pst2.setString(1, username);
                    ResultSet rs2 = pst2.executeQuery();
                    boolean hasAppointments = false;
                    while(rs2.next()) {
                        hasAppointments = true;
                %>
                <tr>
                    <td><%= rs2.getString("appointment_number") %></td>
                    <td><b><%= rs2.getString("patient_name") %></b></td>
                    <td><%= rs2.getString("dentist") %></td>
                    <td><%= rs2.getString("treatment") %></td>
                    <td><%= rs2.getString("app_date") %></td>
                    <td><%= rs2.getString("app_time") %></td>
                    <td>
                        <a href="view_bill.jsp?appNo=<%= rs2.getString("appointment_number") %>" class="btn-bill">View Bill</a>
                    </td>
                </tr>
                <%
                    }
                    if(!hasAppointments) {
                        out.println("<tr><td colspan='7' style='text-align:center;'>No appointments found.</td></tr>");
                    }
                %>
            </table>
        </div>
        <%
            }
        %>
    </div>

    <!-- Pop-up message & Search Script -->
    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const successMsg = urlParams.get('success');
        const errorMsg = urlParams.get('error');
        const appNo = urlParams.get('appNo');

        if (successMsg) {
            let msg = successMsg.replace(/\+/g, ' ');
            if (appNo) msg += " (Appointment No: " + appNo + ")";
            alert(msg);
        } else if (errorMsg) {
            let err = errorMsg.replace(/\+/g, ' ');
            if (err === 'booked') {
                alert("Error: This doctor is already booked for the selected date and time!");
            } else {
                alert("Error: " + err);
            }
        }

        function filterPatientAppointments() {
            var input = document.getElementById("patientSearchInput");
            var filter = input.value.toLowerCase();
            var table = document.getElementById("patientAppointmentsTable");
            var tr = table.getElementsByTagName("tr");
            
            for (var i = 1; i < tr.length; i++) {
                var rowText = tr[i].textContent || tr[i].innerText;
                if (rowText.toLowerCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>