import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../models/RoomOption.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import 'package:intl/intl.dart';
import '../services/booking_service.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const PaymentPage({super.key, required this.bookingData});

  int _calculateNights() {
    // Có thể lấy từ bookingData nếu cần
    return 1;
  }

  double _calculateTax() {
    return (bookingData['totalPrice'] ?? 0) * 0.10;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dataToSend = Map<String, dynamic>.from(bookingData);
    if (authProvider.isLoggedIn && authProvider.userId != null) {
      dataToSend['userId'] = authProvider.userId;
    }
    final hotel = bookingData['hotel'];
    final roomOptions = (bookingData['rooms'] as List).map((e) => e).toList();
    final totalAmount = bookingData['totalPrice'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: CustomHeader()),
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/resort-title-bg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          'Thanh Toán',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black45,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: _buildStepProgress(),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 1200 ? 200 : 20,
                  vertical: 40,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (constraints.maxWidth > 800)
                        SizedBox(
                          width: 320,
                          child:
                              _buildRoomInfo(hotel, roomOptions, totalAmount),
                        ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 3,
                        child: _buildPaymentSection(context),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: CustomFooter()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(1, 'Bạn chọn', true),
        _buildStepLine(),
        _buildStepCircle(2, 'Chi tiết về bạn', true),
        _buildStepLine(),
        _buildStepCircle(3, 'Hoàn tất đặt phòng', true),
      ],
    );
  }

  Widget _buildStepCircle(int number, String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isActive ? Colors.blue : Colors.grey,
          child: isActive
              ? Icon(Icons.check, color: Colors.white, size: 18)
              : Text('$number',
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black : Colors.grey)),
      ],
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 400,
      height: 1,
      color: Colors.grey,
    );
  }

  Widget _buildRoomInfo(dynamic hotel, List roomOptions, double totalAmount) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông Tin Phòng',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800])),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                hotel is Hotel
                    ? hotel.thumbnailUrl ?? ''
                    : hotel['thumbnailUrl'] ?? '',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: Text('Không tải được ảnh')),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...roomOptions.map((item) {
              Map<String, dynamic> roomData;
              int quantity = 1;

              if (item is Map) {
                if (item['room'] is Map<String, dynamic>) {
                  roomData = item['room'] as Map<String, dynamic>;
                } else if (item['room'] is RoomOption) {
                  roomData = (item['room'] as RoomOption).toJson();
                } else {
                  return SizedBox();
                }
                quantity = item['quantity'] ?? 1;
              } else {
                return SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${roomData['type']} x $quantity',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Giường: ${roomData['bedInfo']}',
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Wrap(spacing: 8, children: [
                      _amenityTag(Icons.wifi, 'Wifi miễn phí'),
                      _amenityTag(Icons.restaurant, 'Bữa sáng miễn phí'),
                      if (roomData['freeCancellation'] == true)
                        _amenityTag(Icons.check_circle, 'Hủy miễn phí'),
                      if (roomData['payLater'] == true)
                        _amenityTag(Icons.payment, 'Thanh toán sau'),
                    ]),
                    const SizedBox(height: 4),
                    Text('Giá: ${roomData['price'].toStringAsFixed(0)} VND',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            Text('Chi Tiết Đặt Phòng',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800])),
            const SizedBox(height: 8),
            Text('Nhận phòng: ${bookingData['checkIn'] ?? ''}',
                style: TextStyle(fontSize: 16)),
            Text('Trả phòng: ${bookingData['checkOut'] ?? ''}',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Tóm Tắt Giá',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800])),
            const SizedBox(height: 8),
            _buildSummaryItem(
                'Tổng tiền', '${totalAmount.toStringAsFixed(0)} VND',
                isBold: true),
            _buildSummaryItem(
                'Thuế (10%)', '${_calculateTax().toStringAsFixed(0)} VND'),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phương Thức Thanh Toán',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800])),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.payment, color: Colors.green),
              title: Text('VNPay'),
              trailing: ElevatedButton(
                onPressed: () async {
                  try {
                    final dataToSend = Map<String, dynamic>.from(bookingData);
                    if (dataToSend['hotel'] is Hotel) {
                      dataToSend['hotel'] =
                          (dataToSend['hotel'] as Hotel).toJson();
                    }
                    if (!dataToSend.containsKey('userId')) {
                      dataToSend['userId'] = null;
                    }

                    // 1. Gửi booking lên backend
                    final bookingResponse =
                        await BookingService.createBooking(dataToSend);

                    // 2. Lấy bookingId từ response
                    final bookingId = bookingResponse['id']; // 63
                    final totalPrice = bookingResponse['totalPrice'];

                    final amount = totalPrice.round();

                    // 3. Gửi bookingId này vào API lấy link VNPay
                    final response = await http.post(
                      Uri.parse('http://localhost:8080/api/payment/vnpay'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'bookingId': bookingId,
                        'amount': bookingResponse['totalPrice'],
                        'orderInfo': 'Thanh toán đơn hàng #$bookingId',
                      }),
                    );

                    if (response.statusCode == 200) {
                      final data = jsonDecode(response.body);
                      final paymentUrl = data['paymentUrl'];
                      final uri = Uri.parse(paymentUrl);
                      if (!await launchUrl(uri,
                          mode: LaunchMode.externalApplication)) {
                        throw 'Không thể mở link VNPay';
                      }
                    } else {
                      throw 'Không lấy được link thanh toán VNPay';
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: $e')),
                    );
                  }
                },
                child: const Text('Thanh Toán'),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.credit_card, color: Colors.orange),
              title: Text('Thẻ Tín Dụng'),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Thanh toán bằng thẻ tín dụng...')),
                  );
                },
                child: const Text('Thanh Toán'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: '$label: ',
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            TextSpan(
                text: value,
                style: TextStyle(
                    fontSize: 16,
                    color: isBold ? Colors.blue[700] : Colors.black87,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String date, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(date, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          Text(time, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _amenityTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: Colors.blue[700]),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: Colors.blue[700],
                fontWeight: FontWeight.w500)),
      ]),
    );
  }
}
