<%@page import="java.sql.*"%>
<%@page import="com.clinic.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Sunrise Dental - Admin Panel</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f9f9f9; }
        .header { display: flex; justify-content: space-between; align-items: center; background: #004085; color: white; padding: 15px 20px; border-radius: 5px; margin-bottom: 20px; }
        .header h1 { margin: 0; }
        .logout { background: #dc3545; color: white; padding: 8px 15px; border-radius: 5px; text-decoration: none; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 40px; background: white; box-shadow: 0px 0px 5px #ccc; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #343a40; color: white; }
        .btn { padding: 8px 12px; text-decoration: none; border-radius: 4px; font-weight: bold; display: inline-block; }
        .btn-add { background: #28a745; color: white; margin-bottom: 10px; }
        .btn-edit { background: #ffc107; color: black; margin-right: 5px; }
        .btn-delete { background: #dc3545; color: white; }
        .btn-bill { background: #17a2b8; color: white; margin-right: 5px; }
        h2 { color: #333; border-bottom: 2px solid #004085; padding-bottom: 5px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Admin Dashboard</h1>
        <a href="LogoutServlet" class="logout">Logout</a>
    </div>

    <!-- Doctors Section -->
    <h2>Our Doctors</h2>
    <a href="add_doctor.html" class="btn btn-add">+ Add New Doctor</a>
    <table>
        <tr>
            <th>Doctor Name</th>
            <th>Specialization</th>
            <th>Phone</th>
            <th>Actions</th>
        </tr>
        <%
            Connection con = DBConnection.getConnection();
            if(con != null) {
                Statement st0 = con.createStatement();
                ResultSet rs0 = st0.executeQuery("SELECT * FROM doctors");
                while(rs0.next()) {
        %>
        <tr>
            <td><%= rs0.getString("doctor_name") %></td>
            <td><%= rs0.getString("specialization") %></td>
            <td><%= rs0.getString("phone") %></td>
            <td>
                <a href="edit_doctor.jsp?id=<%= rs0.getInt("id") %>" class="btn btn-edit">Edit</a>
                <a href="DeleteDoctorServlet?id=<%= rs0.getInt("id") %>" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this doctor?');">Delete</a>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>

    <!-- Patients Section -->
    <h2>Registered Patients</h2>
    <a href="add_patient.html" class="btn btn-add">+ Add New Patient</a>
    <table>
        <tr>
            <th>Name</th>
            <th>Phone</th>
            <th>Address</th>
            <th>Username</th>
            <th>Actions</th>
        </tr>
        <%
            if(con != null) {
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM patients");
                while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("address") %></td>
            <td><%= rs.getString("username") %></td>
            <td>
                <a href="edit_patient.jsp?id=<%= rs.getString("username") %>" class="btn btn-edit">Edit</a>
                <a href="DeletePatientServlet?id=<%= rs.getString("username") %>" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this patient?');">Delete</a>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>

    <!-- Appointments Section -->
    <h2>All Appointments</h2>
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
        <a href="add_appointment.jsp" class="btn btn-add" style="margin-bottom:0;">+ Add New Appointment</a>
        <!-- Live Search Bar -->
        <input type="text" id="adminSearchInput" onkeyup="filterAdminAppointments()" placeholder="Search by Patient, Dentist, App No..." style="padding: 8px; width: 300px; border: 1px solid #ccc; border-radius: 4px;">
    </div>
    
    <table id="appointmentsTable">
        <tr>
            <th>App No</th>
            <th>Patient Name</th>
            <th>Dentist & Treatment</th>
            <th>Date</th>
            <th>Time</th>
            <th>Actions</th>
        </tr>
        <%
            if(con != null) {
                Statement st2 = con.createStatement();
                ResultSet rs2 = st2.executeQuery("SELECT * FROM appointments");
                while(rs2.next()) {
        %>
        <tr>
            <td><%= rs2.getString("appointment_number") %></td>
            <td><%= rs2.getString("patient_name") %></td>
            <td><%= rs2.getString("dentist") %><br><small style="color:gray;"><%= rs2.getString("treatment") %></small></td>
            <td><%= rs2.getString("app_date") %></td>
            <td><%= rs2.getString("app_time") %></td>
            <td>
                <a href="view_bill.jsp?appNo=<%= rs2.getString("appointment_number") %>" class="btn btn-bill">Bill</a>
                <a href="edit_appointment.jsp?appNo=<%= rs2.getString("appointment_number") %>" class="btn btn-edit">Edit</a>
                <a href="DeleteAppServlet?appNo=<%= rs2.getString("appointment_number") %>" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this appointment?');">Delete</a>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>

    <!-- Pop-up message & Search Script -->
    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const successMsg = urlParams.get('success');
        const errorMsg = urlParams.get('error');

        if (successMsg) {
            alert(successMsg.replace(/\+/g, ' '));
        } else if (errorMsg) {
            alert("Error: " + errorMsg.replace(/\+/g, ' '));
        }

        function filterAdminAppointments() {
            var input = document.getElementById("adminSearchInput");
            var filter = input.value.toLowerCase();
            var table = document.getElementById("appointmentsTable");
            var tr = table.getElementsByTagName("tr");
            
            for (var i = 1; i < tr.length; i++) {
                var tdAppNo = tr[i].getElementsByTagName("td")[0];
                var tdPatient = tr[i].getElementsByTagName("td")[1];
                var tdDentist = tr[i].getElementsByTagName("td")[2];
                var tdDate = tr[i].getElementsByTagName("td")[3];
                
                if (tdAppNo || tdPatient || tdDentist || tdDate) {
                    var txtAppNo = tdAppNo ? tdAppNo.textContent || tdAppNo.innerText : "";
                    var txtPatient = tdPatient ? tdPatient.textContent || tdPatient.innerText : "";
                    var txtDentist = tdDentist ? tdDentist.textContent || tdDentist.innerText : "";
                    var txtDate = tdDate ? tdDate.textContent || tdDate.innerText : "";
                    
                    if (txtAppNo.toLowerCase().indexOf(filter) > -1 || 
                        txtPatient.toLowerCase().indexOf(filter) > -1 || 
                        txtDentist.toLowerCase().indexOf(filter) > -1 || 
                        txtDate.toLowerCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }       
            }
        }
    </script>
    <!-- Decision Making Reports & Analytics Section -->
    <div style="display: flex; gap: 20px; margin-bottom: 30px;">
        <%
            int totalPatients = 0;
            int totalAppointments = 0;
            double totalRevenue = 0.0;
            
            if(con != null) {
                // Total Patients Count
                ResultSet r1 = con.createStatement().executeQuery("SELECT COUNT(*) FROM patients");
                if(r1.next()) totalPatients = r1.getInt(1);
                
                // Total Appointments Count
                ResultSet r2 = con.createStatement().executeQuery("SELECT COUNT(*) FROM appointments");
                if(r2.next()) totalAppointments = r2.getInt(1);
                
                // Total Revenue Calculation (Treatment Cost + Consultation Fee)
                ResultSet r3 = con.createStatement().executeQuery("SELECT SUM(treatment_cost + consultation_fee) FROM appointments");
                if(r3.next()) totalRevenue = r3.getDouble(1);
            }
        %>
        <div style="background: white; padding: 20px; border-radius: 8px; flex: 1; box-shadow: 0 0 5px #ccc; border-left: 5px solid #28a745;">
            <h3 style="margin:0; color: gray; font-size: 14px;">Total Registered Patients</h3>
            <h2 style="margin: 10px 0 0; color: #333;"><%= totalPatients %></h2>
        </div>
        <div style="background: white; padding: 20px; border-radius: 8px; flex: 1; box-shadow: 0 0 5px #ccc; border-left: 5px solid #007bff;">
            <h3 style="margin:0; color: gray; font-size: 14px;">Total Appointments</h3>
            <h2 style="margin: 10px 0 0; color: #333;"><%= totalAppointments %></h2>
        </div>
        <div style="background: white; padding: 20px; border-radius: 8px; flex: 1; box-shadow: 0 0 5px #ccc; border-left: 5px solid #ffc107;">
            <h3 style="margin:0; color: gray; font-size: 14px;">Total Clinic Revenue</h3>
            <h2 style="margin: 10px 0 0; color: #333;">Rs. <%= String.format("%.2f", totalRevenue) %></h2>
        </div>
    </div>
</body>
</html>