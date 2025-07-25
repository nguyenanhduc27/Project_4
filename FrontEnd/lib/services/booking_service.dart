import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingService {
  static Future<Map<String, dynamic>> createBooking(
      Map<String, dynamic> bookingData) async {
    try {
      // Kiểm tra các trường bắt buộc
      if (bookingData['hotelId'] == null ||
          bookingData['checkIn'] == null ||
          bookingData['checkOut'] == null ||
          bookingData['totalPrice'] == null ||
          bookingData['contact'] == null ||
          bookingData['rooms'] == null ||
          (bookingData['rooms'] as List).isEmpty) {
        throw Exception('Thiếu thông tin bắt buộc!');
      }

      final contact = bookingData['contact'];
      if (contact['fullName'] == null ||
          contact['email'] == null ||
          contact['phone'] == null) {
        throw Exception('Thiếu thông tin liên hệ!');
      }

      // Chuẩn bị dữ liệu để gửi
      final dataToSend = {
        'hotelId': bookingData['hotelId'],
        'userId': bookingData['userId'], // Có thể null nếu user chưa đăng nhập
        'checkIn': bookingData['checkIn'],
        'checkOut': bookingData['checkOut'],
        'totalPrice': bookingData['totalPrice'],
        'contact': {
          'fullName': contact['fullName'],
          'email': contact['email'],
          'phone': contact['phone'],
          'note': contact['note'] ?? '',
        },
        'rooms': bookingData['rooms'],
      };

      print('Dữ liệu gửi đi: ${jsonEncode(dataToSend)}');

      // Gửi API
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataToSend),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Trả về dữ liệu JSON từ API
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        throw Exception('Lỗi lưu booking: ${response.body}');
      }
    } catch (e) {
      print('Lỗi trong createBooking: $e');
      rethrow;
    }
  }
}
