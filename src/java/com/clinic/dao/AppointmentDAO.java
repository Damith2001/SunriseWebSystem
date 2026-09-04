package com.clinic.dao;
import java.sql.CallableStatement;
import java.sql.Connection;

public class AppointmentDAO {
    public boolean addAppointment(int patientId, String dentist, String treatment, String date, String time) {
        try {
            Connection con = DBConnection.getConnection();
            // Stored Procedure eka call kirima (Advanced Feature)
            CallableStatement stmt = con.prepareCall("{call AddAppointmentSp(?, ?, ?, ?, ?)}");
            stmt.setInt(1, patientId);
            stmt.setString(2, dentist);
            stmt.setString(3, treatment);
            stmt.setString(4, date);
            stmt.setString(5, time);
            stmt.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}