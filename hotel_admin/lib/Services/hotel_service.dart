import 'dart:convert';
import 'package:http/http.dart' as http;

class HotelService {
  static const String baseUrl = 'http://localhost:8080/api/hotels';

  // Lấy danh sách khách sạn
  static Future<List<Map<String, dynamic>>> fetchHotels() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        print('Failed to load hotels. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching hotels: $e');
      return [];
    }
  }

  // Tạo mới khách sạn
  static Future<bool> createHotel(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error creating hotel: $e');
      return false;
    }
  }

  // Cập nhật khách sạn
  static Future<bool> updateHotel(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating hotel: $e');
      return false;
    }
  }

  // Xoá khách sạn
  static Future<bool> deleteHotel(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting hotel: $e');
      return false;
    }
  }
}
