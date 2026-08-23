// AppShell — 5-tab NavigationBar shell (Dashboard, Invoices, Estimates, Purchases, More)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _TabItem(
      route: AppRoutes.home,
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: 'Dashboard',
    ),
    _TabItem(
      route: AppRoutes.invoices,
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      label: 'Invoices',
    ),
    _TabItem(
      route: AppRoutes.estimates,
      icon: Icons.description_outlined,
      activeIcon: Icons.description_rounded,
      label: 'Estimates',
    ),
    _TabItem(
      route: AppRoutes.purchases,
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
      label: 'Purchases',
    ),
    _TabItem(
      route: AppRoutes.more,
      icon: Icons.more_horiz_rounded,
      activeIcon: Icons.more_horiz_rounded,
      label: 'More',
    ),
  ];

  int _indexFromLocation(String location) {
    if (location.startsWith(AppRoutes.invoices)) return 1;
    if (location.startsWith(AppRoutes.estimates)) return 2;
    if (location.startsWith(AppRoutes.purchases)) return 3;
    if (location.startsWith(AppRoutes.more)) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => context.go(_tabs[i].route),
        destinations: _tabs
            .map(
              (t) => NavigationDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.activeIcon),
                label: t.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
