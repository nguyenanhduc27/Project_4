class Room {
  final String name;
  final String imagePath;
  final String bedInfo;
  final String guestInfo;
  final String price;
  final String? oldPrice;

  Room({
    required this.name,
    required this.imagePath,
    required this.bedInfo,
    required this.guestInfo,
    required this.price,
    this.oldPrice,
  });
}
