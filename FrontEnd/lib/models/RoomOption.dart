class RoomOption {
  final int id;
  final String type;
  final String bedInfo;
  final int guestCount;
  final double price;
  final bool freeCancellation;
  final bool payLater;

  RoomOption({
    required this.id, 
    required this.type,
    required this.bedInfo,
    required this.guestCount,
    required this.price,
    required this.freeCancellation,
    required this.payLater,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'bedInfo': bedInfo,
      'guestCount': guestCount,
      'price': price,
      'freeCancellation': freeCancellation,
      'payLater': payLater,
    };
  }
}
