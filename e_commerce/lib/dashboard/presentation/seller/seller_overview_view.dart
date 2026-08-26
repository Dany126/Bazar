import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/dashboard_shell.dart';
import 'seller_nav.dart';
import 'widgets/recent_store_order_tile.dart';
import 'widgets/recent_store_orders_card.dart';
import 'widgets/seller_sales_chart.dart';

/// Seller: Overview — matches the light-content "Welcome back" screen.
class SellerOverviewView extends StatelessWidget {
  const SellerOverviewView({super.key, required this.storeName});

  final String storeName;

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: storeName,
      sidebarSubtitle: 'Seller Admin',
      navItems: buildSellerNavItems(SellerSection.overview),
      sidebarCtaLabel: 'Add New Product',
      onSidebarCtaTap: () {},
      topBarBrand: storeName,
      sidebarLight: true,
      topBarLight: true,
      bodyBackground: DashboardColors.contentBgLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, $storeName',
                        style: const TextStyle(
                          color: DashboardColors.accent,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Here's what's happening with your store today.",
                        style: TextStyle(color: DashboardColors.textSecondaryLight, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                PrimaryPillButton(label: 'Export Report', outlined: true, onPressed: () {}),
              ],
            ),
            const SizedBox(height: 24),
            _StatRow(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: SellerSalesChart(values: const [30, 55, 40, 75, 60, 90, 70])),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: RecentStoreOrdersCard(
                    orders: [
                      RecentStoreOrderTile(
                        productName: 'iPhone 15 Case',
                        orderId: '#ORD-1042',
                        status: 'Pending',
                        tone: orderStatusTone('Pending'),
                      ),
                      RecentStoreOrderTile(
                        productName: 'Nike Tech Fleece Jacket',
                        orderId: '#ORD-1041',
                        status: 'Shipped',
                        tone: orderStatusTone('Shipped'),
                      ),
                      RecentStoreOrderTile(
                        productName: 'Graphic Tee - L',
                        orderId: '#ORD-1039',
                        status: 'Delivered',
                        tone: orderStatusTone('Delivered'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: StatCard(
            label: 'TOTAL REVENUE',
            value: '\$12,450',
            icon: Icons.attach_money_rounded,
            footnote: '+18% vs last week',
            footnoteColor: DashboardColors.success,
            background: DashboardColors.cardBgLight,
            valueColor: DashboardColors.textPrimaryLight,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: StatCard(
            label: 'ORDERS RECEIVED',
            value: '128',
            icon: Icons.shopping_bag_outlined,
            footnote: '12 awaiting fulfillment',
            background: DashboardColors.cardBgLight,
            valueColor: DashboardColors.textPrimaryLight,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: StatCard(
            label: 'ACTIVE LISTINGS',
            value: '45',
            icon: Icons.grid_view_rounded,
            footnote: 'Across 6 categories',
            background: DashboardColors.cardBgLight,
            valueColor: DashboardColors.textPrimaryLight,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: StatCard(
            label: 'LOW STOCK',
            value: '3',
            icon: Icons.warning_amber_rounded,
            iconColor: DashboardColors.danger,
            footnote: 'Needs restocking',
            footnoteColor: DashboardColors.danger,
            background: DashboardColors.cardBgLight,
            valueColor: DashboardColors.danger,
          ),
        ),
      ],
    );
  }
}
