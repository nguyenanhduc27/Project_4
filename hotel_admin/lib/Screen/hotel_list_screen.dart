import 'package:flutter/material.dart';
import '../../Services/hotel_service.dart';

class HotelListScreen extends StatefulWidget {
  const HotelListScreen({super.key});

  @override
  State<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  List<Map<String, dynamic>> hotels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    hotels = await HotelService.fetchHotels();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _showHotelDialog({Map<String, dynamic>? hotel}) async {
    final nameController = TextEditingController(text: hotel?['name'] ?? '');
    final addressController = TextEditingController(
      text: hotel?['address'] ?? '',
    );
    final cityController = TextEditingController(text: hotel?['city'] ?? '');
    final descController = TextEditingController(
      text: hotel?['description'] ?? '',
    );
    final ratingController = TextEditingController(
      text: hotel?['star_rating']?.toString() ?? '',
    );
    final latController = TextEditingController(
      text: hotel?['latitude']?.toString() ?? '',
    );
    final lngController = TextEditingController(
      text: hotel?['longitude']?.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Text(
          hotel == null ? 'Thêm khách sạn' : 'Cập nhật khách sạn',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, 'Tên', Icons.hotel),
              const SizedBox(height: 12),
              _buildTextField(addressController, 'Địa chỉ', Icons.location_on),
              const SizedBox(height: 12),
              _buildTextField(cityController, 'Thành phố', Icons.location_city),
              const SizedBox(height: 12),
              _buildTextField(
                descController,
                'Mô tả',
                Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                ratingController,
                'Sao',
                Icons.star,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                latController,
                'Latitude',
                Icons.map,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                lngController,
                'Longitude',
                Icons.map,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () async {
              final data = {
                "name": nameController.text,
                "address": addressController.text,
                "city": cityController.text,
                "description": descController.text,
                "star_rating": int.tryParse(ratingController.text) ?? 0,
                "latitude": double.tryParse(latController.text) ?? 0.0,
                "longitude": double.tryParse(lngController.text) ?? 0.0,
              };
              bool success;
              if (hotel == null) {
                success = await HotelService.createHotel(data);
              } else {
                success = await HotelService.updateHotel(hotel['id'], data);
              }
              if (success) {
                Navigator.pop(context);
                fetchData();
              }
            },
            child: Text(hotel == null ? 'Thêm' : 'Cập nhật'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Future<void> _confirmDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xoá khách sạn?',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        content: const Text('Bạn có chắc muốn xoá khách sạn này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huỷ', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm ?? false) {
      await HotelService.deleteHotel(id);
      fetchData();
    }
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          hotel['name'] ?? '',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          '${hotel['city'] ?? ''} - ⭐ ${hotel['star_rating'] ?? ''}\n'
          'Lat: ${hotel['latitude']}, Lng: ${hotel['longitude']}',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () => _showHotelDialog(hotel: hotel),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _confirmDelete(hotel['id']),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý khách sạn',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () => _showHotelDialog(),
      ),
      body: Container(
        color: Colors.grey[100],
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent),
              )
            : RefreshIndicator(
                color: Colors.blueAccent,
                onRefresh: fetchData,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: hotels.length,
                  itemBuilder: (context, index) =>
                      _buildHotelCard(hotels[index]),
                ),
              ),
      ),
    );
  }
}
