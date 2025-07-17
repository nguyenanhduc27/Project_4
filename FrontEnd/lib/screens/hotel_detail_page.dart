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

class HotelDetailPage extends StatefulWidget {
  final Hotel hotel;
  const HotelDetailPage({super.key, required this.hotel});
  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  final HotelService _hotelService = HotelService();
  List<Room> rooms = [];
  bool isLoadingRooms = true;
  String? roomsError;

  HotelMarker? selectedHotel;
  
  void _showRoomDetailPopup(RoomType roomType, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: 600,
            height: 600,
            child: Column(
              children: [
                // Slider ảnh phòng
                SizedBox(
                  height: 280,
                  child: roomType.roomImage != null
                      ? Image.network(
                          roomType.roomImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'images/room${(index % 6) + 1}.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'images/room${(index % 6) + 1}.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 16),
                // Thông tin phòng
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roomType.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Giường: ${roomType.doubleBed ?? 1} giường đôi'),
                      Text('Số khách tối đa: ${roomType.maxGuests} người'),
                      if (roomType.area != null)
                        Text('Diện tích: ${roomType.area}m²'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: roomType.amenities.map((amenity) {
                          IconData icon = Icons.check_circle; // default icon
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
                        ' \$${roomType.price.toStringAsFixed(0)} /đêm (gồm thuế)',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
    showDialog(
      context: context,
      builder: (context) {
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
                          initialCenter: LatLng(21.0278, 105.8342),
                          initialZoom: 17.0,
                          onTap: (_, __) {
                            setState(() {
                              selectedHotel = null;
                            });
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName:
                                'com.example.hotel_booking_app',
                          ),
                          // Map markers will be added here when we have real hotel data
                        ],
                      ),
                    ),
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
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
          ),
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
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    setState(() {
      isLoadingRooms = true;
      roomsError = null;
    });
    try {
      final now = DateTime.now();
      final checkIn = DateFormat('yyyy-MM-dd').format(now);
      final checkOut = DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 1)));
      final result = await _hotelService.fetchRoomsByHotelId(widget.hotel.id, checkIn: checkIn, checkOut: checkOut);
      setState(() {
        rooms = result;
        isLoadingRooms = false;
      });
    } catch (e) {
      setState(() {
        roomsError = e.toString();
        isLoadingRooms = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      color: Colors.white,
                    ),
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
                                    onTap: () => _openImageGallery(widget.hotel.imageUrls.isNotEmpty ? widget.hotel.imageUrls[0] : ''),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: widget.hotel.imageUrls.isNotEmpty
                                          ? Image.network(
                                              widget.hotel.imageUrls[0],
                                              height: 300,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'images/resort-title-bg.jpg',
                                              height: 300,
                                              fit: BoxFit.cover,
                                            ),
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
                                          for (int i = 1; i < (widget.hotel.imageUrls.length > 3 ? 3 : widget.hotel.imageUrls.length); i++)
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => _openImageGallery(widget.hotel.imageUrls[i]),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.network(
                                                    widget.hotel.imageUrls[i],
                                                    height: 146,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (widget.hotel.imageUrls.length < 3)
                                            for (int i = widget.hotel.imageUrls.length; i < 3; i++)
                                              Expanded(child: SizedBox()),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          for (int i = 3; i < (widget.hotel.imageUrls.length > 5 ? 5 : widget.hotel.imageUrls.length); i++)
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => _openImageGallery(widget.hotel.imageUrls[i]),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.network(
                                                    widget.hotel.imageUrls[i],
                                                    height: 146,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (widget.hotel.imageUrls.length < 5)
                                            for (int i = widget.hotel.imageUrls.length; i < 5; i++)
                                              Expanded(child: SizedBox()),
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
                            GestureDetector(
                              onTap: _showMapPopup,
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.blueAccent),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.hotel.city.isNotEmpty ? widget.hotel.city : widget.hotel.address,
                                      style:
                                          const TextStyle(color: Colors.blueAccent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(widget.hotel.description, style: TextStyle(fontSize: 16, height: 1.6)),
                            const SizedBox(height: 20),
                            Row(
  children: List.generate(5, (index) {
    return Icon(
      index < widget.hotel.starRating ? Icons.star : Icons.star_border,
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
                              children: (widget.hotel.amenities ?? []).map((amenity) {
                                IconData icon = Icons.check_circle; // default icon
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
                      const SizedBox(width: 320, child: BookingDropdownForm()),
                    ],
                  ),
                ),
              ),
              // Phần Tùy Chọn Phòng (đặt trước Customer Reviews)
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 200, vertical: 40),
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
                        rooms: rooms,
                        isLoading: isLoadingRooms,
                        error: roomsError,
                        onRetry: _fetchRooms,
                      ),
                    ],
                  ),
                ),
              ),
              // Phần Customer Reviews (đặt sau Tùy Chọn Phòng)
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
