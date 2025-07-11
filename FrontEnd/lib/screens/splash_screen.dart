// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart'; // đường dẫn đến AuthProvider

// class SplashScreen extends StatefulWidget {
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   void _checkLoginStatus() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     await authProvider.checkLogin();

//     // Đợi thêm 1 chút để splash không biến mất quá nhanh
//     await Future.delayed(Duration(seconds: 1));

//     if (authProvider.isAuthenticated) {
//       Navigator.pushReplacementNamed(context, '/home'); // đã đăng nhập
//     } else {
//       Navigator.pushReplacementNamed(context, '/login'); // chưa đăng nhập
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           'HotelEase',
//           style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
