package com.clinic.utils;

public class NotificationService {
    // Appointment eka dapu gaman SMS ekak yawana mock method eka
    public static void sendSMS(String phone, String message) {
        System.out.println("SMS SENT TO " + phone + ": " + message);
    }
}