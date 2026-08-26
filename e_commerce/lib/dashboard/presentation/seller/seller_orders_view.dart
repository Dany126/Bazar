import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/dashboard_shell.dart';
import 'seller_nav.dart';
import 'widgets/seller_order_row.dart';
import 'widgets/seller_order_table.dart';

/// Seller: Orders — list of orders placed against this seller's store.
class SellerOrdersView extends StatelessWidget {
  const SellerOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Seller Admin',
      navItems: buildSellerNavItems(SellerSection.orders),
      sidebarCtaLabel: 'Add New Product',
      onSidebarCtaTap: () {},
      topBarBrand: 'Clot Marketplace',
      sidebarLight: true,
      topBarLight: true,
      bodyBackground: DashboardColors.contentBgDark,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Orders', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Manage and fulfill customer orders for your store.',
                        style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5)),
                  ],
                ),
                Row(
                  children: [
                    PrimaryPillButton(label: 'Filter', icon: Icons.filter_list_rounded, outlined: true, onPressed: () {}),
                    const SizedBox(width: 12),
                    PrimaryPillButton(label: 'Export', icon: Icons.upload_rounded, onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'NEW ORDERS',
                    value: '12',
                    icon: Icons.fiber_new_rounded,
                    footnote: 'Awaiting fulfillment',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'PROCESSING',
                    value: '48',
                    icon: Icons.hourglass_empty_rounded,
                    iconColor: DashboardColors.warning,
                    footnote: 'In fulfillment queue',
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'SHIPPED THIS WEEK',
                    value: '22',
                    icon: Icons.local_shipping_outlined,
                    footnote: '+7% vs last week',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'RETURNS',
                    value: '2',
                    icon: Icons.replay_rounded,
                    iconColor: DashboardColors.danger,
                    footnote: 'Requires review',
                    footnoteColor: DashboardColors.danger,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SellerOrderTable(
              totalCount: 48,
              rows: const [
                SellerOrderRowData(orderId: '#ORD-9021', customer: 'Jane Doe', date: 'Oct 24, 2027', itemsCount: 3, total: '\$152.40', status: 'Processing', statusTone: StatusTone.warning),
                SellerOrderRowData(orderId: '#ORD-9020', customer: 'Alex Wolf', date: 'Oct 24, 2027', itemsCount: 1, total: '\$89.00', status: 'Delivered', statusTone: StatusTone.success),
                SellerOrderRowData(orderId: '#ORD-9019', customer: 'Sam Adams', date: 'Oct 23, 2027', itemsCount: 1, total: '\$419.25', status: 'Processing', statusTone: StatusTone.warning),
                SellerOrderRowData(orderId: '#ORD-9018', customer: 'Paul Bloom', date: 'Oct 23, 2027', itemsCount: 1, total: '\$120.75', status: 'Cancelled', statusTone: StatusTone.danger),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
