package com.clinic.dao;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // SunriseDentalNew database ekata connect wima
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/SunriseDentalNew", "root", "");
            System.out.println("Database Connected Successfully!");
        } catch (Exception e) {
            System.out.println("Database Connection Error: " + e.getMessage());
        }
        return con;
    }
}