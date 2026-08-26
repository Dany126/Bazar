import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/dashboard_shell.dart';
import 'super_admin_nav.dart';
import 'widgets/payout_queue_row.dart';
import 'widgets/payout_queue_table.dart';

/// Super Admin: Payouts Queue — pending and completed marketplace payouts.
class PayoutsQueueView extends StatelessWidget {
  const PayoutsQueueView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Super Admin',
      navItems: buildSuperAdminNavItems(SuperAdminSection.payouts),
      sidebarCtaLabel: 'Add New Seller',
      onSidebarCtaTap: () {},
      topBarBrand: 'Clot Marketplace',
      topBarBadge: 'Super Admin',
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
                    Text('Payouts Queue', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Platform-wide pending and completed payouts.',
                        style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5)),
                  ],
                ),
                PrimaryPillButton(label: 'Process All Pending', icon: Icons.bolt_rounded, onPressed: () {}),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'TOTAL PENDING',
                    value: '\$45,230.00',
                    icon: Icons.inventory_2_outlined,
                    iconColor: DashboardColors.danger,
                    footnote: 'Requires action',
                    footnoteColor: DashboardColors.danger,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'PAID THIS MONTH',
                    value: '\$1,104,500.00',
                    icon: Icons.check_circle_outline_rounded,
                    footnote: 'Across 214 sellers',
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PayoutQueueTable(
              totalCount: 24,
              rows: [
                PayoutQueueRowData(
                  sellerName: 'Acme Supplies',
                  amount: '\$8,450.00',
                  status: 'Pending',
                  statusTone: StatusTone.warning,
                  dueLabel: 'Today, 5:00 PM',
                ),
                PayoutQueueRowData(
                  sellerName: 'Baskue Threads',
                  amount: '\$12,120.30',
                  status: 'Pending',
                  statusTone: StatusTone.warning,
                  dueLabel: 'Tomorrow',
                ),
                PayoutQueueRowData(
                  sellerName: 'Vintage Sole',
                  amount: '\$3,980.00',
                  status: 'Scheduled',
                  statusTone: StatusTone.info,
                  dueLabel: 'Aug 30',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
