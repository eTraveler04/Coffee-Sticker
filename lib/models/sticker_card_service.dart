import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sticker_card_model.dart';

class StickerCardService {
  static Future<void> addCardForUser(String userId) async {
    final cardRef =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cards')
            .doc();

    final card = StickerCard.empty(cardRef.id);
    await cardRef.set(card.toMap());
  }

  static Future<List<StickerCard>> getCardsForUser(String userId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cards')
            .orderBy('createdAt', descending: true)
            .get();

    return snapshot.docs
        .map((doc) => StickerCard.fromMap(doc.id, doc.data()))
        .toList();
  }

  static Future<void> updateCard(String userId, StickerCard card) async {
    final cardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(card.id);

    await cardRef.set(card.toMap());
  }

  static Future<void> fillNextSpot(String userId) async {
    final cards = await getCardsForUser(userId);

    // Znajdź pierwszą niepełną kartę
    final currentCard = cards.firstWhere(
      (card) => !card.isFull,
      orElse: () => StickerCard.empty('placeholder'),
    );

    if (currentCard.id == 'placeholder') {
      await addCardForUser(userId);
      return;
    }

    final updatedSpots = [...currentCard.spots];
    final index = updatedSpots.indexWhere((e) => !e);
    if (index != -1) {
      updatedSpots[index] = true;
    }

    final updatedCard = StickerCard(
      id: currentCard.id,
      spots: updatedSpots,
      createdAt: currentCard.createdAt,
      isComplete: !updatedSpots.contains(false),
    );

    await updateCard(userId, updatedCard);
  }
}
