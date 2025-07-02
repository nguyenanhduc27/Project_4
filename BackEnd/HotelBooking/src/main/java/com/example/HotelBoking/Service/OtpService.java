package com.example.HotelBoking.Service;

import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
public class OtpService {
    private final Map<String, String> otpStore = new HashMap<>();

    public String generateOtp(String email) {
        String otp = String.valueOf(100000 + new Random().nextInt(900000));
        otpStore.put(email, otp);
        return otp;
    }

    public boolean verifyOtp(String email, String inputOtp) {
        return otpStore.containsKey(email) && otpStore.get(email).equals(inputOtp);
    }

    public void clearOtp(String email) {
        otpStore.remove(email);
    }
}

