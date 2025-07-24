// lib/Screen/amenities/amenity_list_screen.dart
import 'package:flutter/material.dart';
import '../../Services/amenity_service.dart';

class AmenityListScreen extends StatefulWidget {
  const AmenityListScreen({super.key});

  @override
  State<AmenityListScreen> createState() => _AmenityListScreenState();
}

class _AmenityListScreenState extends State<AmenityListScreen> {
  List<Map<String, dynamic>> _amenities = [];
  bool _isLoading = true;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAmenities();
  }

  Future<void> _loadAmenities() async {
    final data = await AmenityService.fetchAmenities();
    setState(() {
      _amenities = data;
      _isLoading = false;
    });
  }

  Future<void> _addAmenity() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    final success = await AmenityService.addAmenity(name);
    if (success) {
      _controller.clear();
      _loadAmenities();
    }
  }

  Future<void> _deleteAmenity(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xoá tiện ích?'),
        content: Text('Bạn có chắc muốn xoá?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Huỷ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Xoá'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await AmenityService.deleteAmenity(id);
      _loadAmenities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý tiện ích')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Tên tiện ích mới',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addAmenity,
                  child: const Text('Thêm'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadAmenities,
                    child: ListView.builder(
                      itemCount: _amenities.length,
                      itemBuilder: (context, index) {
                        final a = _amenities[index];
                        return ListTile(
                          title: Text(a['name'] ?? 'Không tên'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteAmenity(a['id']),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
