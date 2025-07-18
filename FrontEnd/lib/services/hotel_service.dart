import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hotel.dart';
import '../models/room.dart';
// import '../models/room_type.dart'; // Added import for RoomType
import 'auth_service.dart';

class HotelService {
  static const _baseUrl = 'http://localhost:8080/api';

  Future<List<Hotel>> fetchHotels() async {
    final url = Uri.parse('$_baseUrl/hotels');
    final token = await AuthService().getToken();
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Hotel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hotels');
    }
  }

  Future<List<Hotel>> searchHotels({
    required String city,
    required DateTime checkIn,
    required DateTime checkOut,
    required int rooms,
  }) async {
    final token = await AuthService().getToken();
    final url = Uri.parse('$_baseUrl/hotels/search'
        '?checkIn=${checkIn.toIso8601String().substring(0, 10)}'
        '&checkOut=${checkOut.toIso8601String().substring(0, 10)}'
        '&city=$city'
        '&rooms=$rooms');
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Hotel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search hotels');
    }
  }

  Future<List<Room>> fetchRoomsByHotelId(int hotelId,
      {required String checkIn, required String checkOut}) async {
    final url = Uri.parse(
        '$_baseUrl/rooms/hotel/$hotelId?checkIn=$checkIn&checkOut=$checkOut');
    final token = await AuthService().getToken();
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rooms for hotel $hotelId');
    }
  }

  Future<List<RoomType>> fetchRoomTypesByHotelId(int hotelId,
      {required String checkIn, required String checkOut}) async {
    final url = Uri.parse(
        '$_baseUrl/hotels/$hotelId/room-types?checkIn=$checkIn&checkOut=$checkOut');
    final token = await AuthService().getToken();
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => RoomType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load room types for hotel $hotelId');
    }
  }
}
