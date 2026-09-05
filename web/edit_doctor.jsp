<%@page import="java.sql.*"%>
<%@page import="com.clinic.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Doctor</title>
    <style>
        body { font-family: Arial; margin: 50px; background: #f4f4f4; display: flex; justify-content: center; }
        .form-box { background: white; padding: 30px; width: 400px; border-radius: 8px; box-shadow: 0px 0px 10px #ccc; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        label { font-weight: bold; color: #333; }
        button { padding: 10px 15px; background: #ffc107; color: black; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; width: 100%; }
        .btn-cancel { background: #dc3545; color: white; text-decoration: none; padding: 10px 15px; border-radius: 4px; display: block; text-align: center; margin-top: 10px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="form-box">
        <h2 style="color: #004085; margin-top: 0; text-align: center;">Edit Doctor Details</h2>
        <%
            String id = request.getParameter("id");
            Connection con = DBConnection.getConnection();
            if(con != null && id != null) {
                PreparedStatement pst = con.prepareStatement("SELECT * FROM doctors WHERE id=?");
                pst.setString(1, id);
                ResultSet rs = pst.executeQuery();
                if(rs.next()) {
        %>
        <form action="EditDoctorServlet" method="POST">
            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
            
            <label>Doctor Name:</label>
            <input type="text" name="doctor_name" value="<%= rs.getString("doctor_name") %>" required>
            
            <label>Specialization (Treatment):</label>
            <input type="text" name="specialization" value="<%= rs.getString("specialization") %>" required>
            
            <label>Phone Number:</label>
            <input type="text" name="phone" value="<%= rs.getString("phone") %>" required>
            
            <br><br>
            <button type="submit">Update Doctor Details</button>
            <a href="admin.jsp" class="btn-cancel">Cancel & Go Back</a>
        </form>
        <%
                }
            }
        %>
    </div>
</body>
</html>