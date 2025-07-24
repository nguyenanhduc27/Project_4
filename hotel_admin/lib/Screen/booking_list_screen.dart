// lib/Screen/bookings/booking_list_screen.dart
import 'package:flutter/material.dart';
import '../../Services/booking_service.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final bookings = await BookingService.fetchBookings();
    setState(() {
      _bookings = bookings;
      _isLoading = false;
    });
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Card(
      child: ListTile(
        title: Text('Mã đơn: ${booking['id']}'),
        subtitle: Text(
          'User ID: ${booking['user_id'] ?? 'N/A'}\nTừ ${booking['check_in']} đến ${booking['check_out']}\nTổng tiền: ${booking['total_price']} VND',
        ),
        trailing: Chip(
          label: Text(
            booking['status'],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: _getStatusColor(booking['status']),
        ),
        isThreeLine: true,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý đơn đặt phòng')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadBookings,
              child: ListView.builder(
                itemCount: _bookings.length,
                itemBuilder: (context, index) {
                  return _buildBookingCard(_bookings[index]);
                },
              ),
            ),
    );
  }
}
