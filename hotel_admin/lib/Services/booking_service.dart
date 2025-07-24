// lib/Services/booking_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingService {
  static String baseUrl = 'http://localhost:8080/api/bookings';

  static Future<List<Map<String, dynamic>>> fetchBookings() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      print("Error fetching bookings: $e");
      return [];
    }
  }
}
