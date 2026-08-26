import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/dashboard_shell.dart';
import 'super_admin_nav.dart';
import 'widgets/comparison_line_chart.dart';
import 'widgets/top_performers_table.dart';

/// Super Admin: Reports & Analytics — date-ranged KPIs, comparison chart,
/// and category/marketplace rankings.
class ReportsAnalyticsView extends StatelessWidget {
  const ReportsAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Super Admin',
      navItems: buildSuperAdminNavItems(SuperAdminSection.reports),
      sidebarCtaLabel: 'Add New Seller',
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
                    Text('Reports & Analytics', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Platform performance over a custom date range.',
                        style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5)),
                  ],
                ),
                Row(
                  children: [
                    PrimaryPillButton(label: 'Last 30 Days', icon: Icons.calendar_today_outlined, outlined: true, onPressed: () {}),
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
                    label: 'GMV',
                    value: '\$2.8M',
                    icon: Icons.attach_money_rounded,
                    footnote: '+11% vs prior period',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'ORDERS',
                    value: '63,291',
                    icon: Icons.shopping_bag_outlined,
                    footnote: '+6% vs prior period',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'NEW SELLERS',
                    value: '1,082',
                    icon: Icons.storefront_outlined,
                    footnote: '+9% vs prior period',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'AVG ORDER VALUE',
                    value: '\$38.45',
                    icon: Icons.trending_down_rounded,
                    iconColor: DashboardColors.danger,
                    footnote: '-2% vs prior period',
                    footnoteColor: DashboardColors.danger,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ComparisonLineChart(
              title: 'Revenue vs Orders',
              seriesALabel: 'Revenue',
              seriesBLabel: 'Orders',
              seriesA: const [20, 26, 24, 40, 45, 42, 52, 60, 58, 68],
              seriesB: const [15, 18, 22, 24, 28, 34, 30, 38, 40, 36],
            ),
            const SizedBox(height: 20),
            TopPerformersTable(
              rows: const [
                TopPerformerRowData(name: 'Footwear', orders: '2,148', revenue: '\$412,300', growthLabel: '+12.4%', growthPositive: true),
                TopPerformerRowData(name: 'Home Goods', orders: '1,532', revenue: '\$298,150', growthLabel: '+7.1%', growthPositive: true),
                TopPerformerRowData(name: 'Apparel', orders: '984', revenue: '\$154,900', growthLabel: '-3.2%', growthPositive: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
