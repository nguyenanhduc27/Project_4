class HotelImage {
  final int id;
  final int hotelId;
  final String imageUrl;
  final bool isThumbnail;

  HotelImage({
    required this.id,
    required this.hotelId,
    required this.imageUrl,
    this.isThumbnail = false,
  });

  factory HotelImage.fromJson(Map<String, dynamic> json) {
    return HotelImage(
      id: json['id'],
      hotelId: json['hotel_id'],
      imageUrl: json['image_url'],
      isThumbnail: (json['is_thumbnail'] == 1 || json['is_thumbnail'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'image_url': imageUrl,
      'is_thumbnail': isThumbnail ? 1 : 0,
    };
  }
}
