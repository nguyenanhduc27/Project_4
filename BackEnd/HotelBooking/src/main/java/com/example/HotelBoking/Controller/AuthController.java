package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.AuthRequest;
import com.example.HotelBoking.DTO.JwtResponse;
import com.example.HotelBoking.DTO.OtpRequest;
import com.example.HotelBoking.DTO.UserDTO;
import com.example.HotelBoking.Service.CustomUserDetailsService;
import com.example.HotelBoking.Service.EmailService;
import com.example.HotelBoking.Service.OtpService;
import com.example.HotelBoking.Service.UserService;
import com.example.HotelBoking.Until.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.HotelBoking.Entity.User;



@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired private OtpService otpService;
    @Autowired private EmailService emailService;

    // Bước 1: Xác thực tài khoản và gửi OTP
    @PostMapping("/login-request")
    public ResponseEntity<?> requestLogin(@RequestBody AuthRequest request) {
        System.out.println("Email đã nhập: " + request.getEmail());

        try {
            UserDetails user = userDetailsService.loadUserByUsername(request.getEmail());
        } catch (UsernameNotFoundException e) {
            return ResponseEntity.status(401).body("Không tìm thấy người dùng với email: " + request.getEmail());
        }

        String otp = otpService.generateOtp(request.getEmail());
        emailService.sendOtp(request.getEmail(), otp);

        return ResponseEntity.ok("Mã OTP đã được gửi đến email.");
    }


    // Bước 2: Xác thực OTP và trả token
    @PostMapping("/verify-otp")
    public ResponseEntity<?> verifyOtp(@RequestBody OtpRequest request) {
        if (!otpService.verifyOtp(request.getEmail(), request.getOtp())) {
            return ResponseEntity.status(401).body("OTP không đúng hoặc đã hết hạn");
        }

        UserDetails user = userDetailsService.loadUserByUsername(request.getEmail());
        String token = jwtUtil.generateToken(user.getUsername());

        return ResponseEntity.ok(new JwtResponse(token));
    }
}
