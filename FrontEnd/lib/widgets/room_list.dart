import 'package:flutter/material.dart';
import '../models/room.dart';
import '../utils/url_helper.dart';

class RoomListWidget extends StatefulWidget {
  final List<Room> rooms;
  final bool isLoading;
  final String? error;
  final void Function()? onRetry;
  final void Function(RoomType roomType, int quantity)? onAddToCart;

  const RoomListWidget({
    Key? key,
    required this.rooms,
    required this.isLoading,
    required this.error,
    this.onRetry,
    this.onAddToCart,
  }) : super(key: key);

  @override
  State<RoomListWidget> createState() => _RoomListWidgetState();
}

class _RoomListWidgetState extends State<RoomListWidget> {
  // Quản lý số lượng đã chọn cho từng roomType.id
  Map<int, int> selectedQuantities = {};

  void _showRoomDetailPopup(RoomType roomType, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: 800,
            height: 700,
            child: Column(
              children: [
                SizedBox(
                  height: 280,
                  child: roomType.roomImage != null
                      ? Image.network(
                          UrlHelper.normalizeImageUrl(roomType.roomImage!),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roomType.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      
                      Text('Giường: ${roomType.doubleBed ?? 1} giường đôi'),
                      Text('Số khách tối đa: ${roomType.maxGuests} người'),
                      if (roomType.area != null)
                        Text('Diện tích: ${roomType.area}m²'),
                      const SizedBox(height: 12),
                      if (roomType.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            roomType.description,
                            style: const TextStyle(fontSize: 15, color: Colors.black87, fontStyle: FontStyle.italic),
                          ),
                        ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
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
                              SnackBar(content: Text('Đã đặt phòng ${roomType.name} thành công!')),
                            );
                          },
                          child: const Text('Đặt ngay', style: TextStyle(fontSize: 16)),
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

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (widget.error != null) {
      return Center(
        child: Column(
          children: [
            Text('Lỗi:  [38;5;9m${widget.error} [0m'),
            if (widget.onRetry != null)
              ElevatedButton(
                onPressed: widget.onRetry,
                child: const Text('Thử lại'),
              ),
          ],
        ),
      );
    } else if (widget.rooms.isEmpty) {
      return const Center(
        child: Text('Không có phòng nào cho khách sạn này'),
      );
    }
    // Group rooms by roomType.id, chỉ lấy 1 room đại diện cho mỗi loại phòng
    final Map<int, Room> uniqueRoomTypes = {};
    for (var room in widget.rooms) {
      final roomType = room.roomType;
      if (roomType != null && !uniqueRoomTypes.containsKey(roomType.id)) {
        uniqueRoomTypes[roomType.id] = room;
      }
    }
    final List<Room> displayRooms = uniqueRoomTypes.values.toList();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: displayRooms.asMap().entries.map((entry) {
          final index = entry.key;
          final room = entry.value;
          final roomType = room.roomType;
          if (roomType == null) return const SizedBox.shrink();
          final int selectedQuantity = selectedQuantities[roomType.id] ?? 0;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: roomType.roomImage != null
                          ? Image.network(
                              UrlHelper.normalizeImageUrl(roomType.roomImage!),
                              width: 200,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'images/room${(index % 6) + 1}.jpg',
                                  width: 200,
                                  height: 120,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'images/room${(index % 6) + 1}.jpg',
                              width: 200,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roomType.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          GestureDetector(
                            onTap: () => _showRoomDetailPopup(roomType, index),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                'Xem chi tiết',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none, // Không gạch chân
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Giường: ${roomType.doubleBed ?? 1} giường đôi',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            'Số khách: ${roomType.maxGuests}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          if (roomType.area != null)
                            Text(
                              'Diện tích: ${roomType.area}m²',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              if (roomType.amenities.contains('Wi-Fi miễn phí'))
                                _amenityTag(Icons.wifi, 'Wifi miễn phí'),
                              if (roomType.amenities.contains('TV màn hình phẳng'))
                                _amenityTag(Icons.tv, 'TV màn hình phẳng'),
                              if (roomType.amenities.contains('Điều hòa'))
                                _amenityTag(Icons.ac_unit, 'Điều hòa'),
                              if (roomType.amenities.contains('Máy sấy tóc'))
                                _amenityTag(Icons.dry_cleaning, 'Máy sấy tóc'),
                              if (roomType.amenities.contains('Mini bar'))
                                _amenityTag(Icons.local_bar, 'Mini bar'),
                              if (roomType.amenities.contains('Bồn tắm'))
                                _amenityTag(Icons.hot_tub, 'Bồn tắm'),
                              if (roomType.amenities.contains('Ban công riêng'))
                                _amenityTag(Icons.balcony, 'Ban công riêng'),
                              if (roomType.amenities.contains('Dịch vụ phòng'))
                                _amenityTag(Icons.room_service, 'Dịch vụ phòng'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${roomType.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const Text(
                            'mỗi đêm, bao gồm thuế',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          if (roomType.isAvailable == true)
                            const Text(
                              'Còn phòng',
                              style: TextStyle(fontSize: 12, color: Colors.green),
                            )
                          else
                            const Text(
                              'Hết phòng',
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Column(
                        children: [
                          DropdownButton<int>(
                            value: selectedQuantity,
                            items: [for (int i = 0; i <= roomType.availableRooms; i++) DropdownMenuItem(value: i, child: Text(' $i phòng'))],
                            onChanged: (value) {
                              setState(() {
                                selectedQuantities[roomType.id] = value ?? 0;
                              });
                              if (widget.onAddToCart != null) {
                                widget.onAddToCart!(roomType, value ?? 0);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (index < displayRooms.length - 1)
                Divider(height: 1, color: Colors.grey.shade300),
            ],
          );
        }).toList(),
      ),
    );
  }
} 