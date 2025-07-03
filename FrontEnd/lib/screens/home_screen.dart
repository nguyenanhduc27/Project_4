import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/room_card.dart';
import '../models/room.dart';
import 'all_room_pages.dart';
import 'room_search_page.dart';

class HotelBookingPage extends StatelessWidget {
  const HotelBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Room> rooms = [
      Room(
        name: 'Luxury Suite',
        imagePath: 'images/room1.jpg',
        bedInfo: '1 King Bed',
        guestInfo: '4 Guests',
        price: '\$90',
      ),
      Room(
        name: 'Standard Deluxe',
        imagePath: 'images/room2.jpg',
        bedInfo: '2 Single Beds',
        guestInfo: '6 Guests',
        price: '\$75',
      ),
      Room(
        name: 'The Penthouse',
        imagePath: 'images/room3.jpg',
        bedInfo: '2 King Beds',
        guestInfo: '6 Guests',
        price: '\$200',
        oldPrice: '\$250',
      ),
      Room(
        name: 'Cozy Queen Room',
        imagePath: 'images/room4.jpg',
        bedInfo: '1 Queen Bed',
        guestInfo: '2 Guests',
        price: '\$60',
      ),
      Room(
        name: 'Family Room',
        imagePath: 'images/room5.jpg',
        bedInfo: '2 Queen Beds',
        guestInfo: '5 Guests',
        price: '\$120',
      ),
      Room(
        name: 'Economy Room',
        imagePath: 'images/room6.jpg',
        bedInfo: '1 Double Bed',
        guestInfo: '2 Guests',
        price: '\$50',
      ),
      Room(
        name: 'Romantic Getaway',
        imagePath: 'images/room7.jpg',
        bedInfo: '1 Queen Bed',
        guestInfo: '2 Guests',
        price: '\$130',
      ),
    ];

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
                  // Hero section
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
                                    builder: (_) => RoomSearchPage(
                                      checkInDate: params['checkInDate'],
                                      checkOutDate: params['checkOutDate'],
                                      roomCount: params['roomCount'],
                                      adults: params['adults'],
                                      children: params['children'],
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
                    'Our Rooms',
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

                  // Slider Section
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
                        _RoomSlider(rooms: rooms),
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
                                            AllRoomsPage(rooms: rooms),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Text(
                                        'VIEW ALL ROOMS',
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

// =============================
// RoomSlider: scroll từng item, hiển thị 3 card
// =============================

class _RoomSlider extends StatefulWidget {
  final List<Room> rooms;
  const _RoomSlider({required this.rooms});

  @override
  State<_RoomSlider> createState() => _RoomSliderState();
}

class _RoomSliderState extends State<_RoomSlider> {
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
      if (_currentIndex < widget.rooms.length - 3) {
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
    if (_currentIndex < widget.rooms.length - 3) {
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
              itemCount: widget.rooms.length,
              itemBuilder: (context, index) {
                return Container(
                  width: cardWidth,
                  margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                  child: RoomCard(room: widget.rooms[index]),
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
