package com.example.HotelBoking.Controller;

import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/test")
public class EmailController {

    @Autowired
    private JavaMailSender mailSender;

    @GetMapping("/send-otp")
    public ResponseEntity<?> sendOtpEmail() {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setTo("cuong.th.2238@aptechlearning.edu.vn"); // ← bạn có thể dùng bất kỳ email nào
            helper.setSubject("Mã OTP của bạn");
            helper.setText("Mã OTP để đăng nhập là: <b>123456</b>", true);

            mailSender.send(message);
            return ResponseEntity.ok("Gửi OTP thành công");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Lỗi gửi email: " + e.getMessage());
        }
    }
}
