// lib/Services/hotel_image_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class HotelImageService {
  static String baseUrl = 'http://localhost:8080/api/hotel-images';

  static Future<List<Map<String, dynamic>>> fetchHotelImages() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load hotel images');
      }
    } catch (e) {
      print("Error fetching hotel images: $e");
      return [];
    }
  }

  static Future<bool> deleteImage(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
