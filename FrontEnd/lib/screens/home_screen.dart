import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/hotel_card.dart';
import '../models/hotel.dart';
import 'all_hotel_pages.dart';
import 'hotel_search_page.dart';
import '../services/hotel_service.dart';

class HotelBookingPage extends StatefulWidget {
  const HotelBookingPage({super.key});

  @override
  State<HotelBookingPage> createState() => _HotelBookingPageState();
}

class _HotelBookingPageState extends State<HotelBookingPage> {
  final HotelService _hotelService = HotelService();
  List<Hotel> hotels = [];
  bool isLoading = true;
  String? error;

  // Đã xóa dữ liệu khách sạn mẫu. Nếu cần, hãy lấy dữ liệu từ API hoặc provider.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).checkLogin();
    });
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final result = await _hotelService.fetchHotels();
      setState(() {
        hotels = result;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Hero
                  Container(
                    height: 750,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/resort-title-bg.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Welcome to Hotel Booking!',
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.only(top: 70),
                            child: SearchBarWidget(
                              onSearch: (params) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HotelSearchPage(
                                      checkInDate: params['checkInDate'],
                                      checkOutDate: params['checkOutDate'],
                                      roomCount: params['roomCount'],
                                      adults: params['adults'],
                                      children: params['children'],
                                      city: params['city'], // truyền thêm city
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),
                  const Text(
                    'Our Hotels',
                    style: TextStyle(fontSize: 45, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      width: 600,
                      child: const Text(
                        'All our hotels are fabulous, they are destinations unto themselves. We have crossed the globe to bring you only the best.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF94959B),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Slider
                  Container(
                    width: double.infinity,
                    color: Colors.grey[100],
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 50),
                          width: 60,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : error != null
                                ? Center(child: Text('Lỗi: ' + error!))
                                : hotels.isEmpty
                                    ? const Center(child: Text('Không có khách sạn nào'))
                                    : _HotelSlider(hotels: hotels),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AllHotelsPage(hotels: hotels),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text(
                                        'VIEW ALL HOTELS',
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 2,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.chevron_right,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 140,
                                height: 1,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: CustomFooter(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HotelSlider
class _HotelSlider extends StatefulWidget {
  final List<Hotel> hotels;
  const _HotelSlider({required this.hotels});

  @override
  State<_HotelSlider> createState() => _HotelSliderState();
}

class _HotelSliderState extends State<_HotelSlider> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  Timer? _timer;

  double cardWidth = 300;
  final double spacing = 20;
  final double cardHeight = 500;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      setState(() {
        cardWidth = (screenWidth - spacing * 11) / 3;
      });
    });
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_currentIndex < widget.hotels.length - 3) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _scrollToIndex(_currentIndex);
    });
  }

  void _scrollToIndex(int index) {
    final position = index * (cardWidth + spacing);
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    if (_currentIndex < widget.hotels.length - 3) {
      setState(() {
        _currentIndex++;
      });
      _scrollToIndex(_currentIndex);
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _scrollToIndex(_currentIndex);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 36),
          onPressed: _prev,
        ),
        Expanded(
          child: SizedBox(
            height: cardHeight,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.hotels.length,
              itemBuilder: (context, index) {
                return Container(
                  width: cardWidth,
                  margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                  child: HotelCard(hotel: widget.hotels[index], checkInDate: DateTime.now(), checkOutDate: DateTime.now().add(Duration(days: 1))),
                );
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, size: 36),
          onPressed: _next,
        ),
      ],
    );
  }
}
