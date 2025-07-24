// lib/Services/invoice_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class InvoiceService {
  static String baseUrl = 'http://localhost:8080/api/invoices';

  static Future<List<Map<String, dynamic>>> fetchInvoices() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load invoices');
      }
    } catch (e) {
      print("Error fetching invoices: $e");
      return [];
    }
  }
}
