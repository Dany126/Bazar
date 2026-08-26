import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/dashboard_shell.dart';
import 'super_admin_nav.dart';
import 'widgets/recent_activity_card.dart';
import 'widgets/recent_activity_tile.dart';
import 'widgets/revenue_over_time_chart.dart';

/// Super Admin: Overview — platform-wide KPIs, revenue chart, activity feed.
class SuperAdminOverviewView extends StatelessWidget {
  const SuperAdminOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Super Admin',
      navItems: buildSuperAdminNavItems(SuperAdminSection.overview),
      sidebarCtaLabel: 'Add New Seller',
      onSidebarCtaTap: () {},
      topBarBrand: 'Clot Marketplace',
      topBarBadge: 'Super Admin',
      showTopBarBrand: false,
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
                    Text(
                      'Platform Overview',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Platform-wide metrics and recent activity.',
                      style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5),
                    ),
                  ],
                ),
                Row(
                  children: [
                    PrimaryPillButton(label: 'Export Report', outlined: true, onPressed: () {}),
                    const SizedBox(width: 12),
                    PrimaryPillButton(
                      label: 'View All Sellers',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'TOTAL REVENUE',
                    value: '\$1.2M',
                    icon: Icons.show_chart_rounded,
                    footnote: '+12% this month',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'TOTAL ORDERS',
                    value: '8.4k',
                    icon: Icons.chat_bubble_outline_rounded,
                    footnote: '+8% this month',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'ACTIVE SELLERS',
                    value: '142',
                    icon: Icons.tune_rounded,
                    footnote: '+5 this week',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'PENDING APPROVALS',
                    value: '12',
                    icon: Icons.lock_clock_outlined,
                    iconColor: DashboardColors.warning,
                    footnote: 'Action needed',
                    footnoteColor: DashboardColors.warning,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: RevenueOverTimeChart(points: const [20, 22, 24, 40, 55, 52, 60, 78, 72, 88]),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: RecentActivityCard(
                      items: [
                        RecentActivityTile(
                          icon: Icons.inventory_2_outlined,
                          iconColor: DashboardColors.accent,
                          title: 'Urban Sole added 5 new products',
                          time: '2 minutes ago',
                        ),
                        RecentActivityTile(
                          icon: Icons.check_circle_outline_rounded,
                          iconColor: DashboardColors.success,
                          title: 'Madewell Home joined the marketplace',
                          time: '1 hour ago',
                        ),
                        RecentActivityTile(
                          icon: Icons.payments_outlined,
                          iconColor: DashboardColors.warning,
                          title: 'Payout initiated for 14 sellers',
                          time: '3 hours ago',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
