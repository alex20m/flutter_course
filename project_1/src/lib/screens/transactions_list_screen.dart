import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/finance_controller.dart';
import '../models/transaction.dart';
import '../widgets/responsive_scaffold.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  String _filterCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final FinanceController controller = Get.find<FinanceController>();

    return ResponsiveScaffold(
      destination: AppDestination.transactions,
      child: Obx(
        () {
          final List<FinanceTransaction> all =
              controller.transactions.toList()
                ..sort(
                  (FinanceTransaction a, FinanceTransaction b) =>
                      b.date.compareTo(a.date),
                );

          final List<String> categories =
              <String>{'All', ...all.map<String>((FinanceTransaction t) => t.category)}.toList()
                ..sort();

          final List<FinanceTransaction> filtered = _filterCategory == 'All'
              ? all
              : all
                  .where(
                    (FinanceTransaction t) => t.category == _filterCategory,
                  )
                  .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Transactions',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  FilledButton.icon(
                    onPressed: () =>
                        Get.toNamed('/transactions/new'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add transaction'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  const Text('Filter by category:'),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _filterCategory,
                    items: categories
                        .map<DropdownMenuItem<String>>(
                          (String c) => DropdownMenuItem<String>(
                            value: c,
                            child: Text(c),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _filterCategory = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No transactions to show.'))
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 4),
                        itemBuilder: (BuildContext context, int index) {
                          final FinanceTransaction tx = filtered[index];
                          final bool isIncome = tx.isIncome;
                          final Color color =
                              isIncome ? Colors.green : Colors.red;
                          final String sign = isIncome ? '+' : '-';

                          return Card(
                            child: ListTile(
                              leading: Icon(
                                isIncome
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: color,
                              ),
                              title: Text(tx.description),
                              subtitle: Text(
                                '${tx.category} • ${_formatDate(tx.date)}',
                              ),
                              trailing: Text(
                                '$sign${tx.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                              onTap: () =>
                                  Get.toNamed('/transactions/${tx.id}'),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

