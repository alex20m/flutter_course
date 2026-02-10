import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/finance_controller.dart';
import '../models/transaction.dart';
import '../widgets/responsive_scaffold.dart';
import 'transaction_form_screen.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    final FinanceController controller = Get.find<FinanceController>();

    return ResponsiveScaffold(
      destination: AppDestination.transactions,
      child: Obx(
        () {
          final FinanceTransaction? tx = controller.byId(id);

          if (tx == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Transaction not found.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Get.offAllNamed('/transactions'),
                    child: const Text('Back to list'),
                  ),
                ],
              ),
            );
          }

          final bool isIncome = tx.isIncome;
          final Color color = isIncome ? Colors.green : Colors.red;
          final String sign = isIncome ? '+' : '-';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Transaction details',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            tx.description,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '$sign${tx.amount.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: color),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: <Widget>[
                          Chip(
                            avatar: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              size: 18,
                            ),
                            label: Text(isIncome ? 'Income' : 'Expense'),
                          ),
                          Chip(
                            label: Text('Category: ${tx.category}'),
                          ),
                          Chip(
                            label: Text('Date: ${_formatDate(tx.date)}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              TransactionFormScreen(existing: tx),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      final bool? confirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete transaction'),
                          content: const Text(
                            'Are you sure you want to delete this transaction?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await controller.removeById(tx.id);
                        if (context.mounted) {
                          Get.offAllNamed('/transactions');
                        }
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ],
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

