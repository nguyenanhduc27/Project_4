package com.example.HotelBoking.Service;

import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

@Service
public class OtpService {
    private final Map<String, OtpData> otpStore = new HashMap<>();
    private static final int OTP_EXPIRY_MINUTES = 1; // OTP hết hạn sau 1 phút

    private static class OtpData {
        private final String otp;
        private final LocalDateTime expiryTime;

        public OtpData(String otp) {
            this.otp = otp;
            this.expiryTime = LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES);
        }

        public String getOtp() {
            return otp;
        }

        public boolean isExpired() {
            return LocalDateTime.now().isAfter(expiryTime);
        }
    }

    public String generateOtp(String email) {
        String otp = String.valueOf(100000 + new Random().nextInt(900000));
        otpStore.put(email, new OtpData(otp));
        return otp;
    }

    public boolean verifyOtp(String email, String inputOtp) {
        OtpData otpData = otpStore.get(email);
        if (otpData == null) {
            return false;
        }
        
        // Kiểm tra OTP có hết hạn không
        if (otpData.isExpired()) {
            otpStore.remove(email); // Xóa OTP đã hết hạn
            return false;
        }
        
        boolean isValid = otpData.getOtp().equals(inputOtp);
        if (isValid) {
            otpStore.remove(email); // Xóa OTP sau khi verify thành công
        }
        return isValid;
    }

    public void clearOtp(String email) {
        otpStore.remove(email);
    }

    // Phương thức để cleanup các OTP đã hết hạn (có thể gọi định kỳ)
    public void cleanupExpiredOtps() {
        otpStore.entrySet().removeIf(entry -> entry.getValue().isExpired());
    }
}

