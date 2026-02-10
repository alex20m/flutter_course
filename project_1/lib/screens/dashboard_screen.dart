import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/finance_controller.dart';
import '../models/transaction.dart';
import '../widgets/responsive_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FinanceController controller = Get.find<FinanceController>();

    return ResponsiveScaffold(
      destination: AppDestination.dashboard,
      child: Obx(
        () {
          final List<FinanceTransaction> all =
              controller.transactions.toList()
                ..sort(
                  (FinanceTransaction a, FinanceTransaction b) =>
                      b.date.compareTo(a.date),
                );
          final List<FinanceTransaction> recent =
              all.length > 5 ? all.sublist(0, 5) : all;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  _SummaryCard(
                    title: 'Total income',
                    value: controller.totalIncome,
                    color: Colors.green,
                  ),
                  _SummaryCard(
                    title: 'Total expenses',
                    value: controller.totalExpense,
                    color: Colors.red,
                  ),
                  _SummaryCard(
                    title: 'Net balance',
                    value: controller.netBalance,
                    color: controller.netBalance >= 0
                        ? Colors.blue
                        : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Recent transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    onPressed: () => Get.toNamed('/transactions'),
                    icon: const Icon(Icons.list_alt_outlined),
                    label: const Text('View all'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: recent.isEmpty
                    ? const Center(
                        child: Text('No transactions yet. Add your first one!'),
                      )
                    : ListView.builder(
                        itemCount: recent.length,
                        itemBuilder: (BuildContext context, int index) {
                          final FinanceTransaction tx = recent[index];
                          return _TransactionListTile(tx: tx);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        color: color.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Text(
                value.toStringAsFixed(2),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionListTile extends StatelessWidget {
  const _TransactionListTile({required this.tx});

  final FinanceTransaction tx;

  @override
  Widget build(BuildContext context) {
    final bool isIncome = tx.isIncome;
    final Color color = isIncome ? Colors.green : Colors.red;
    final String sign = isIncome ? '+' : '-';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: color,
          ),
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
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

