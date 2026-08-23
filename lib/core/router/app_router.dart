// App router — all routes, splash-based first-run detection
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../screens/shell/app_shell.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/invoices/invoices_screen.dart';
import '../../screens/invoices/invoice_form_screen.dart';
import '../../screens/estimates/estimates_screen.dart';
import '../../screens/estimates/estimate_form_screen.dart';
import '../../screens/purchases/purchases_list_screen.dart';
import '../../screens/purchases/purchase_bill_form_screen.dart';
import '../../screens/purchases/purchase_bill_detail_screen.dart';
import '../../screens/suppliers/suppliers_list_screen.dart';
import '../../screens/more/more_screen.dart';
import '../../screens/settings/settings_screen.dart';

import '../../screens/customers/customers_list_screen.dart';
import '../../screens/items/items_list_screen.dart';

// ── Route path constants ──────────────────────────────────────────────────────

abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/';
  static const invoices = '/invoices';
  static const invoiceDetail = '/invoices/:id';
  static const newInvoice = '/invoices/new';
  static const estimates = '/estimates';
  static const estimateDetail = '/estimates/:id';
  static const newEstimate = '/estimates/new';
  static const purchases = '/purchases';
  static const newPurchase = '/purchases/new';
  static const purchaseDetail = '/purchases/:id';
  static const suppliers = '/suppliers';
  static const more = '/more';
  static const settings = '/settings';
  static const customers = '/customers';
  static const items = '/items';
}

// ── Router provider ───────────────────────────────────────────────────────────

/// Exposes the GoRouter singleton as a Riverpod Provider.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      // ── Outside shell: splash + onboarding ─────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ── Settings (pushed on top, no bottom nav) ────────────────────────────
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // ── New Invoice ────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.newInvoice,
        name: 'newInvoice',
        builder: (context, state) => const InvoiceFormScreen(),
      ),

      // ── New Estimate ───────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.newEstimate,
        name: 'newEstimate',
        builder: (context, state) => const EstimateFormScreen(),
      ),

      // ── New Purchase Bill ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.newPurchase,
        name: 'newPurchase',
        builder: (context, state) => const PurchaseBillFormScreen(),
      ),

      // ── Purchase Detail ────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.purchaseDetail,
        name: 'purchaseDetail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PurchaseBillDetailScreen(billId: id);
        },
      ),

      // ── Suppliers Directory ────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.suppliers,
        name: 'suppliers',
        builder: (context, state) => const SuppliersListScreen(),
      ),

      // ── Customers ──────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.customers,
        name: 'customers',
        builder: (context, state) => const CustomersListScreen(),
      ),

      // ── Items ──────────────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.items,
        name: 'items',
        builder: (context, state) => const ItemsListScreen(),
      ),

      // ── Shell with bottom navigation ───────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.invoices,
            name: 'invoices',
            builder: (context, state) => const InvoicesScreen(),
          ),
          GoRoute(
            path: AppRoutes.estimates,
            name: 'estimates',
            builder: (context, state) => const EstimatesScreen(),
          ),
          GoRoute(
            path: AppRoutes.purchases,
            name: 'purchases',
            builder: (context, state) => const PurchasesListScreen(),
          ),
          GoRoute(
            path: AppRoutes.more,
            name: 'more',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
