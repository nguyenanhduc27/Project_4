import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../screens/hotel_detail_page.dart'; // cần tạo trang này nếu chưa có
import '../utils/url_helper.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const HotelCard({super.key, required this.hotel, required this.checkInDate, required this.checkOutDate});

  @override
  Widget build(BuildContext context) {
    print('Hotel thumbnail:  [32m${UrlHelper.normalizeImageUrl(hotel.thumbnailUrl)} [0m');
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    UrlHelper.normalizeImageUrl(hotel.thumbnailUrl) ?? 'https://via.placeholder.com/300x225',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/default.jpg'),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: Colors.blue[900],
                    child: const Text(
                      'From \$100',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  hotel.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16),
                    const SizedBox(width: 5),
                    Text(hotel.address),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    hotel.starRating,
                    (index) =>
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HotelDetailPage(hotel: hotel, checkInDate: checkInDate, checkOutDate: checkOutDate, ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
