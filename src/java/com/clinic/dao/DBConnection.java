package com.clinic.dao;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Database name eka lowercase walata hada atheema
        String url = "jdbc:mysql://localhost:3306/sunrisedentalnew?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        return DriverManager.getConnection(url, "root", "");
    }
}