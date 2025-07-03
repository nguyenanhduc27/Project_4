package com.example.HotelBoking.Controller;

import com.example.HotelBoking.DTO.AuthRequest;
import com.example.HotelBoking.DTO.JwtResponse;
import com.example.HotelBoking.DTO.OtpRequest;
import com.example.HotelBoking.DTO.UserDTO;
import com.example.HotelBoking.Repository.UserRepository;
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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.example.HotelBoking.Entity.User;



@RestController
@RequestMapping("/api/login")
public class AuthController {
    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired private OtpService otpService;
    @Autowired private EmailService emailService;
    @Autowired private UserRepository userRepository;
    // Bước 1: Gửi OTP đến email nếu tài khoản tồn tại
    @PostMapping("/request-code")
    public ResponseEntity<?> requestLogin(@RequestBody AuthRequest request) {
        System.out.println("Email đã nhập: " + request.getEmail());

        // Kiểm tra email có tồn tại trong hệ thống không (nếu muốn)
        // UserDetails user = userDetailsService.loadUserByUsername(request.getEmail());
        // if (user == null) return ResponseEntity.status(404).body("Email không tồn tại!");

        String otp = otpService.generateOtp(request.getEmail());
        try {
            emailService.sendOtp(request.getEmail(), otp);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Lỗi gửi email: " + e.getMessage());
        }
        return ResponseEntity.ok("Mã OTP đã được gửi đến email.");
    }


    // Bước 2: Xác thực OTP và trả token
    @PostMapping("/verify-code")
    public ResponseEntity<?> verifyOtp(@RequestBody OtpRequest request) {
        if (!otpService.verifyOtp(request.getEmail(), request.getOtp())) {
            return ResponseEntity.status(401).body("OTP không đúng hoặc đã hết hạn");
        }
        
        User user = userRepository.findByEmail(request.getEmail());
        if (user == null) {
            user = new User();
            user.setEmail(request.getEmail());
            user.setPassword(""); // hoặc random, hoặc null
            userRepository.save(user);
        }

        UserDetails userDetails = userDetailsService.loadUserByUsername(request.getEmail());
        String token = jwtUtil.generateToken(userDetails.getUsername());

        return ResponseEntity.ok(new JwtResponse(token));
    }
}
