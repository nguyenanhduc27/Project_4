// lib/Screen/auth/login_screen.dart
import 'package:flutter/material.dart';
import '../../Services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;

  void _sendOtp() async {
    setState(() => _isLoading = true);
    final result = await AuthService.sendOtp(_emailController.text);
    setState(() {
      _isLoading = false;
      if (result) _isOtpSent = true;
    });

    if (!result) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể gửi mã OTP')));
    }
  }

  void _verifyOtp() async {
    setState(() => _isLoading = true);
    final result = await AuthService.verifyOtp(
      _emailController.text,
      _otpController.text,
    );
    setState(() => _isLoading = false);

    if (result) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Mã OTP không đúng hoặc hết hạn')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Đăng nhập Admin bằng OTP', style: TextStyle(fontSize: 22)),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              if (_isOtpSent)
                TextField(
                  controller: _otpController,
                  decoration: InputDecoration(labelText: 'Mã OTP'),
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
                      child: Text(_isOtpSent ? 'Xác nhận mã' : 'Gửi mã OTP'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
