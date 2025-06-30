import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkLogin() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<bool> requestLoginCode(String email) async {
    return await _authService.requestLoginCode(email);
  }

  Future<bool> verifyLoginCode(String email, String code) async {
    final success = await _authService.verifyLoginCode(email, code);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  Future<bool> register(
    String fullName,
    String email,
    String password,
    String phone,
  ) async {
    final success = await _authService.register(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
    );
    _isAuthenticated = success;
    notifyListeners();
    return success;
  }

  Future<bool> loginWithPassword(String email, String password) async {
    final success = await _authService.loginWithPassword(email, password);
    _isAuthenticated = success;
    notifyListeners();
    return success;
  }

  void logout() {
    _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
