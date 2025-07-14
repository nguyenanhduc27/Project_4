class Hotel {
  final int id;
  final String name;
  final String address;
  final String description;
  final int starRating;
  final String thumbnailUrl;
  final String city; // Thêm trường city

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.starRating,
    required this.thumbnailUrl,
    required this.city, // Thêm vào constructor
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      starRating: json['starRating'] ?? json['star_rating'] ?? 0,
      thumbnailUrl: json['thumbnailUrl'] ?? json['thumbnail_url'] ?? '',
      city: json['city'] ?? '', // Parse từ json
    );
  }
}
