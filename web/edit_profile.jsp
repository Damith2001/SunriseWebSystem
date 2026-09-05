<%@page import="java.sql.*"%>
<%@page import="com.clinic.dao.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    // Session eka nethnam kelinma login page (index.html) ekata yanawa
    if(username == null) { response.sendRedirect("index.html"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <style>
        body { font-family: Arial; margin: 40px; background: #f4f4f4; display: flex; justify-content: center; }
        .form-box { background: white; padding: 30px; width: 400px; border-radius: 8px; box-shadow: 0px 0px 10px #ccc; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-cancel { display: block; text-align: center; margin-top: 15px; color: red; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>
    <div class="form-box">
        <h2 style="color: #004085; margin-top: 0; text-align: center;">Edit Profile</h2>
        <%
            Connection con = DBConnection.getConnection();
            if(con != null) {
                PreparedStatement pst = con.prepareStatement("SELECT * FROM patients WHERE username=?");
                pst.setString(1, username);
                ResultSet rs = pst.executeQuery();
                if(rs.next()) {
        %>
        <form action="UpdateProfileServlet" method="POST" enctype="multipart/form-data">
            
            <label>Name:</label>
            <input type="text" name="name" value="<%= rs.getString("name") %>" required>

            <label>Phone Number:</label>
            <input type="text" name="phone" value="<%= rs.getString("phone") %>" required>
            
            <label>Address:</label>
            <input type="text" name="address" value="<%= rs.getString("address") %>" required>

            <!-- Aluth Password field eka -->
            <label>New Password:</label>
            <input type="password" name="password" placeholder="Leave blank to keep current password">

            <label>Profile Picture:</label>
            <input type="file" name="profile_pic" accept="image/*">
            <small style="color:gray;">Leave empty to keep current picture</small><br><br>

            <button type="submit">Update Profile</button>
            <a href="dashboard.jsp" class="btn-cancel">Cancel</a>
        </form>
        <%
                }
            }
        %>
    </div>
    <script>
    const urlParams = new URLSearchParams(window.location.search);
    const successMsg = urlParams.get('success');
    const errorMsg = urlParams.get('error');
    const appNo = urlParams.get('appNo');

    if (successMsg) {
        let msg = successMsg.replace(/\+/g, ' ');
        if (appNo) msg += " (Appointment No: " + appNo + ")";
        alert(msg); // Pop-up message
    } else if (errorMsg) {
        let err = errorMsg.replace(/\+/g, ' ');
        if (err === 'booked') {
            alert("Error: This doctor is already booked for the selected date and time!");
        } else {
            alert("Error: " + err);
        }
    }
</script>
</body>
</html>