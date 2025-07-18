import 'package:flutter/material.dart';
import '../models/HotelMarker.dart';
import '../models/RoomOption.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import '../widgets/booking_dropdown_form.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/hotel.dart';
import '../models/room.dart';
import '../utils/url_helper.dart';
import '../services/hotel_service.dart';
import '../widgets/room_list.dart';
import 'package:intl/intl.dart';
import 'booking_input_page.dart';
import 'payment_page.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';

class HotelDetailPage extends StatefulWidget {
  final Hotel hotel;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  // XÓA: final List<Hotel> allHotels;

  const HotelDetailPage({
    super.key,
    required this.hotel,
    required this.checkInDate,
    required this.checkOutDate,
    // XÓA: required this.allHotels,
  });
  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  final HotelService _hotelService = HotelService();
  List<RoomType> roomTypes = [];
  bool isLoadingRooms = true;
  String? roomsError;

  List<Map<String, dynamic>> cart = [];

  HotelMarker? selectedHotel;

  void _addToCart(RoomType roomType, int quantity) {
    setState(() {
      final idx = cart.indexWhere((item) => item['roomType'].id == roomType.id);
      if (idx >= 0) {
        cart[idx]['quantity'] = quantity;
      } else {
        cart.add({'roomType': roomType, 'quantity': quantity});
      }
      cart.removeWhere((item) => item['quantity'] == 0);
    });
  }

  void _removeFromCart(int roomTypeId) {
    setState(() {
      cart.removeWhere((item) => item['roomType'].id == roomTypeId);
    });
  }

  void _showRoomDetailPopup(RoomType roomType, int index) {
    print('Amenities (popup): ${roomType.amenities}');
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: 340, // nhỏ lại
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: roomType.roomImage != null
                      ? Image.network(
                          roomType.roomImage!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'images/room1.jpg',
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'images/room1.jpg',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        roomType.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text('Giường: ${roomType.doubleBed ?? 1} giường đôi',
                          textAlign: TextAlign.center),
                      Text('Số khách tối đa: ${roomType.maxGuests} người',
                          textAlign: TextAlign.center),
                      if (roomType.area != null)
                        Text('Diện tích: ${roomType.area}m²',
                            textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children: roomType.amenities.map((amenity) {
                          IconData icon = Icons.check_circle;
                          switch (amenity) {
                            case 'Wi-Fi miễn phí':
                              icon = Icons.wifi;
                              break;
                            case 'TV màn hình phẳng':
                              icon = Icons.tv;
                              break;
                            case 'Điều hòa':
                              icon = Icons.ac_unit;
                              break;
                            case 'Máy sấy tóc':
                              icon = Icons.dry_cleaning;
                              break;
                            case 'Mini bar':
                              icon = Icons.local_bar;
                              break;
                            case 'Bồn tắm':
                              icon = Icons.hot_tub;
                              break;
                            case 'Ban công riêng':
                              icon = Icons.balcony;
                              break;
                            case 'Dịch vụ phòng':
                              icon = Icons.room_service;
                              break;
                          }
                          return _amenityTag(icon, amenity);
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '\$${roomType.price.toStringAsFixed(0)} /đêm (gồm thuế)',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Đã đặt phòng ${roomType.name} thành công!')),
                            );
                          },
                          child: const Text('Đặt ngay',
                              style: TextStyle(fontSize: 16)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMapPopup() {
    final double lat = widget.hotel.latitude ?? 21.0278;
    final double lng = widget.hotel.longitude ?? 105.8342;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FutureBuilder<List<Hotel>>(
          future: _hotelService.fetchHotels(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Lỗi'),
                content: Text(
                    'Không thể tải danh sách khách sạn: \n${snapshot.error}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đóng'),
                  ),
                ],
              );
            }
            final allHotels = snapshot.data ?? [];
            bool showHotelInfo = false;
            int selectedHotelId = widget.hotel.id;
            // Animation state
            ValueNotifier<bool> animateCircle = ValueNotifier(false);
            Timer? timer;
            void startAnimation() {
              timer?.cancel();
              timer = Timer.periodic(const Duration(seconds: 1), (_) {
                animateCircle.value = !animateCircle.value;
              });
            }

            void stopAnimation() {
              timer?.cancel();
              animateCircle.value = false;
            }

            return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  insetPadding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.9,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(lat, lng),
                              initialZoom: 13.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                                userAgentPackageName:
                                    'com.example.hotel_booking_app',
                              ),
                              MarkerLayer(
                                markers: allHotels
                                    .where((hotel) =>
                                        hotel.latitude != null &&
                                        hotel.longitude != null)
                                    .map((hotel) {
                                  bool isSelected = hotel.id == selectedHotelId;
                                  if (isSelected)
                                    startAnimation();
                                  else
                                    stopAnimation();
                                  return Marker(
                                    point: LatLng(hotel.latitude ?? 0,
                                        hotel.longitude ?? 0),
                                    width: 60,
                                    height: 60,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedHotelId = hotel.id;
                                          showHotelInfo = true;
                                        });
                                      },
                                      child: ValueListenableBuilder<bool>(
                                        valueListenable: animateCircle,
                                        builder: (context, animate, _) {
                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              if (isSelected && animate)
                                                Container(
                                                  width: 48,
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue
                                                        .withOpacity(0.3),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? Colors.blue
                                                          .withOpacity(0.2)
                                                      : Colors.grey
                                                          .withOpacity(0.15),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Icon(
                                                Icons.location_on,
                                                color: isSelected
                                                    ? Colors.red
                                                    : Colors.blue,
                                                size: isSelected ? 40 : 32,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        // Popup info khách sạn bên trái
                        if (showHotelInfo)
                          Positioned(
                            left: 20,
                            top: 40,
                            child: Material(
                              elevation: 8,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 320,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _buildHotelInfo(
                                  allHotels.firstWhere(
                                      (h) => h.id == selectedHotelId),
                                  () => setState(() => showHotelInfo = false),
                                ),
                              ),
                            ),
                          ),
                        // Nút đóng popup bản đồ
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.grey, size: 24),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _openImageGallery(String selectedImage) {
    int initialIndex = widget.hotel.imageUrls.indexOf(selectedImage);
    if (initialIndex == -1) initialIndex = 0;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: widget.hotel.imageUrls.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Center(
                      child: Image.network(
                        widget.hotel.imageUrls[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _smallImage(String path) {
    return GestureDetector(
      onTap: () => _openImageGallery(path),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          path,
          height: 146,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  static Widget _amenityItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
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
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blueAccent),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.blueAccent)),
        ],
      ),
    );
  }

  static Widget _ruleItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6),
          const SizedBox(width: 10),
          Flexible(child: Text(text)),
        ],
      ),
    );
  }

  Widget _hotelAmenityItem(IconData icon, String label) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRoomTypes();
  }

  Future<void> _fetchRoomTypes() async {
    setState(() {
      isLoadingRooms = true;
      roomsError = null;
    });
    try {
      final checkIn = DateFormat('yyyy-MM-dd').format(widget.checkInDate);
      final checkOut = DateFormat('yyyy-MM-dd').format(widget.checkOutDate);
      final result = await _hotelService.fetchRoomTypesByHotelId(
        widget.hotel.id,
        checkIn: checkIn,
        checkOut: checkOut,
      );
      setState(() {
        roomTypes = result;
        isLoadingRooms = false;
      });
    } catch (e) {
      setState(() {
        roomsError = e.toString();
        isLoadingRooms = false;
      });
    }
  }

  int _calculateNights() {
    return widget.checkOutDate.difference(widget.checkInDate).inDays;
  }

  Widget _buildHotelInfo(Hotel hotel, VoidCallback onClose) {
    return SizedBox(
      width: 260,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: hotel.imageUrls.isNotEmpty
                ? Image.network(
                    hotel.imageUrls[0],
                    height: 120,
                    width: 260,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'images/resort-title-bg.jpg',
                    height: 120,
                    width: 260,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            hotel.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < hotel.starRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            '${hotel.address}, ${hotel.city}',
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(fontSize: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup
                if (hotel.id != widget.hotel.id) {
                  // Nếu chọn khách sạn khác, chuyển sang trang chi tiết khách sạn đó
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HotelDetailPage(
                        hotel: hotel,
                        checkInDate: widget.checkInDate,
                        checkOutDate: widget.checkOutDate,
                      ),
                    ),
                  );
                } else {
                  // Nếu vẫn là khách sạn hiện tại, chỉ scroll xuống list room
                  _scrollToRoomList();
                }
              },
              child: const Text('Xem phòng trống'),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }

  // Thêm hàm scroll đến danh sách phòng
  final GlobalKey _roomListKey = GlobalKey();

  void _scrollToRoomList() {
    final context = _roomListKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomTypesToShow =
        roomTypes.where((rt) => (rt.availableRooms) > 0).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: CustomHeader()),
              SliverToBoxAdapter(
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/resort-title-bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Hotel Details',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 200, vertical: 40),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () => _openImageGallery(
                                        widget.hotel.imageUrls.isNotEmpty
                                            ? widget.hotel.imageUrls[0]
                                            : ''),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: widget.hotel.imageUrls.isNotEmpty
                                          ? Image.network(
                                              widget.hotel.imageUrls[0],
                                              height: 300,
                                              fit: BoxFit.cover)
                                          : Image.asset(
                                              'images/resort-title-bg.jpg',
                                              height: 300,
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          for (int i = 1;
                                              i <
                                                  (widget.hotel.imageUrls
                                                              .length >
                                                          3
                                                      ? 3
                                                      : widget.hotel.imageUrls
                                                          .length);
                                              i++)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: i == 1 ? 0 : 5),
                                              child: GestureDetector(
                                                onTap: () => _openImageGallery(
                                                    widget.hotel.imageUrls[i]),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                      widget.hotel.imageUrls[i],
                                                      height: 146,
                                                      width: 146,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                          if (widget.hotel.imageUrls.length < 3)
                                            for (int i = widget
                                                    .hotel.imageUrls.length;
                                                i < 3;
                                                i++)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: i == 1 ? 0 : 5),
                                                child: SizedBox(
                                                    width: 146, height: 146),
                                              ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          for (int i = 3;
                                              i <
                                                  (widget.hotel.imageUrls
                                                              .length >
                                                          5
                                                      ? 5
                                                      : widget.hotel.imageUrls
                                                          .length);
                                              i++)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: i == 3 ? 0 : 5),
                                              child: GestureDetector(
                                                onTap: () => _openImageGallery(
                                                    widget.hotel.imageUrls[i]),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                      widget.hotel.imageUrls[i],
                                                      height: 146,
                                                      width: 146,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                            ),
                                          if (widget.hotel.imageUrls.length < 5)
                                            for (int i = widget
                                                    .hotel.imageUrls.length;
                                                i < 5;
                                                i++)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: i == 3 ? 0 : 5),
                                                child: SizedBox(
                                                    width: 146, height: 146),
                                              ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Text(widget.hotel.name,
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            // Địa chỉ khách sạn (có cả thành phố), có thể bấm vào để mở map
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.blueAccent),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${widget.hotel.address}, ${widget.hotel.city} ',
                                        ),
                                        TextSpan(
                                          text: '– Hiển thị bản đồ',
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = _showMapPopup,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Text(widget.hotel.description,
                                style: TextStyle(fontSize: 16, height: 1.6)),
                            const SizedBox(height: 20),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < widget.hotel.starRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 22,
                                );
                              }),
                            ),
                            const SizedBox(height: 40),
                            const Divider(),
                            const Text('Hotel Amenities',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children:
                                  (widget.hotel.amenities ?? []).map((amenity) {
                                IconData icon = Icons.check_circle;
                                switch (amenity) {
                                  case 'Wi-Fi miễn phí':
                                  case 'WiFi miễn phí':
                                    icon = Icons.wifi;
                                    break;
                                  case 'TV màn hình phẳng':
                                    icon = Icons.tv;
                                    break;
                                  case 'Điều hòa':
                                  case 'Điều hòa không khí':
                                    icon = Icons.ac_unit;
                                    break;
                                  case 'Máy sấy tóc':
                                    icon = Icons.dry_cleaning;
                                    break;
                                  case 'Mini bar':
                                    icon = Icons.local_bar;
                                    break;
                                  case 'Bồn tắm':
                                    icon = Icons.hot_tub;
                                    break;
                                  case 'Ban công riêng':
                                  case 'Ban công':
                                    icon = Icons.balcony;
                                    break;
                                  case 'Dịch vụ phòng':
                                    icon = Icons.room_service;
                                    break;
                                  case 'Hồ bơi':
                                    icon = Icons.pool;
                                    break;
                                  case 'Bãi đỗ xe miễn phí':
                                  case 'Bãi đỗ xe trong khuôn viên':
                                  case 'Chỗ đậu xe (trong khuôn viên)':
                                    icon = Icons.local_parking;
                                    break;
                                  case 'Căn hộ':
                                    icon = Icons.apartment;
                                    break;
                                  case 'Nhà hàng':
                                    icon = Icons.restaurant;
                                    break;
                                  case 'Phòng gia đình':
                                    icon = Icons.family_restroom;
                                    break;
                                  case 'Xe đưa đón sân bay':
                                    icon = Icons.airport_shuttle;
                                    break;
                                  case 'Phòng không hút thuốc':
                                    icon = Icons.smoke_free;
                                    break;
                                  case 'Sân thượng / hiên':
                                  case 'Sân thượng':
                                    icon = Icons.deck;
                                    break;
                                  case 'Sân vườn':
                                    icon = Icons.park;
                                    break;
                                  case 'Thang máy':
                                    icon = Icons.elevator;
                                    break;
                                }
                                return _hotelAmenityItem(icon, amenity);
                              }).toList(),
                            ),
                            const SizedBox(height: 40),
                            const Divider(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 200, vertical: 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tùy Chọn Phòng',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            RoomListWidget(
                              key: _roomListKey,
                              rooms: roomTypesToShow,
                              isLoading: isLoadingRooms,
                              error: roomsError,
                              onRetry: _fetchRoomTypes,
                              onAddToCart: _addToCart,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      SizedBox(
                        width: 320,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phòng đã chọn',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            BookingCartWidget(
                              cart: cart,
                              onRemove: _removeFromCart,
                              hotel: widget.hotel,
                              checkInDate: widget.checkInDate,
                              checkOutDate: widget.checkOutDate,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 200, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customer Reviews',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      AssetImage('images/user.jpg'),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'User Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: const [
                                          Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          Icon(Icons.star_border,
                                              color: Colors.amber, size: 16),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Great stay! The room was clean and the staff was very helpful.',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
}

class BookingCartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final void Function(int roomTypeId) onRemove;
  final Hotel hotel;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const BookingCartWidget({
    super.key,
    required this.cart,
    required this.onRemove,
    required this.hotel,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Chưa chọn phòng nào'),
      );
    }
    final checkIn = checkInDate;
    final checkOut = checkOutDate;
    final int nights = checkOut.difference(checkIn).inDays;
    double total = 0;
    for (var item in cart) {
      total += (item['roomType'].price ?? 0) * (item['quantity'] ?? 0) * nights;
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Phòng đã chọn',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Text('Nhận phòng: ${DateFormat('dd/MM/yyyy').format(checkIn)}'),
          Text('Trả phòng: ${DateFormat('dd/MM/yyyy').format(checkOut)}'),
          Text('Tổng số phòng: ${cart.length}'),
          ...cart.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['roomType'].name,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text('Số lượng: ${item['quantity']}'),
                    Text(
                        'Giá: ${(item['roomType'].price).toStringAsFixed(0)} VND'),
                  ],
                ),
              )),
          const Divider(),
          Text('Tổng: ${total.toStringAsFixed(0)} VND',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                try {
                  int totalRooms = cart.fold(
                      0, (sum, item) => sum + ((item['quantity'] ?? 0) as int));
                  List<Map<String, dynamic>> bookingRooms = cart
                      .map((item) => {
                            'room': RoomOption(
                              id: item['roomType'].id,
                              type: item['roomType'].name,
                              bedInfo:
                                  '${item['roomType'].doubleBed ?? 1} giường đôi',
                              guestCount: item['roomType'].maxGuests ?? 1,
                              price: item['roomType'].price?.toDouble() ?? 0.0,
                              freeCancellation: false,
                              payLater: false,
                            ),
                            'quantity': item['quantity'],
                          })
                      .toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingInputPage(
                        hotel: hotel,
                        bookingRooms: bookingRooms,
                        checkInDate: checkInDate,
                        checkOutDate: checkOutDate,
                        numberOfGuests: 1,
                        numberOfRooms: totalRooms,
                      ),
                    ),
                  );
                } catch (e, stack) {
                  print('Lỗi khi chuyển trang: $e');
                  print(stack);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Có lỗi khi chuyển trang: $e')),
                  );
                }
              },
              child: const Text('Tiếp tục đặt phòng'),
            ),
          ),
        ],
      ),
    );
  }
}
