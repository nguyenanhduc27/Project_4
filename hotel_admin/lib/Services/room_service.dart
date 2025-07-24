// lib/Services/room_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class RoomService {
  static String baseUrl = 'http://localhost:8080/api/rooms';

  static Future<List<Map<String, dynamic>>> fetchRooms() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load rooms');
      }
    } catch (e) {
      print("Error fetching rooms: $e");
      return [];
    }
  }
}
