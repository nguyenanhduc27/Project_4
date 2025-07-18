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
  final double latitude;   // Thêm dòng này
  final double longitude;  // Thêm dòng này

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
    required this.latitude,   // Thêm dòng này
    required this.longitude,  // Thêm dòng này
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
      imageUrls: (json['imageUrls'] as List<dynamic>? ?? [])
          .map((e) => UrlHelper.normalizeImageUrl(e as String))
          .toList(),
      amenities: (json['amenities'] as List<dynamic>? ?? []).cast<String>(),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,    // Thêm dòng này
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,  // Thêm dòng này
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'starRating': starRating,
      'city': city,
      'thumbnailUrl': thumbnailUrl,
      'imageUrls': imageUrls,
      'amenities': amenities,
      'latitude': latitude,     // Thêm dòng này
      'longitude': longitude,   // Thêm dòng này
    };
  }
}
