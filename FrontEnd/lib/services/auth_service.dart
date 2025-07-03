import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../models/user.dart';

class AuthService {
  static const _baseUrl = 'http://localhost:8080/api';
  final _storage = FlutterSecureStorage();

  Future<bool> requestLoginCode(String email) async {
    final url = Uri.parse('$_baseUrl/login/request-code');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'email': email}),
    );
    return response.statusCode == 200;
  }

  Future<bool> verifyLoginCode(String email, String code) async {
    final url = Uri.parse('$_baseUrl/login/verify-code');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'email': email, 'otp': code}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return true;
    }
    return false;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
}
