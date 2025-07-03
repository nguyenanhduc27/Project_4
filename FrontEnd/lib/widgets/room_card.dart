import 'package:flutter/material.dart';
import '../models/room.dart';
import '../screens/room_detail_page.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // ✅ can giữa ngang
        children: [
          // ✅ Ảnh
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    room.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.blue[900],
                    child: room.oldPrice != null
                        ? RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'From ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: '${room.oldPrice!} ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                TextSpan(
                                  text: room.price,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            'From ${room.price}',
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Nội dung
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // ✅ can giữa nội dung bên trong
              children: [
                Text(
                  room.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // ✅ icon và text nằm giữa
                  children: [
                    const Icon(Icons.bed_outlined, size: 16),
                    const SizedBox(width: 5),
                    Text(room.bedInfo),
                    const SizedBox(width: 10),
                    const Icon(Icons.group_outlined, size: 16),
                    const SizedBox(width: 5),
                    Text(room.guestInfo),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoomDetailPage(room: room),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // ✅ chỉ chiếm kích thước cần thiết
                    children: const [
                      Text(
                        'BOOK NOW',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_right_alt),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
