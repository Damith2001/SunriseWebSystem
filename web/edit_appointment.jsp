<%@page import="java.sql.*"%>
<%@page import="com.clinic.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String appNo = request.getParameter("appNo");
    if(appNo == null) {
        response.sendRedirect("admin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Appointment - Sunrise Dental</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f4f4f4; display: flex; justify-content: center; }
        .form-box { background: white; padding: 30px; width: 450px; border-radius: 8px; box-shadow: 0px 0px 10px #ccc; }
        input, select { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        label { font-weight: bold; color: #333; }
        button { width: 100%; padding: 12px; background: #ffc107; color: black; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; font-size: 16px; }
        button:hover { background: #e0a800; }
        .btn-cancel { display: block; text-align: center; margin-top: 15px; color: red; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>
    <div class="form-box">
        <h2 style="color: #004085; margin-top: 0; text-align: center;">Edit Appointment</h2>
        
        <%
            Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement("SELECT * FROM appointments WHERE appointment_number=?");
            pst.setString(1, appNo);
            ResultSet rs = pst.executeQuery();
            if(rs.next()) {
        %>
        
        <form action="UpdateAppServlet" method="POST">
            <input type="hidden" name="appNo" value="<%= appNo %>">

            <label>Patient Name:</label>
            <input type="text" name="name" value="<%= rs.getString("patient_name") %>" required>

            <label>Contact Number:</label>
            <input type="text" name="contact_number" value="<%= rs.getString("contact_number") %>" required>

            <label>Email Address:</label>
            <input type="email" name="email" value="<%= rs.getString("email") != null ? rs.getString("email") : "" %>" required>

            <label>Dentist:</label>
            <input type="text" name="dentist" value="<%= rs.getString("dentist") %>" required>

            <label>Treatment Type:</label>
            <input type="text" name="treatment" value="<%= rs.getString("treatment") %>" required>

            <label>Date:</label>
            <input type="date" name="date" value="<%= rs.getString("app_date") %>" required>

            <label>Time:</label>
            <input type="time" name="time" value="<%= rs.getString("app_time") %>" required>

            <button type="submit">Update Appointment</button>
            <a href="admin.jsp" class="btn-cancel">Cancel</a>
        </form>
        
        <%
            }
        %>
    </div>
</body>
</html>