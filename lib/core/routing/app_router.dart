import 'package:flutter/material.dart';

import '../localization/locale_controller.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/customers/screens/customers_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/production/screens/production_screen.dart';
import '../../features/materials/screens/materials_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/employees/screens/employees_screen.dart';
import '../../features/cutting/screens/cutting_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, {
    required LocaleController localeController,
  }) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case RouteNames.login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case RouteNames.dashboard:
        return MaterialPageRoute<void>(
          // Keep using the app-wide controller while placing its selector on Dashboard.
          builder: (_) => DashboardScreen(localeController: localeController),
          settings: settings,
        );
      case RouteNames.reports:
        return MaterialPageRoute<void>(
          builder: (_) => const ReportsScreen(),
          settings: settings,
        );
      case RouteNames.customers:
        return MaterialPageRoute<void>(
          builder: (_) => const CustomersScreen(),
          settings: settings,
        );
      case RouteNames.orders:
        return MaterialPageRoute<void>(
          builder: (_) => const OrdersScreen(),
          settings: settings,
        );
      case RouteNames.production:
        return MaterialPageRoute<void>(
          builder: (_) => const ProductionScreen(),
          settings: settings,
        );
      case RouteNames.materials:
        return MaterialPageRoute<void>(
          builder: (_) => MaterialsScreen(localeController: localeController),
          settings: settings,
        );
      case RouteNames.employees:
        return MaterialPageRoute<void>(
          builder: (_) => const EmployeesScreen(),
          settings: settings,
        );
      // Locale state is shared with the app even while Cutting has no data source.
      case RouteNames.cutting:
        return MaterialPageRoute<void>(
          // Pass the app-wide locale controller for the Cutting language menu.
          builder: (_) => CuttingScreen(localeController: localeController),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
          settings: settings,
        );
    }
  }
}
