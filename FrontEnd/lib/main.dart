import 'package:flutter/material.dart';
import 'package:hotel_booking_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: HotelBookingApp(),
    ),
  );
}

class HotelBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Bookingg App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HotelBookingPage(),
      },
    );
  }
}
