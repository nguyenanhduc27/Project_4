class Hotel {
  final int id;
  final String name;
  final String address;
  final String city;
  final String description;
  final int starRating;
  final int ownerId;
  final DateTime createdAt;

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.description,
    required this.starRating,
    required this.ownerId,
    required this.createdAt,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      description: json['description'],
      starRating: json['star_rating'],
      ownerId: json['owner_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'description': description,
      'star_rating': starRating,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
