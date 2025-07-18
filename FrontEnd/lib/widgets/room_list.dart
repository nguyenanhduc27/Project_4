import 'package:flutter/material.dart';
import '../models/room.dart';
import '../utils/url_helper.dart';

class RoomListWidget extends StatefulWidget {
  final List<RoomType> rooms;
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
                            case 'Ban công':
                            case 'Ban công riêng':
                              icon = Icons.balcony;
                              break;
                            case 'Điều hòa':
                            case 'Điều hòa không khí':
                              icon = Icons.ac_unit;
                              break;
                            case 'Bếp':
                            case 'Bếp riêng':
                            case 'Bếp đầy đủ tiện nghi':
                              icon = Icons.kitchen;
                              break;
                            case 'Máy giặt':
                              icon = Icons.local_laundry_service;
                              break;
                            case '2 Phòng ngủ':
                            case '3 Phòng ngủ':
                            case 'Căn hộ nguyên căn':
                              icon = Icons.apartment;
                              break;
                            case 'WiFi miễn phí':
                            case 'Wi-Fi miễn phí':
                              icon = Icons.wifi;
                              break;
                            case 'Phòng không hút thuốc':
                              icon = Icons.smoke_free;
                              break;
                            case 'Thang máy':
                              icon = Icons.elevator;
                              break;
                            case 'Phòng gia đình':
                              icon = Icons.family_restroom;
                              break;
                            case 'Phòng ăn riêng':
                              icon = Icons.restaurant;
                              break;
                            case 'Bồn tắm':
                              icon = Icons.bathtub;
                              break;
                            case 'View thành phố':
                            case 'Nhìn ra thành phố':
                              icon = Icons.location_city;
                              break;
                            case 'Nhìn ra hồ':
                              icon = Icons.water;
                              break;
                            case 'Nhìn ra vườn':
                              icon = Icons.park;
                              break;
                            case 'Phòng tắm riêng':
                              icon = Icons.shower;
                              break;
                            case 'TV màn hình phẳng':
                              icon = Icons.tv;
                              break;
                            case 'Hệ thống cách âm':
                              icon = Icons.volume_off;
                              break;
                            case 'Dịch vụ phòng':
                              icon = Icons.room_service;
                              break;
                            case '106 m²':
                              icon = Icons.square_foot;
                              break;
                            default:
                              icon = Icons.check_circle;
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
    final List<RoomType> displayRoomTypes = widget.rooms;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: displayRoomTypes.asMap().entries.map((entry) {
          final index = entry.key;
          final roomType = entry.value;
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                roomType.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => _showRoomDetailPopup(roomType, index),
                                child: const Text('Xem chi tiết'),
                              ),
                            ],
                          ),
                          Text('Giường: ${roomType.doubleBed ?? 1} giường đôi'),
                          Text('Số khách tối đa: ${roomType.maxGuests} người'),
                          if (roomType.area != null)
                            Text('Diện tích: ${roomType.area}m²'),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: roomType.amenities.map((amenity) {
                              IconData icon = Icons.check_circle;
                              switch (amenity) {
                                case 'Ban công':
                                case 'Ban công riêng':
                                  icon = Icons.balcony;
                                  break;
                                case 'Điều hòa':
                                case 'Điều hòa không khí':
                                  icon = Icons.ac_unit;
                                  break;
                                case 'Bếp':
                                case 'Bếp riêng':
                                case 'Bếp đầy đủ tiện nghi':
                                  icon = Icons.kitchen;
                                  break;
                                case 'Máy giặt':
                                  icon = Icons.local_laundry_service;
                                  break;
                                case '2 Phòng ngủ':
                                case '3 Phòng ngủ':
                                case 'Căn hộ nguyên căn':
                                  icon = Icons.apartment;
                                  break;
                                case 'WiFi miễn phí':
                                case 'Wi-Fi miễn phí':
                                  icon = Icons.wifi;
                                  break;
                                case 'Phòng không hút thuốc':
                                  icon = Icons.smoke_free;
                                  break;
                                case 'Thang máy':
                                  icon = Icons.elevator;
                                  break;
                                case 'Phòng gia đình':
                                  icon = Icons.family_restroom;
                                  break;
                                case 'Phòng ăn riêng':
                                  icon = Icons.restaurant;
                                  break;
                                case 'Bồn tắm':
                                  icon = Icons.bathtub;
                                  break;
                                case 'View thành phố':
                                case 'Nhìn ra thành phố':
                                  icon = Icons.location_city;
                                  break;
                                case 'Nhìn ra hồ':
                                  icon = Icons.water;
                                  break;
                                case 'Nhìn ra vườn':
                                  icon = Icons.park;
                                  break;
                                case 'Phòng tắm riêng':
                                  icon = Icons.shower;
                                  break;
                                case 'TV màn hình phẳng':
                                  icon = Icons.tv;
                                  break;
                                case 'Hệ thống cách âm':
                                  icon = Icons.volume_off;
                                  break;
                                case 'Dịch vụ phòng':
                                  icon = Icons.room_service;
                                  break;
                                case '106 m²':
                                  icon = Icons.square_foot;
                                  break;
                                default:
                                  icon = Icons.check_circle;
                              }
                              return _amenityTag(icon, amenity);
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Còn lại: ${roomType.availableRooms} phòng',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${roomType.price.toStringAsFixed(0)} /đêm (gồm thuế)',
                            style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: selectedQuantity > 0
                                    ? () {
                                        setState(() {
                                          selectedQuantities[roomType.id] = selectedQuantity - 1;
                                        });
                                        if (widget.onAddToCart != null) {
                                          widget.onAddToCart!(roomType, selectedQuantity - 1);
                                        }
                                      }
                                    : null,
                              ),
                              Text('$selectedQuantity', style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: selectedQuantity < (roomType.availableRooms)
                                    ? () {
                                        setState(() {
                                          selectedQuantities[roomType.id] = selectedQuantity + 1;
                                        });
                                        if (widget.onAddToCart != null) {
                                          widget.onAddToCart!(roomType, selectedQuantity + 1);
                                        }
                                      }
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: selectedQuantity > 0
                                    ? () {
                                        // Có thể xử lý đặt phòng ở đây nếu muốn
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Đã thêm ${roomType.name} x $selectedQuantity vào giỏ!')),
                                        );
                                      }
                                    : null,
                                child: const Text('Chọn'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
} 