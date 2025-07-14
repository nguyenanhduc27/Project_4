import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import 'hotel_detail_page.dart';
import '../services/hotel_service.dart';

// Đổi từ StatelessWidget sang StatefulWidget
class HotelSearchPage extends StatefulWidget {
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int roomCount;
  final int adults;
  final int children;

  const HotelSearchPage({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomCount,
    required this.adults,
    required this.children,
  });

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  final HotelService _hotelService = HotelService();
  List<Hotel> allHotels = [];
  List<Hotel> filteredHotels = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final hotels = await _hotelService.fetchHotels();
      setState(() {
        allHotels = hotels;
        filteredHotels = List.from(hotels);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _onSearch(dynamic params) async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final hotels = await _hotelService.searchHotels(
        city: params['city'],
        checkIn: params['checkInDate'],
        checkOut: params['checkOutDate'],
        rooms: params['roomCount'],
      );
      setState(() {
        allHotels = hotels;
        filteredHotels = List.from(hotels);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Lỗi: ' + error!))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomHeader(),
                      // Banner
                      Container(
                        height: 300,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/resort-title-bg.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Tìm khách sạn',
                          style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Truyền callback onSearch
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SearchBarWidget(
                              onSearch: (params) {
                                // Thêm location vào params để lọc
                                params['location'] = params['location'] ?? '';
                                _onSearch(params);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Main Content: Filter + Hotel list
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Bộ lọc bên trái
                                SizedBox(
                                  width: 260,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Bộ lọc phổ biến',
                                        style: TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildFilterCheckbox('5 sao'),
                                      _buildFilterCheckbox('Có hồ bơi'),
                                      _buildFilterCheckbox('Bữa sáng miễn phí'),
                                      _buildFilterCheckbox('WiFi miễn phí'),
                                      _buildFilterCheckbox('Gần biển'),
                                      _buildFilterCheckbox('Spa'),
                                      _buildFilterCheckbox('Miễn phí huỷ'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30),
                                // Danh sách hotel
                                Expanded(
                                  child: Column(
                                    children: filteredHotels.isEmpty
                                        ? [
                                            const Padding(
                                              padding: EdgeInsets.all(32),
                                              child: Text(
                                                'Không tìm thấy khách sạn phù hợp.',
                                                style: TextStyle(fontSize: 18, color: Colors.grey),
                                              ),
                                            )
                                          ]
                                        : filteredHotels.map((hotel) {
                                            return Container(
                                              margin: const EdgeInsets.only(bottom: 30),
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: Colors.grey.shade300),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.05),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Image
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.asset(
                                                      hotel.thumbnailUrl,
                                                      width: 250,
                                                      height: 170,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 24),
                                                  // Info
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          hotel.name,
                                                          style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            const Icon(Icons.place, size: 18),
                                                            const SizedBox(width: 4),
                                                            Text(hotel.address),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Text(hotel.description),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                          children: List.generate(5, (index) {
                                                            return Icon(
                                                              index < hotel.starRating
                                                                  ? Icons.star
                                                                  : Icons.star_border,
                                                              color: Colors.amber,
                                                              size: 18,
                                                            );
                                                          }),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'Contact for price',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (_) => HotelDetailPage(hotel: hotel),
                                                                  ),
                                                                );
                                                              },
                                                              child: const Text('Xem chi tiết →'),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      CustomFooter(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildFilterCheckbox(String label) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (val) {}),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
