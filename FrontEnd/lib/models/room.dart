class Room {
  final int id;
  final int hotelId;
  final String name;
  final String bedInfo;
  final int guestCount;
  final double price;
  final String description;
  final List<String> imageUrls;

  Room({
    required this.id,
    required this.hotelId,
    required this.name,
    required this.bedInfo,
    required this.guestCount,
    required this.price,
    required this.description,
    required this.imageUrls,
  });
}
