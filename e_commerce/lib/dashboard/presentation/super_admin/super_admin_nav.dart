import 'package:flutter/material.dart';
import '../widgets/sidebar/sidebar_nav_item.dart';

enum SuperAdminSection {
  overview,
  sellers,
  products,
  orders,
  customers,
  payouts,
  categories,
  reports,
  settings,
}

const _labels = {
  SuperAdminSection.overview: 'Overview',
  SuperAdminSection.sellers: 'Sellers',
  SuperAdminSection.products: 'Products',
  SuperAdminSection.orders: 'Orders',
  SuperAdminSection.customers: 'Customers',
  SuperAdminSection.payouts: 'Payouts',
  SuperAdminSection.categories: 'Categories',
  SuperAdminSection.reports: 'Reports',
  SuperAdminSection.settings: 'Settings',
};

const _icons = {
  SuperAdminSection.overview: Icons.dashboard_rounded,
  SuperAdminSection.sellers: Icons.people_outline_rounded,
  SuperAdminSection.products: Icons.inventory_2_outlined,
  SuperAdminSection.orders: Icons.shopping_cart_outlined,
  SuperAdminSection.customers: Icons.person_outline_rounded,
  SuperAdminSection.payouts: Icons.account_balance_wallet_outlined,
  SuperAdminSection.categories: Icons.category_outlined,
  SuperAdminSection.reports: Icons.bar_chart_rounded,
  SuperAdminSection.settings: Icons.settings_outlined,
};

/// Builds the full Super Admin sidebar nav list with [selected] highlighted.
List<SidebarNavItemData> buildSuperAdminNavItems(SuperAdminSection selected) {
  return SuperAdminSection.values
      .map((s) => SidebarNavItemData(icon: _icons[s]!, label: _labels[s]!, selected: s == selected))
      .toList();
}
