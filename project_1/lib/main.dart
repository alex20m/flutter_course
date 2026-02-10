import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'controllers/finance_controller.dart';
import 'screens/dashboard_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/transaction_detail_screen.dart';
import 'screens/transaction_form_screen.dart';
import 'screens/transactions_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('storage');
  Get.put<FinanceController>(FinanceController(), permanent: true);
  runApp(
    const FinanceApp(),
  );
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Personal Finance Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: <GetPage<dynamic>>[
        GetPage<dynamic>(
          name: '/',
          page: () => const DashboardScreen(),
        ),
        GetPage<dynamic>(
          name: '/transactions',
          page: () => const TransactionsListScreen(),
        ),
        GetPage<dynamic>(
          name: '/transactions/new',
          page: () => const TransactionFormScreen(),
        ),
        GetPage<dynamic>(
          name: '/transactions/:id',
          page: () => TransactionDetailScreen(
            id: Get.parameters['id'] ?? '',
          ),
        ),
        GetPage<dynamic>(
          name: '/stats',
          page: () => const StatsScreen(),
        ),
      ],
    );
  }
}

