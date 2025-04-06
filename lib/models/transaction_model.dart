import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String userId;
  final double amount;
  final String receiptUrl;
  final bool approved;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.receiptUrl,
    required this.approved,
    required this.createdAt,
  });

  factory Transaction.fromMap(String id, Map<String, dynamic> data) {
    return Transaction(
      id: id,
      userId: data['userId'],
      amount: (data['amount'] ?? 0).toDouble(),
      receiptUrl: data['receiptUrl'] ?? '',
      approved: data['approved'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'receiptUrl': receiptUrl,
      'approved': approved,
      'createdAt': createdAt,
    };
  }
}
