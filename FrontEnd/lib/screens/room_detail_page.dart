import 'dart:async';
import 'package:flutter/material.dart';
import '../models/room.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';
import '../widgets/booking_dropdown_form.dart';
import '../widgets/room_card.dart';

class RoomDetailPage extends StatefulWidget {
  final Room room;

  const RoomDetailPage({super.key, required this.room});

  @override
  State<RoomDetailPage> createState() => _RoomDetailPageState();
}

class _RoomDetailPageState extends State<RoomDetailPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  double cardWidth = 300;
  final double spacing = 16;

  List<Room> get moreRooms => List.generate(
        6,
        (index) => Room(
          name: 'Room ${index + 1}',
          price: '\$${90 + index * 10}',
          bedInfo: '1 King Bed',
          guestInfo: '2 Guests',
          imagePath: 'images/room${(index % 6) + 1}.jpg',
        ),
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;
      setState(() {
        cardWidth = (screenWidth - spacing * 11) / 5;
      });
    });
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_currentIndex < moreRooms.length - 3) {
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

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
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
                    'Room Details',
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                widget.room.imagePath,
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.room.name,
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'From ${widget.room.price}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
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
                                _amenityItem(Icons.smoke_free, 'None Smoking'),
                                _amenityItem(Icons.ac_unit, 'Air Conditioning'),
                                _amenityItem(Icons.blur_on, 'Heater'),
                                _amenityItem(Icons.phone, 'Phone'),
                                _amenityItem(Icons.bathroom, 'Hair Dryer'),
                              ],
                            ),
                            const SizedBox(height: 40),
                            const Text('Hotel Amenities',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                _amenityItem(Icons.fitness_center, 'Gym'),
                                _amenityItem(Icons.local_parking, 'Parking'),
                                _amenityItem(Icons.spa, 'Spa'),
                                _amenityItem(Icons.restaurant, 'Restaurant'),
                                _amenityItem(
                                    Icons.room_service, 'Room Service'),
                                _amenityItem(Icons.pool, 'Swimming Pool'),
                                _amenityItem(
                                    Icons.support_agent, '24 Hour Concierge'),
                                _amenityItem(Icons.local_laundry_service,
                                    'In-house Laundry'),
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
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Divider(),
                      const SizedBox(height: 30),
                      const Text('More Rooms',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: SizedBox(
                          height: 350,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: moreRooms.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: cardWidth,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: spacing / 2),
                                    child: RoomCard(room: moreRooms[index]),
                                  );
                                },
                              ),
                              Positioned(
                                left: 0,
                                child: _navButton(Icons.arrow_back_ios, () {
                                  setState(() {
                                    if (_currentIndex > 0) {
                                      _currentIndex--;
                                      _scrollToIndex(_currentIndex);
                                    }
                                  });
                                }),
                              ),
                              Positioned(
                                right: 0,
                                child: _navButton(Icons.arrow_forward_ios, () {
                                  setState(() {
                                    if (_currentIndex < moreRooms.length - 3) {
                                      _currentIndex++;
                                      _scrollToIndex(_currentIndex);
                                    }
                                  });
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 200, vertical: 30),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // căn trái
                    children: [
                      const Divider(thickness: 1, height: 1),
                      const SizedBox(height: 30),

                      // Tổng số review
                      Row(
                        children: const [
                          Text(
                            '1 Review',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.star, size: 18, color: Colors.black),
                          Icon(Icons.star, size: 18, color: Colors.black),
                          Icon(Icons.star, size: 18, color: Colors.black),
                          Icon(Icons.star, size: 18, color: Colors.black),
                          Icon(Icons.star, size: 18, color: Colors.black),
                        ],
                      ),

                      const SizedBox(height: 30),
                      const Divider(thickness: 1, height: 1),
                      const SizedBox(height: 20),

                      // Review chi tiết
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person,
                                size: 40, color: Colors.white),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('John Doe',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                SizedBox(height: 8),
                                Text(
                                  'The hotel is great, clean and worthy.\n'
                                  'Staffs are also good and welcome. I will go there again!',
                                  style: TextStyle(fontSize: 14, height: 1.5),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.black, size: 18),
                                    Icon(Icons.star,
                                        color: Colors.black, size: 18),
                                    Icon(Icons.star,
                                        color: Colors.black, size: 18),
                                    Icon(Icons.star,
                                        color: Colors.black, size: 18),
                                    Icon(Icons.star,
                                        color: Colors.black, size: 18),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text('Apr 15, 2022',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      const Divider(thickness: 1, height: 1),
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

  Widget _navButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white70,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}
