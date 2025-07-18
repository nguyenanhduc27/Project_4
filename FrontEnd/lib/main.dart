import 'package:flutter/material.dart';
import 'package:hotel_booking_app/providers/auth_provider.dart';
import 'package:hotel_booking_app/screens/personal_infor_screen.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/personal_infor_screen.dart';
import 'screens/home_screen.dart';
import 'widgets/auth_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return AuthWrapper(
      child: MaterialApp(
        title: 'Hotel Booking ',
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/profile': (context) => PersonalInfoScreen(),
          '/home': (context) => HotelBookingPage(),
        },
      ),
    );
  }
}
