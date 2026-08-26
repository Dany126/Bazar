import 'package:flutter/material.dart';
import '../widgets/sidebar/sidebar_nav_item.dart';

enum SellerSection {
  overview,
  orders,
  products,
  reviews,
  customers,
  payouts,
  discounts,
  reports,
  settings,
}

const _labels = {
  SellerSection.overview: 'Overview',
  SellerSection.orders: 'Orders',
  SellerSection.products: 'Products',
  SellerSection.reviews: 'Reviews',
  SellerSection.customers: 'Customers',
  SellerSection.payouts: 'Payouts',
  SellerSection.discounts: 'Discounts',
  SellerSection.reports: 'Reports',
  SellerSection.settings: 'Settings',
};

const _icons = {
  SellerSection.overview: Icons.dashboard_rounded,
  SellerSection.orders: Icons.receipt_long_outlined,
  SellerSection.products: Icons.inventory_2_outlined,
  SellerSection.reviews: Icons.star_outline_rounded,
  SellerSection.customers: Icons.person_outline_rounded,
  SellerSection.payouts: Icons.account_balance_wallet_outlined,
  SellerSection.discounts: Icons.sell_outlined,
  SellerSection.reports: Icons.bar_chart_rounded,
  SellerSection.settings: Icons.settings_outlined,
};

/// Builds the full Seller sidebar nav list with [selected] highlighted.
List<SidebarNavItemData> buildSellerNavItems(SellerSection selected) {
  return SellerSection.values
      .map((s) => SidebarNavItemData(icon: _icons[s]!, label: _labels[s]!, selected: s == selected))
      .toList();
}
