import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isAuthenticated = false;

  // Getter cho UI kiểm tra đăng nhập
  bool get isLoggedIn => _isAuthenticated;
  bool get isAuthenticated => _isAuthenticated;

  // Kiểm tra token khi khởi động app
  Future<void> checkLogin() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  // Gửi mã xác nhận đăng nhập
  Future<bool> requestLoginCode(String email) async {
    return await _authService.requestLoginCode(email);
  }

  // Xác minh mã xác nhận, nếu đúng thì login thành công
  Future<bool> verifyLoginCode(String email, String code) async {
    final success = await _authService.verifyLoginCode(email, code);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  // Đăng xuất
  void logout() {
    _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
