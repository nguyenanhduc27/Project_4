// hotel_detail_page

import 'package:flutter/material.dart';
import '../models/room.dart';
import '../models/HotelMarker.dart';
import '../models/RoomOption.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import '../widgets/booking_dropdown_form.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RoomDetailPage extends StatefulWidget {
  final Room room;

  const RoomDetailPage({super.key, required this.room});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  final List<HotelMarker> hotelMarkers = [
    HotelMarker(
        name: 'Khách sạn 1',
        price: 2049750,
        latitude: 21.0278,
        longitude: 105.8342,
        image: 'images/room1.jpg'),
    HotelMarker(
        name: 'Khách sạn 2',
        price: 1405110,
        latitude: 21.0325,
        longitude: 105.8500,
        image: 'images/room2.jpg'),
    HotelMarker(
        name: 'Khách sạn 3',
        price: 1680500,
        latitude: 21.0200,
        longitude: 105.8400,
        image: 'images/room3.jpg'),
    HotelMarker(
        name: 'Khách sạn 4',
        price: 2087943,
        latitude: 21.0250,
        longitude: 105.8300,
        image: 'images/room4.jpg'),
    HotelMarker(
        name: 'Khách sạn 5',
        price: 1427184,
        latitude: 21.0350,
        longitude: 105.8450,
        image: 'images/room5.jpg'),
  ];

  final List<String> roomImages = [
    'images/room1.jpg',
    'images/room2.jpg',
    'images/room3.jpg',
    'images/room4.jpg',
    'images/room5.jpg',
    'images/room6.jpg',
  ];

  final List<RoomOption> roomOptions = [
    RoomOption(
      type: 'Phòng Standard',
      bedInfo: '1 giường đôi',
      guestCount: 2,
      price: 1200000,
      freeCancellation: true,
      payLater: true,
    ),
    RoomOption(
      type: 'Phòng Deluxe',
      bedInfo: '2 giường đơn',
      guestCount: 3,
      price: 1800000,
      freeCancellation: false,
      payLater: true,
    ),
    RoomOption(
      type: 'Phòng Suite',
      bedInfo: '1 giường king',
      guestCount: 4,
      price: 2500000,
      freeCancellation: true,
      payLater: false,
    ),
  ];

  HotelMarker? selectedHotel;

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
                          MarkerLayer(
                            markers: hotelMarkers
                                .map((hotel) => Marker(
                                      width: 85.0,
                                      height: 35.0,
                                      point: LatLng(
                                          hotel.latitude, hotel.longitude),
                                      child: SizedBox(
                                        width: 40.0,
                                        height: 40.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedHotel = hotel;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.location_on,
                                                    size: 14,
                                                    color: Colors.white),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${hotel.price ~/ 1000}k',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    if (selectedHotel != null)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  selectedHotel!.image ?? 'images/room1.jpg',
                                  height: 100,
                                  width: 280,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                selectedHotel!.name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Giá: VND ${selectedHotel!.price.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const Icon(Icons.star_half,
                                      color: Colors.amber, size: 16),
                                  const Icon(Icons.star_border,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 5),
                                  Text('4.5 (123 đánh giá)',
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text('Khoảng cách: 1.2 km',
                                  style: TextStyle(color: Colors.grey[600])),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Đặt phòng thành công!')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 40),
                                ),
                                child: const Text('Đặt ngay'),
                              ),
                            ],
                          ),
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
    int initialIndex = roomImages.indexOf(selectedImage);
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
                itemCount: roomImages.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Center(
                      child: Image.asset(
                        roomImages[index],
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

  Widget _infoItem(IconData icon, String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(color: Colors.grey)),
          ],
        )
      ],
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
                                    onTap: () => _openImageGallery(
                                        widget.room.imagePath),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        widget.room.imagePath,
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
                                          Expanded(
                                              child: _smallImage(
                                                  'images/room2.jpg')),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: _smallImage(
                                                  'images/room3.jpg')),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: _smallImage(
                                                  'images/room4.jpg')),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: _smallImage(
                                                  'images/room5.jpg')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Text(widget.room.name,
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: _showMapPopup,
                              child: Row(
                                children: const [
                                  Icon(Icons.location_on,
                                      color: Colors.blueAccent),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Tòa nhà APTECH, 285 P. Đội Cấn, Liễu Giai, Ba Đình, Hà Nội 100000',
                                      style:
                                          TextStyle(color: Colors.blueAccent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 40,
                              runSpacing: 20,
                              children: [
                                _infoItem(
                                    Icons.bed, 'Bed', widget.room.bedInfo),
                                _infoItem(Icons.people, 'Max Guest',
                                    widget.room.guestInfo),
                                _infoItem(
                                    Icons.square_foot, 'Room Space', '38 sqm.'),
                                _infoItem(
                                    Icons.landscape, 'Room View', 'City View'),
                              ],
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Far far away, behind the word mountains...',
                              style: TextStyle(fontSize: 16, height: 1.6),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'The Big Oxmox advised her not to do so...',
                              style: TextStyle(fontSize: 16, height: 1.6),
                            ),
                            const SizedBox(height: 40),
                            const Divider(),
                            const Text('Room Amenities',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                _amenityItem(Icons.tv, 'TV'),
                                _amenityItem(Icons.wifi, 'Free Wifi'),
                                _amenityItem(Icons.security, 'Safe'),
                                _amenityItem(Icons.smoke_free, 'Non Smoking'),
                                _amenityItem(Icons.ac_unit, 'Air Conditioning'),
                                _amenityItem(Icons.blur_on, 'Heater'),
                                _amenityItem(Icons.phone, 'Phone'),
                                _amenityItem(Icons.bathroom, 'Hair Dryer'),
                              ],
                            ),
                            const SizedBox(height: 40),
                            const Divider(),
                            const Text('Hotel Rules',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            _ruleItem('Smoking not allowed'),
                            _ruleItem('Pets not allowed'),
                            _ruleItem(
                                'Swimming pool closed from 8.00pm - 6.00am'),
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: roomOptions.asMap().entries.map((entry) {
                            final index = entry.key;
                            final option = entry.value;
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'images/room${index + 1}.jpg',
                                          width: 200,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              option.type,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Giường: ${option.bedInfo}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              'Số khách: ${option.guestCount}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 8,
                                              children: [
                                                _amenityTag(Icons.wifi,
                                                    'Wifi miễn phí'),
                                                _amenityTag(Icons.restaurant,
                                                    'Bữa sáng miễn phí'),
                                                if (option.freeCancellation)
                                                  _amenityTag(
                                                      Icons.check_circle,
                                                      'Hủy miễn phí'),
                                                if (option.payLater)
                                                  _amenityTag(Icons.payment,
                                                      'Thanh toán sau'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${option.price.toStringAsFixed(0)} VND',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            const Text(
                                              'mỗi đêm, bao gồm thuế',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 8),
                                            if (option.freeCancellation)
                                              const Text(
                                                'Hủy miễn phí trước 24h',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.green),
                                              ),
                                            if (option.payLater)
                                              const Text(
                                                'Không cần thanh toán ngay',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.green),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Column(
                                          children: [
                                            DropdownButton<int>(
                                              value: 1,
                                              items:
                                                  [1, 2, 3, 4, 5].map((value) {
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text('$value phòng'),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Đã chọn $value phòng ${option.type}'),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 8),
                                            ElevatedButton(
                                              onPressed: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Đặt phòng ${option.type} thành công!'),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Đặt Ngay'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (index < roomOptions.length - 1)
                                  Divider(
                                      height: 1, color: Colors.grey.shade300),
                              ],
                            );
                          }).toList(),
                        ),
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
