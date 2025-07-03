import 'package:flutter/material.dart';
import '../models/room.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_footer.dart';

class RoomSearchPage extends StatelessWidget {
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int roomCount;
  final int adults;
  final int children;

  const RoomSearchPage({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomCount,
    required this.adults,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu
    List<Room> allRooms = [
      Room(
        name: 'Luxury Suite',
        price: '\$90',
        bedInfo: '1 King Bed',
        guestInfo: '4 Guests',
        imagePath: 'images/room1.jpg',
      ),
      Room(
        name: 'Standard Deluxe',
        price: '\$75',
        bedInfo: '2 Single Beds',
        guestInfo: '6 Guests',
        imagePath: 'images/room2.jpg',
      ),
      Room(
        name: 'The Penthouse',
        price: '\$200',
        bedInfo: '2 King Beds',
        guestInfo: '6 Guests',
        imagePath: 'images/room3.jpg',
      ),
      Room(
        name: 'Grand Suite Room',
        price: '\$80',
        bedInfo: '1 King Bed',
        guestInfo: '4 Guests',
        imagePath: 'images/room4.jpg',
      ),
      Room(
        name: 'Junior Suite Room',
        price: '\$69',
        bedInfo: '1 Double Bed',
        guestInfo: '3 Guests',
        imagePath: 'images/room5.jpg',
      ),
    ];

    // Lọc phòng phù hợp với số lượng người
    List<Room> matchedRooms = allRooms.where((room) {
      final guestStr = room.guestInfo.split(' ').first;
      final maxGuest = int.tryParse(guestStr) ?? 0;
      return maxGuest >= (adults + children);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomHeader(),

            // Banner
            Container(
              height: 400,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/resort-title-bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Text(
                  'Find Your Perfect Room',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Nội dung tìm kiếm + kết quả
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sidebar tìm kiếm lại
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: SizedBox(
                          width: 280,
                          child: SearchBarWidget(),
                        ),
                      ),
                      const SizedBox(width: 60),

                      // Danh sách phòng
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Results for $roomCount Room(s), ${adults + children} Guest(s)',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...matchedRooms.map((room) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        room.imagePath,
                                        width: 250,
                                        height: 170,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 24),

                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            room.name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.bed, size: 18),
                                              const SizedBox(width: 4),
                                              Text(room.bedInfo),
                                              const SizedBox(width: 16),
                                              const Icon(Icons.people,
                                                  size: 18),
                                              const SizedBox(width: 4),
                                              Text(room.guestInfo),
                                              const SizedBox(width: 16),
                                              const Icon(Icons.square_foot,
                                                  size: 18),
                                              const SizedBox(width: 4),
                                              const Text('30 Sqm'),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Hotale Suites has been honored with the prestigious Five-Star Award by Forbes.',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: const [
                                              Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 18),
                                              Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 18),
                                              Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 18),
                                              Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 18),
                                              Icon(Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 18),
                                              SizedBox(width: 8),
                                              Text('1 Review'),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  children: [
                                                    const TextSpan(
                                                      text: 'From ',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    TextSpan(
                                                      text: room.price,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                      text: ' / night',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: const Text('BOOK NOW →'),
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
                          ],
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
}
