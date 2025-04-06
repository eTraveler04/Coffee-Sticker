class AppUser {
  final String id;
  final String email;
  final String managerId;
  final double balance;
  final int stickers;

  AppUser({
    required this.id,
    required this.email,
    required this.managerId,
    required this.balance,
    required this.stickers,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      email: data['email'],
      managerId: data['managerId'],
      balance: (data['balance'] ?? 0).toDouble(),
      stickers: (data['stickers'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'managerId': managerId,
      'balance': balance,
      'stickers': stickers,
    };
  }
}
