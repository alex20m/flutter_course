import 'package:flutter/foundation.dart';

@immutable
class FinanceTransaction {
  const FinanceTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.isIncome,
  });

  final String id;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final bool isIncome;

  FinanceTransaction copyWith({
    String? id,
    String? description,
    double? amount,
    String? category,
    DateTime? date,
    bool? isIncome,
  }) {
    return FinanceTransaction(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'isIncome': isIncome,
    };
  }

  factory FinanceTransaction.fromJson(Map<String, Object?> json) {
    return FinanceTransaction(
      id: json['id']! as String,
      description: json['description']! as String,
      amount: (json['amount']! as num).toDouble(),
      category: json['category']! as String,
      date: DateTime.parse(json['date']! as String),
      isIncome: json['isIncome']! as bool,
    );
  }
}

