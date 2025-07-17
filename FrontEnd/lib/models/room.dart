class RoomType {
  final int id;
  final String name;
  final String description;
  final double price;
  final int maxGuests;
  final int? doubleBed;
  final double? area;
  final bool? isAvailable;
  final String? roomImage;
  final List<String> amenities;
  final int availableRooms;

  RoomType({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.maxGuests,
    this.doubleBed,
    this.area,
    this.isAvailable,
    this.roomImage,
    required this.amenities,
    this.availableRooms = 0,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      maxGuests: json['maxGuests'] ?? 0,
      doubleBed: json['doubleBed'],
      area: json['area']?.toDouble(),
      isAvailable: json['isAvailable'],
      roomImage: json['roomImage'],
      amenities: (json['amenities'] as List<dynamic>? ?? []).cast<String>(),
      availableRooms: json['availableRooms'] ?? 0,
    );
  }
}

class Room {
  final int id;
  final int hotelId;
  final RoomType? roomType;

  Room({
    required this.id,
    required this.hotelId,
    this.roomType,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      hotelId: json['hotelId'],
      roomType: json['roomType'] != null ? RoomType.fromJson(json['roomType']) : null,
    );
  }
}
