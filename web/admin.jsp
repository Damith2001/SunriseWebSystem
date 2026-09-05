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
        h2 { color: #333; border-bottom: 2px solid #004085; padding-bottom: 5px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Admin Dashboard</h1>
        <a href="index.html" class="logout">Logout</a>
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
                <a href="DeleteDoctorServlet?id=<%= rs0.getInt("id") %>" class="btn btn-delete">Delete</a>
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
                <a href="DeletePatientServlet?id=<%= rs.getString("username") %>" class="btn btn-delete">Delete</a>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>

    <!-- Appointments Section -->
    <h2>All Appointments</h2>
    <a href="add_appointment.jsp" class="btn btn-add">+ Add New Appointment</a>
    <table>
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
          
                <a href="edit_appointment.jsp?appNo=<%= rs2.getString("appointment_number") %>" class="btn btn-edit">Edit</a>
                <a href="DeleteAppServlet?appNo=<%= rs2.getString("appointment_number") %>" class="btn btn-delete">Delete</a>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>
</body>
</html>