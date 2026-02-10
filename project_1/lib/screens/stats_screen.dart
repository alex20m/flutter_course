import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/finance_controller.dart';
import '../widgets/responsive_scaffold.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FinanceController controller = Get.find<FinanceController>();

    return ResponsiveScaffold(
      destination: AppDestination.stats,
      child: Obx(
        () {
          final Map<String, double> incomeByCategory =
              controller.totalsByCategory(isIncome: true);
          final Map<String, double> expenseByCategory =
              controller.totalsByCategory(isIncome: false);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Statistics',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: <Widget>[
                    _StatNumberCard(
                      title: 'Total income',
                      value: controller.totalIncome,
                      color: Colors.green,
                    ),
                    _StatNumberCard(
                      title: 'Total expenses',
                      value: controller.totalExpense,
                      color: Colors.red,
                    ),
                    _StatNumberCard(
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
                  children: <Widget>[
                    Expanded(
                      child: _CategoryBreakdownCard(
                        title: 'Income by category',
                        data: incomeByCategory,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _CategoryBreakdownCard(
                        title: 'Expenses by category',
                        data: expenseByCategory,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatNumberCard extends StatelessWidget {
  const _StatNumberCard({
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

class _CategoryBreakdownCard extends StatelessWidget {
  const _CategoryBreakdownCard({
    required this.title,
    required this.data,
    required this.color,
  });

  final String title;
  final Map<String, double> data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, double>> entries = data.entries.toList()
      ..sort(
        (MapEntry<String, double> a, MapEntry<String, double> b) =>
            b.value.compareTo(a.value),
      );

    final double total =
        entries.fold<double>(0, (double sum, MapEntry<String, double> e) => sum + e.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              const Text('No data yet.')
            else
              Column(
                children: entries.map<Widget>((MapEntry<String, double> e) {
                  final double percentage =
                      total == 0 ? 0 : (e.value / total);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text(e.key),
                        ),
                        Expanded(
                          flex: 7,
                          child: LinearProgressIndicator(
                            value: percentage,
                            color: color,
                            backgroundColor: color.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(percentage * 100).toStringAsFixed(0)}%',
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

