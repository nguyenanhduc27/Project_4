// lib/Screen/hotel_images/hotel_image_list_screen.dart
import 'package:flutter/material.dart';
import '../../Services/hotel_image_service.dart';

class HotelImageListScreen extends StatefulWidget {
  const HotelImageListScreen({super.key});

  @override
  State<HotelImageListScreen> createState() => _HotelImageListScreenState();
}

class _HotelImageListScreenState extends State<HotelImageListScreen> {
  List<Map<String, dynamic>> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final data = await HotelImageService.fetchHotelImages();
    setState(() {
      _images = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteImage(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xoá ảnh?'),
        content: Text('Bạn có chắc muốn xoá ảnh này không?'),
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
    if (confirm ?? false) {
      await HotelImageService.deleteImage(id);
      _loadImages();
    }
  }

  Widget _buildImageCard(Map<String, dynamic> img) {
    return Card(
      child: ListTile(
        leading: Image.network(
          img['image_url'],
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
        ),
        title: Text('Hotel ID: ${img['hotel_id']}'),
        subtitle: Text(img['is_thumbnail'] == 1 ? 'Ảnh đại diện' : 'Ảnh phụ'),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _deleteImage(img['id']),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý ảnh khách sạn')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadImages,
              child: ListView.builder(
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return _buildImageCard(_images[index]);
                },
              ),
            ),
    );
  }
}
