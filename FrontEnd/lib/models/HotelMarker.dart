class HotelMarker {
  final String name;
  final double price;
  final double latitude;
  final double longitude;
  final String? image;

  HotelMarker({
    required this.name,
    required this.price,
    required this.latitude,
    required this.longitude,
    this.image,
  });
}
