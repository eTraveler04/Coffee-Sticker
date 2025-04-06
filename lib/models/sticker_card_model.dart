import 'package:cloud_firestore/cloud_firestore.dart';

class StickerCard {
  final String id;
  final List<bool> spots; // true = naklejka przyklejona
  final DateTime createdAt;
  final bool isComplete;

  StickerCard({
    required this.id,
    required this.spots,
    required this.createdAt,
    required this.isComplete,
  });

  factory StickerCard.empty(String id) {
    return StickerCard(
      id: id,
      spots: List.generate(10, (_) => false),
      createdAt: DateTime.now(),
      isComplete: false,
    );
  }

  factory StickerCard.fromMap(String id, Map<String, dynamic> data) {
    return StickerCard(
      id: id,
      spots: List<bool>.from(data['spots']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isComplete: data['isComplete'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'spots': spots, 'createdAt': createdAt, 'isComplete': isComplete};
  }

  int get filledCount => spots.where((s) => s).length;
  bool get isFull => filledCount == 10;
}
