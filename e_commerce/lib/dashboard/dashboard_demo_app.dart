import 'package:flutter/material.dart';
import 'presentation/dashboard_navigation.dart';
import 'presentation/seller/order_detail_view.dart';
import 'presentation/seller/seller_orders_view.dart';
import 'presentation/seller/seller_overview_view.dart';
import 'presentation/seller/seller_payouts_view.dart';
import 'presentation/seller/seller_products_view.dart';
import 'presentation/seller/seller_customers_view.dart';
import 'presentation/seller/seller_reports_view.dart';
import 'presentation/seller/seller_reviews_view.dart';
import 'presentation/seller/store_settings_view.dart';
import 'presentation/super_admin/categories_management_view.dart';
import 'presentation/super_admin/customers_directory_view.dart';
import 'presentation/super_admin/payouts_queue_view.dart';
import 'presentation/super_admin/platform_orders_view.dart';
import 'presentation/super_admin/platform_products_view.dart';
import 'presentation/super_admin/platform_settings_view.dart';
import 'presentation/super_admin/reports_analytics_view.dart';
import 'presentation/super_admin/seller_approval_view.dart';
import 'presentation/super_admin/super_admin_overview_view.dart';
import 'presentation/super_admin/super_admin_sellers_view.dart';

/// Standalone demo so every screen can be previewed without wiring
/// them into FruitHUB's real routing yet. Not part of the production tree.
class DashboardDemoApp extends StatefulWidget {
  const DashboardDemoApp({super.key});

  @override
  State<DashboardDemoApp> createState() => _DashboardDemoAppState();
}

class _DashboardDemoAppState extends State<DashboardDemoApp> {
  int _index = 0;

  static const _labels = [
    'Seller: Overview',
    'Seller: My Products',
    'Seller: Orders',
    'Seller: Order Detail',
    'Seller: Payouts',
    'Seller: Reviews',
    'Seller: Store Settings',
    'Admin: Overview',
    'Admin: Sellers',
    'Admin: Seller Approval',
    'Admin: Products',
    'Admin: Orders',
    'Admin: Customers',
    'Admin: Payouts',
    'Admin: Categories',
    'Admin: Reports',
    'Admin: Settings',
  ];

  static const _screens = [
    SellerOverviewView(storeName: 'Urban Sole'),
    SellerProductsView(),
    SellerOrdersView(),
    OrderDetailView(orderId: '#ORD-9021'),
    SellerPayoutsView(),
    SellerReviewsView(),
    StoreSettingsView(),
    SellerCustomersView(),
    SellerReportsView(),
    SuperAdminOverviewView(),
    SuperAdminSellersView(),
    SellerApprovalView(),
    PlatformProductsView(),
    PlatformOrdersView(),
    CustomersDirectoryView(),
    PayoutsQueueView(),
    CategoriesManagementView(),
    ReportsAnalyticsView(),
    PlatformSettingsView(),
  ];

  static const _sellerScreenIndexes = [0, 2, 1, 5, 7, 4, 8, 9, 6];
  static const _adminScreenIndexes = [9, 10, 12, 13, 14, 15, 16, 17, 18];

  void _selectSidebarDestination(int sidebarIndex) {
    final screenIndexes = _index < 9
        ? _sellerScreenIndexes
        : _adminScreenIndexes;
    final screenIndex = screenIndexes[sidebarIndex];
    if (screenIndex >= 0) {
      setState(() => _index = screenIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Inter'),
      home: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              scrollable: true,
              destinations: [
                for (final l in _labels)
                  NavigationRailDestination(
                    icon: const Icon(Icons.circle, size: 8),
                    label: Text(l, style: const TextStyle(fontSize: 10)),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: DashboardNavigationScope(
                onNavItemTap: _selectSidebarDestination,
                child: _screens[_index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
