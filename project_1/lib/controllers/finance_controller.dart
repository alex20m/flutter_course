import 'dart:collection';

import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/transaction.dart';

class FinanceController extends GetxController {
  FinanceController() : _transactions = <FinanceTransaction>[].obs;

  final RxList<FinanceTransaction> _transactions;

  UnmodifiableListView<FinanceTransaction> get transactions =>
      UnmodifiableListView<FinanceTransaction>(_transactions);

  Box<dynamic> get _box => Hive.box<dynamic>('storage');

  @override
  void onInit() {
    super.onInit();
    final List<dynamic>? raw =
        _box.get('transactions') as List<dynamic>?;
    if (raw != null) {
      _transactions
        ..clear()
        ..addAll(
          raw
              .cast<Map<dynamic, dynamic>>()
              .map<FinanceTransaction>(
                (Map<dynamic, dynamic> map) => FinanceTransaction.fromJson(
                  map.map<String, Object?>(
                    (dynamic key, dynamic value) =>
                        MapEntry<String, Object?>(key as String, value),
                  ),
                ),
              )
              .toList(),
        );
    }
  }

  Future<void> _save() async {
    await _box.put(
      'transactions',
      _transactions
          .map<Map<String, Object?>>(
            (FinanceTransaction t) => t.toJson(),
          )
          .toList(),
    );
  }

  FinanceTransaction? byId(String id) {
    try {
      return _transactions.firstWhere(
        (FinanceTransaction t) => t.id == id,
      );
    } on StateError {
      return null;
    }
  }

  Future<void> upsert(FinanceTransaction tx) async {
    final int index = _transactions.indexWhere(
      (FinanceTransaction t) => t.id == tx.id,
    );
    if (index == -1) {
      _transactions.add(tx);
    } else {
      _transactions[index] = tx;
    }
    await _save();
  }

  Future<void> removeById(String id) async {
    _transactions.removeWhere(
      (FinanceTransaction t) => t.id == id,
    );
    await _save();
  }

  double get totalIncome => _transactions
      .where((FinanceTransaction t) => t.isIncome)
      .fold<double>(
        0,
        (double sum, FinanceTransaction t) => sum + t.amount,
      );

  double get totalExpense => _transactions
      .where((FinanceTransaction t) => !t.isIncome)
      .fold<double>(
        0,
        (double sum, FinanceTransaction t) => sum + t.amount,
      );

  double get netBalance => totalIncome - totalExpense;

  Map<String, double> totalsByCategory({bool? isIncome}) {
    final Map<String, double> result = <String, double>{};
    for (final FinanceTransaction tx in _transactions) {
      if (isIncome != null && tx.isIncome != isIncome) {
        continue;
      }
      result.update(
        tx.category,
        (double value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }
    return result;
  }
}

