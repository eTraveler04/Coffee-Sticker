class Manager {
  final String id;
  final String email;
  final String inviteCode;
  final double stickerPrice;
  final bool promotionActive;
  final int discountPercent;

  Manager({
    required this.id,
    required this.email,
    required this.inviteCode,
    required this.stickerPrice,
    required this.promotionActive,
    required this.discountPercent,
  });

  factory Manager.fromMap(String id, Map<String, dynamic> data) {
    return Manager(
      id: id,
      email: data['email'],
      inviteCode: data['inviteCode'],
      stickerPrice: (data['stickerPrice'] ?? 0).toDouble(),
      promotionActive: data['promotionActive'] ?? false,
      discountPercent: data['discountPercent'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'inviteCode': inviteCode,
      'stickerPrice': stickerPrice,
      'promotionActive': promotionActive,
      'discountPercent': discountPercent,
    };
  }
}
