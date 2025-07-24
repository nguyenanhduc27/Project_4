// lib/Services/room_type_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class RoomTypeService {
  static String baseUrl = 'http://localhost:8080/api/room-types';

  static Future<List<Map<String, dynamic>>> fetchRoomTypes() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load room types');
      }
    } catch (e) {
      print("Error fetching room types: $e");
      return [];
    }
  }
}
