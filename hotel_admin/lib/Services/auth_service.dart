// lib/Services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static String baseUrl = 'http://localhost:8080/api/auth';

  // Gửi mã OTP về email
  static Future<bool> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Send OTP error: $e');
      return false;
    }
  }

  // Xác thực OTP
  static Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Token: ${data['token']}');
        // TODO: Lưu token vào localStorage nếu cần
        return true;
      }
      return false;
    } catch (e) {
      print('Verify OTP error: $e');
      return false;
    }
  }
}
