class Hotel {
  final int id;
  final String name;
  final String address;
  final String description;
  final int starRating;
  final String thumbnailUrl;

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.starRating,
    required this.thumbnailUrl,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      starRating: json['star_rating'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}
