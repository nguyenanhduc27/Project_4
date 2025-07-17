import '../utils/url_helper.dart';

class Hotel {
  final int id;
  final String name;
  final String address;
  final String description;
  final int starRating;
  final String city; // Thêm trường city
  final String? thumbnailUrl;
  final List<String> imageUrls;
  final List<String>? amenities;

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.starRating,
    required this.city, // Thêm vào constructor
    this.thumbnailUrl,
    required this.imageUrls,
    this.amenities,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      starRating: json['starRating'] ?? json['star_rating'] ?? 0,
      city: json['city'] ?? '', // Parse từ json
      thumbnailUrl: UrlHelper.normalizeImageUrl(json['thumbnailUrl']),
      imageUrls: (json['imageUrls'] as List<dynamic>? ?? []).map((e) => UrlHelper.normalizeImageUrl(e as String)).toList(),
      amenities: (json['amenities'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}
