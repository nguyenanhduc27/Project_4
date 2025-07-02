package com.example.HotelBoking.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.mail.javamail.JavaMailSender;


@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendOtp(String to, String otp) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setTo(to);
            helper.setSubject("Mã OTP đăng nhập");
            helper.setText("Mã OTP của bạn là: <b>" + otp + "</b>", true);

            mailSender.send(message);
        } catch (MessagingException e) {
            throw new RuntimeException("Gửi OTP thất bại", e);
        }
    }
}

