class RoomOption {
  final String type;
  final String bedInfo;
  final int guestCount;
  final double price;
  final bool freeCancellation;
  final bool payLater;

  RoomOption({
    required this.type,
    required this.bedInfo,
    required this.guestCount,
    required this.price,
    required this.freeCancellation,
    required this.payLater,
  });
}
