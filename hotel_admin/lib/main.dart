import 'package:flutter/material.dart';
import 'Screen/dashboard_screen.dart';
import 'Screen/room_list_screen.dart';
import 'Screen/booking_list_screen.dart';
import 'Screen/room_type_list_screen.dart';
import 'Screen/user_list_screen.dart';
import 'Screen/invoice_list_screen.dart';
import 'Screen/amenity_list_screen.dart';
import 'Screen/hotel_image_list_screen.dart';
import 'Screen/hotel_list_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/rooms': (context) => const RoomListScreen(),
        '/bookings': (context) => const BookingListScreen(),
        '/room-types': (context) => const RoomTypeListScreen(),
        '/users': (context) => const UserListScreen(),
        '/invoices': (context) => const InvoiceListScreen(),
        '/amenities': (context) => const AmenityListScreen(),
        '/hotel-images': (context) => const HotelImageListScreen(),
        '/hotels': (context) => const HotelListScreen(),
      },
    );
  }
}
