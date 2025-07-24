// lib/Screen/rooms/room_list_screen.dart
import 'package:flutter/material.dart';
import '../../Services/room_service.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  List<Map<String, dynamic>> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    final rooms = await RoomService.fetchRooms();
    setState(() {
      _rooms = rooms;
      _isLoading = false;
    });
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Card(
      child: ListTile(
        title: Text('Phòng số: ${room['room_number'] ?? 'N/A'}'),
        subtitle: Text(
          'Hotel ID: ${room['hotel_id']} | Type ID: ${room['room_type_id']}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              room['is_available'] == 1 ? Icons.check_circle : Icons.cancel,
              color: room['is_available'] == 1 ? Colors.green : Colors.red,
            ),
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
        title: const Text('Quản lý phòng'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Thêm form tạo phòng mới
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRooms,
              child: ListView.builder(
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  return _buildRoomCard(_rooms[index]);
                },
              ),
            ),
    );
  }
}
