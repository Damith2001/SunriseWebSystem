<%@page import="java.sql.*"%>
<%@page import="com.clinic.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Patient</title>
    <style>
        body { font-family: Arial; margin: 50px; background: #f4f4f4; }
        .form-box { background: white; padding: 25px; width: 400px; border-radius: 8px; box-shadow: 0px 0px 10px #ccc; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        label { font-weight: bold; color: #333; }
        button { padding: 10px 15px; background: #004085; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .btn-cancel { background: #dc3545; color: white; text-decoration: none; padding: 10px 15px; border-radius: 4px; margin-left: 10px; display: inline-block; font-weight: bold; }
    </style>
</head>
<body>
    <div class="form-box">
        <h2 style="color: #004085; margin-top: 0;">Edit Patient Details</h2>
        <%
            String username = request.getParameter("id");
            Connection con = DBConnection.getConnection();
            if(con != null && username != null) {
                PreparedStatement pst = con.prepareStatement("SELECT * FROM patients WHERE username=?");
                pst.setString(1, username);
                ResultSet rs = pst.executeQuery();
                if(rs.next()) {
        %>
        <form action="EditPatientServlet" method="POST">
            <!-- Username eka hidden field ekak widiyata witharak thiyenawa, screen eke penne naha saha edit karannath ba -->
            <input type="hidden" name="username" value="<%= rs.getString("username") %>">
            
            <label>Patient Name:</label>
            <input type="text" name="name" value="<%= rs.getString("name") %>" required>
            
            <label>Phone Number:</label>
            <input type="text" name="phone" value="<%= rs.getString("phone") %>" required>
            
            <label>Address:</label>
            <input type="text" name="address" value="<%= rs.getString("address") %>" required>
            <br><br>
            <button type="submit">Update Details</button>
            <a href="admin.jsp" class="btn-cancel">Cancel</a>
        </form>
        <%
                }
            }
        %>
    </div>
</body>
</html>