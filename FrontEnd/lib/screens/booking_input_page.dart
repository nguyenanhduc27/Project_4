import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/hotel.dart';
import '../models/RoomOption.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import 'payment_page.dart';

class BookingInputPage extends StatefulWidget {
  final Hotel hotel;
  final List<Map<String, dynamic>> bookingRooms; // Đổi sang bookingRooms
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final int numberOfRooms;

  const BookingInputPage({
    super.key,
    required this.hotel,
    required this.bookingRooms,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.numberOfRooms,
  });

  @override
  State<BookingInputPage> createState() => _BookingInputPageState();
}

class _BookingInputPageState extends State<BookingInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController(text: 'Nguyen Van A');
  final _emailController =
      TextEditingController(text: 'nam.bd.2144@aptechlearning.edu.vn');
  final _phoneController = TextEditingController(text: '0123456789');
  final _specialRequestController = TextEditingController();
  bool isLoading = false;

  int _calculateNights() {
    return widget.checkOutDate.difference(widget.checkInDate).inDays;
  }

  double _calculateTotalPrice() {
    return widget.bookingRooms.fold(0.0, (sum, item) {
          final room = item['room'] as RoomOption;
          final quantity = item['quantity'] as int;
          return sum + room.price * quantity;
        }) *
        _calculateNights();
  }

  double _calculateTax() {
    return _calculateTotalPrice() * 0.10; // 10% tax
  }

  void _completeBooking() {
    if (!_formKey.currentState!.validate() || _calculateNights() <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng kiểm tra ngày check-in/check-out!'),
        ),
      );
      return;
    }

    final totalAmount = _calculateTotalPrice() + _calculateTax();

    // Chuẩn bị object bookingData
    final bookingData = {
      'hotelId': widget.hotel.id,
      'hotel': widget.hotel.toJson(), // Chuyển đổi Hotel object thành JSON
      'checkIn': widget.checkInDate.toIso8601String().substring(0, 10),
      'checkOut': widget.checkOutDate.toIso8601String().substring(0, 10),
      'totalPrice': totalAmount,
      'contact': {
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'note': _specialRequestController.text,
      },
      'rooms': widget.bookingRooms.map((item) => {
        'roomId': item['room'].id, // Đây thực tế là roomTypeId
        'quantity': item['quantity'],
        'price': item['room'].price,
        'room': item['room'].toJson(), // Thêm thông tin đầy đủ của room
      }).toList(),
      'numberOfGuests': widget.numberOfGuests,
      'numberOfRooms': widget.numberOfRooms,
      // 'userId': null // Nếu có đăng nhập thì truyền userId, không thì null
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          bookingData: bookingData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysRemaining = widget.checkInDate.difference(now).inDays;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: CustomHeader()),

              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(color: Colors.blueGrey),
                  alignment: Alignment.center,
                  child: const Text(
                    'Nhập Thông Tin Đặt Phòng',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),

              // Step Progress dưới banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: _buildStepProgress(),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 1200 ? 200 : 20,
                    vertical: 40),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (constraints.maxWidth > 800)
                        SizedBox(
                          width: 320,
                          child: Card(
                            color: Colors.grey.shade200,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
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
                                      widget.hotel.thumbnailUrl ?? '',
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        height: 150,
                                        color: Colors.grey[300],
                                        child: const Center(
                                            child: Text('Không tải được ảnh')),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...widget.bookingRooms.map((item) {
                                    final room = item['room'] as RoomOption;
                                    final quantity = item['quantity'] as int;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('${room.type} x $quantity',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text('Giường: ${room.bedInfo}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600])),
                                          const SizedBox(height: 4),
                                          Wrap(spacing: 8, children: [
                                            _amenityTag(
                                                Icons.wifi, 'Wifi miễn phí'),
                                            _amenityTag(Icons.restaurant,
                                                'Bữa sáng miễn phí'),
                                            if (room.freeCancellation)
                                              _amenityTag(Icons.check_circle,
                                                  'Hủy miễn phí'),
                                            if (room.payLater)
                                              _amenityTag(Icons.payment,
                                                  'Thanh toán sau'),
                                          ]),
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
                                  Text('Nhận phòng: ${DateFormat('dd/MM/yyyy').format(widget.checkInDate)}',
                                      style: TextStyle(fontSize: 16)),
                                  Text('Trả phòng: ${DateFormat('dd/MM/yyyy').format(widget.checkOutDate)}',
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Text('Tóm Tắt Giá',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[800])),
                                  const SizedBox(height: 8),
                                  _buildSummaryItem('Tổng tiền',
                                      '${_calculateTotalPrice().toStringAsFixed(0)} VND',
                                      isBold: true),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 3,
                        child: Card(
                          color: Colors.grey.shade200,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Chi Tiết Về Bạn',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[800])),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                      _fullNameController,
                                      'Họ và Tên',
                                      (v) => (v?.isEmpty ?? true)
                                          ? 'Vui lòng nhập họ và tên'
                                          : null),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                      _emailController,
                                      'Email',
                                      (v) => (v?.isEmpty ?? true)
                                          ? 'Vui lòng nhập email'
                                          : !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                                  .hasMatch(v!)
                                              ? 'Vui lòng nhập email hợp lệ'
                                              : null),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                      _phoneController,
                                      'Số Điện Thoại',
                                      (v) => (v?.isEmpty ?? true)
                                          ? 'Vui lòng nhập số điện thoại'
                                          : null),
                                  const SizedBox(height: 24),
                                  Text('Yêu Cầu Đặc Biệt',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[800])),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _specialRequestController,
                                    decoration: InputDecoration(
                                      labelText:
                                          'Yêu cầu đặc biệt (không bắt buộc)',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    maxLines: 4,
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed:
                                          isLoading ? null : _completeBooking,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue[700],
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        elevation: 4,
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2))
                                          : const Text('Đi Tiếp Để Hoàn Tất',
                                              style: TextStyle(fontSize: 16)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
        _buildStepCircle(3, 'Hoàn tất đặt phòng', false),
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

  Widget _buildTextField(TextEditingController controller, String label,
      String? Function(String?) validator) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
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

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialRequestController.dispose();
    super.dispose();
  }
}
