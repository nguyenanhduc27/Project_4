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
  Map<int, int> selectedQuantities = {};

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
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
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
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(right: 6, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blueAccent),
          const SizedBox(width: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.blueAccent),
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
            Text('Lỗi: ${widget.error}'),
            if (widget.onRetry != null)
              ElevatedButton(
                  onPressed: widget.onRetry, child: const Text('Thử lại')),
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
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: roomType.roomImage != null
                          ? Image.network(
                              UrlHelper.normalizeImageUrl(roomType.roomImage!),
                              width: 180,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'images/room${(index % 6) + 1}.jpg',
                                  width: 180,
                                  height: 100,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'images/room${(index % 6) + 1}.jpg',
                              width: 180,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roomType.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () => _showRoomDetailPopup(roomType, index),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Xem chi tiết',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('Giường: ${roomType.doubleBed ?? 1} giường đôi'),
                          Text('Số khách tối đa: ${roomType.maxGuests} người'),
                          if (roomType.area != null)
                            Text('Diện tích: ${roomType.area}m²'),
                          SizedBox(
                            height: 40,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 6,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${roomType.price.toStringAsFixed(0)} /đêm (gồm thuế)',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Còn lại: ${roomType.availableRooms} phòng',
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: selectedQuantity > 0
                                    ? () {
                                        setState(() {
                                          selectedQuantities[roomType.id] =
                                              selectedQuantity - 1;
                                        });
                                        if (widget.onAddToCart != null) {
                                          widget.onAddToCart!(
                                              roomType, selectedQuantity - 1);
                                        }
                                      }
                                    : null,
                              ),
                              Text('$selectedQuantity',
                                  style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: selectedQuantity <
                                        (roomType.availableRooms)
                                    ? () {
                                        setState(() {
                                          selectedQuantities[roomType.id] =
                                              selectedQuantity + 1;
                                        });
                                        if (widget.onAddToCart != null) {
                                          widget.onAddToCart!(
                                              roomType, selectedQuantity + 1);
                                        }
                                      }
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              // ElevatedButton(
                              //   onPressed: selectedQuantity > 0
                              //       ? () {
                              //           ScaffoldMessenger.of(context)
                              //               .showSnackBar(
                              //             SnackBar(
                              //                 content: Text(
                              //                     'Đã thêm ${roomType.name} x $selectedQuantity vào giỏ!')),
                              //           );
                              //         }
                              //       : null,
                              //   child: const Text('Chọn'),
                              // ),
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
