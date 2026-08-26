import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../widgets/common/primary_pill_button.dart';
import '../widgets/common/stat_card.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/dashboard_shell.dart';
import 'super_admin_nav.dart';
import 'widgets/seller_registry_table.dart';
import 'widgets/seller_table_row.dart';

/// Super Admin: Sellers Management — platform-wide seller directory
/// with approval flow.
class SuperAdminSellersView extends StatelessWidget {
  const SuperAdminSellersView({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      sidebarTitle: 'Clot Marketplace',
      sidebarSubtitle: 'Super Admin',
      navItems: buildSuperAdminNavItems(SuperAdminSection.sellers),
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
                    Text(
                      'Sellers Management',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage marketplace vendors, review pending applications, and monitor performance.',
                      style: TextStyle(color: DashboardColors.textSecondaryDark, fontSize: 12.5),
                    ),
                  ],
                ),
                Row(
                  children: [
                    PrimaryPillButton(label: 'Filter', icon: Icons.filter_list_rounded, outlined: true, onPressed: () {}),
                    const SizedBox(width: 12),
                    PrimaryPillButton(label: 'Export', icon: Icons.upload_rounded, outlined: true, onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'TOTAL ACTIVE SELLERS',
                    value: '1,248',
                    icon: Icons.people_outline_rounded,
                    footnote: '+18 this month',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'PENDING APPLICATIONS',
                    value: '42',
                    icon: Icons.hourglass_empty_rounded,
                    iconColor: DashboardColors.warning,
                    footnote: 'Requires review',
                    footnoteColor: DashboardColors.warning,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    label: 'TOTAL MARKETPLACE REVENUE',
                    value: '\$2.4M',
                    icon: Icons.pie_chart_outline_rounded,
                    footnote: '+9% this quarter',
                    footnoteColor: DashboardColors.success,
                    background: DashboardColors.cardBgDark,
                    valueColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SellerRegistryTable(
              totalCount: 1248,
              currentPage: 1,
              totalPages: 4,
              rows: [
                SellerRowData(
                  storeName: 'Northfield Home Goods',
                  joinDate: 'Jan 12, 2026',
                  productsCount: '384',
                  totalSales: '\$84,950',
                  status: 'Active',
                  statusTone: StatusTone.success,
                ),
                SellerRowData(
                  storeName: 'Luminous Home Events',
                  joinDate: 'Aug 04, 2026',
                  productsCount: '-',
                  totalSales: '-',
                  status: 'Pending',
                  statusTone: StatusTone.warning,
                  showApproveAction: true,
                ),
                SellerRowData(
                  storeName: 'Kaia Fabrications',
                  joinDate: 'Mar 22, 2026',
                  productsCount: '112',
                  totalSales: '\$18,300',
                  status: 'Restricted',
                  statusTone: StatusTone.info,
                ),
                SellerRowData(
                  storeName: 'Baskue Threads',
                  joinDate: 'Jun 09, 2026',
                  productsCount: '1,265',
                  totalSales: '\$246,100',
                  status: 'Suspended',
                  statusTone: StatusTone.danger,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
