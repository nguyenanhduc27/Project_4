// lib/Services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static String baseUrl = 'http://localhost:8080/api/users';

  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }
}
