class HotelImage {
  final int id;
  final int hotelId;
  final String imageUrl;
  final bool isThumbnail;

  HotelImage({
    required this.id,
    required this.hotelId,
    required this.imageUrl,
    required this.isThumbnail,
  });

  factory HotelImage.fromJson(Map<String, dynamic> json) {
    return HotelImage(
      id: json['id'],
      hotelId: json['hotel_id'],
      imageUrl: json['image_url'],
      isThumbnail: json['is_thumbnail'] == 1,
    );
  }
}
