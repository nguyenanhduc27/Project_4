import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AuthWrapper extends StatefulWidget {
  final Widget child;
  
  const AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Kiểm tra login status khi app khởi động
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
} 