import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../models/hotel_image.dart';    

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final List<HotelImage> hotelImages;

  const HotelCard({
    super.key,
    required this.hotel,
    required this.hotelImages,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy thumbnail hoặc ảnh đầu tiên
    HotelImage? thumbnail = hotelImages.firstWhere(
      (img) => img.isThumbnail,
      orElse: () => hotelImages.first, // hoặc một HotelImage mặc định khác
    );

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
          // Ảnh khách sạn
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: (thumbnail != null && thumbnail.imageUrl.isNotEmpty)
                  ? Image.network(
                      thumbnail.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.hotel, size: 48, color: Colors.grey))),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.hotel, size: 48, color: Colors.grey)),
                    ),
            ),
          ),
          // Nội dung
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Khach San Demo',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.blue[900]),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        hotel.address ?? '',
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 5),
                    Text(
                      hotel.starRating != null ? hotel.starRating.toString() : '-',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  hotel.description != null ? hotel.description! : '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    // TODO: Điều hướng sang trang chi tiết khách sạn
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'XEM CHI TIẾT',
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
