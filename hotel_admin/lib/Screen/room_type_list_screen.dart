// lib/Screen/room_types/room_type_list_screen.dart
import 'package:flutter/material.dart';
import '../../Services/room_type_service.dart';

class RoomTypeListScreen extends StatefulWidget {
  const RoomTypeListScreen({super.key});

  @override
  State<RoomTypeListScreen> createState() => _RoomTypeListScreenState();
}

class _RoomTypeListScreenState extends State<RoomTypeListScreen> {
  List<Map<String, dynamic>> _roomTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoomTypes();
  }

  Future<void> _loadRoomTypes() async {
    final data = await RoomTypeService.fetchRoomTypes();
    setState(() {
      _roomTypes = data;
      _isLoading = false;
    });
  }

  Widget _buildRoomTypeCard(Map<String, dynamic> roomType) {
    return Card(
      child: ListTile(
        title: Text(roomType['name'] ?? 'Tên loại phòng'),
        subtitle: Text(
          '${roomType['description'] ?? ''}\nGiá: ${roomType['price']} VND - Tối đa ${roomType['max_guests']} khách',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý loại phòng'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Hiện form thêm loại phòng
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRoomTypes,
              child: ListView.builder(
                itemCount: _roomTypes.length,
                itemBuilder: (context, index) {
                  return _buildRoomTypeCard(_roomTypes[index]);
                },
              ),
            ),
    );
  }
}
