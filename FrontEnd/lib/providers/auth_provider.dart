import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  User? _user;
  User? get user => _user;
  int? get userId => _user?.id;

  // Getter cho UI kiểm tra đăng nhập
  bool get isLoggedIn => _isAuthenticated;
  bool get isAuthenticated => _isAuthenticated;

  // Kiểm tra token khi khởi động app
  Future<void> checkLogin() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    if (_isAuthenticated) {
      _user = await _authService.getCurrentUser();
    } else {
      _user = null;
    }
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
      _user = await _authService.getCurrentUser();
      notifyListeners();
    }
    return success;
  }

  // Đăng xuất
  void logout() {
    _authService.logout();
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? address,
    String? dateOfBirth,
  }) async {
    final updatedUser = await _authService.updateCurrentUser(
      fullName: fullName,
      phone: phone,
      address: address,
      dateOfBirth: dateOfBirth,
    );
    if (updatedUser != null) {
      _user = updatedUser;
      notifyListeners();
      return true;
    }
    return false;
  }
}
