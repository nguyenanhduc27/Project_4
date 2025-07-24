// lib/Services/amenity_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AmenityService {
  static String baseUrl = 'http://localhost:8080/api/amenities';

  static Future<List<Map<String, dynamic>>> fetchAmenities() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load amenities');
      }
    } catch (e) {
      print("Error fetching amenities: $e");
      return [];
    }
  }

  static Future<bool> addAmenity(String name) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name}),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteAmenity(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
