package com.clinic.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PatientDAO {
    // Aluth patient kenek register kirima
    public boolean registerPatient(String name, String address, String phone, String username, String password, String photoPath) {
        try {
            Connection con = DBConnection.getConnection();
            String query = "INSERT INTO patients (name, address, phone, username, password, photo_path) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, name);
            pst.setString(2, address);
            pst.setString(3, phone);
            pst.setString(4, username);
            pst.setString(5, password);
            pst.setString(6, photoPath);
            pst.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Patient Login kirima
    public int login(String username, String password) {
        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT id FROM patients WHERE username=? AND password=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                return rs.getInt("id"); // Login success nam ID eka denawa
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Fail nam -1 denawa
    }
}