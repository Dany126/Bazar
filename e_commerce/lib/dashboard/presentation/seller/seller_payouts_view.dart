import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/dashboard_shell.dart';
import 'seller_nav.dart';
import 'widgets/earnings_over_time_chart.dart';
import 'widgets/recent_payouts_card.dart';

/// Seller: Payouts — earnings summary, next payout date, and payout history.
class SellerPayoutsView extends StatelessWidget {
  const SellerPayoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Seller Admin',
      navItems: buildSellerNavItems(SellerSection.payouts),
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
                    Text('Payouts', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Manage your earnings and payout schedule.', style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5)),
                  ],
                ),
                Row(
                  children: [
                    PrimaryPillButton(label: 'Tax Forms', icon: Icons.description_outlined, outlined: true, onPressed: () {}),
                    const SizedBox(width: 12),
                    PrimaryPillButton(label: 'Payout Method', icon: Icons.account_balance_wallet_outlined, onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(
                    child: StatCard(
                      label: 'AVAILABLE BALANCE',
                      value: '\$4,230.00',
                      icon: Icons.account_balance_wallet_outlined,
                      footnote: '+18% this month',
                      footnoteColor: DashboardColors.success,
                      background: DashboardColors.cardBgDark,
                      valueColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: StatCard(
                      label: 'PENDING CLEARANCE',
                      value: '\$850.00',
                      icon: Icons.hourglass_empty_rounded,
                      iconColor: DashboardColors.warning,
                      footnote: 'Clears in 3 days',
                      background: DashboardColors.cardBgDark,
                      valueColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: StatCard(
                      label: 'LIFETIME EARNINGS',
                      value: '\$48.2k',
                      icon: Icons.savings_outlined,
                      background: DashboardColors.cardBgDark,
                      valueColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: DashboardColors.accent, borderRadius: BorderRadius.circular(16)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NEXT PAYOUT', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                          SizedBox(height: 10),
                          Text('Oct 31', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                          SizedBox(height: 6),
                          Text('Auto-transfer scheduled', style: TextStyle(color: Colors.white70, fontSize: 10.5)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: EarningsOverTimeChart(points: const [10, 14, 12, 18, 30, 24, 28, 40, 36, 48])),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: RecentPayoutsCard(
                      rows: [
                        RecentPayoutRowData(method: 'Bank Transfer', date: 'Oct 15, 2027', amount: '\$3,140.00', status: 'Paid', statusTone: StatusTone.success, icon: Icons.account_balance_outlined, iconColor: DashboardColors.success),
                        RecentPayoutRowData(method: 'Bank Transfer', date: 'Sep 30, 2027', amount: '\$2,890.00', status: 'Paid', statusTone: StatusTone.success, icon: Icons.account_balance_outlined, iconColor: DashboardColors.success),
                        RecentPayoutRowData(method: 'PayPal', date: 'Sep 15, 2027', amount: '\$980.00', status: 'Processing', statusTone: StatusTone.warning, icon: Icons.account_balance_wallet_outlined, iconColor: DashboardColors.warning),
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
