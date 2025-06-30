import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthService {
  static const _baseUrl = 'http://10.0.2.2:8000/api';
  final _storage = FlutterSecureStorage();

  Future<bool> requestLoginCode(String email) async {
    final url = Uri.parse('$_baseUrl/login/request-code');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: json.encode({'email': email}),
    );
    return response.statusCode == 200;
  }

  Future<bool> verifyLoginCode(String email, String code) async {
    final url = Uri.parse('$_baseUrl/login/verify-code');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: json.encode({'email': email, 'code': code}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return true;
    }
    return false;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    final url = Uri.parse('$_baseUrl/register');
    final response = await http.post(
      url,
      body: {
        'full_name': fullName,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<bool> loginWithPassword(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final response = await http.post(
      url,
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _storage.write(key: 'token', value: data['token']);
      return true;
    }
    return false;
  }
}
